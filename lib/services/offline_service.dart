import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'connectivity_service.dart';

/// Service offline central.
///
/// Responsabilités :
/// 1. Queue des écritures Firestore en attente (pendant la coupure réseau)
/// 2. Cache lecture des entités essentielles (exploitations, parcelles)
/// 3. Drain automatique de la queue lors du retour de connectivité
class OfflineService {
  static final OfflineService instance = OfflineService._();
  OfflineService._();

  Database? _db;
  bool _isSyncing = false;
  StreamSubscription? _connSub;

  static const _dbVersion = 1;
  static const _dbName = 'demeter_offline.db';
  static const _tablePendingWrites = 'pending_writes';
  static const _tableCache = 'entity_cache';
  static const _defaultTtlSeconds = 3600; // 1 heure

  // ── Initialisation ─────────────────────────────────────────────────────────

  Future<void> init() async {
    if (kIsWeb) return; // SQLite non disponible sur Web

    final dbPath = p.join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _createTables,
    );

    // Écouter les retours de connectivité pour déclencher la sync
    _connSub = ConnectivityService.instance.onConnectivityChanged.listen((online) {
      if (online) syncPendingWrites();
    });
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tablePendingWrites (
        id               INTEGER PRIMARY KEY AUTOINCREMENT,
        operation        TEXT    NOT NULL,
        collection       TEXT    NOT NULL,
        doc_id           TEXT,
        data             TEXT    NOT NULL,
        created_at       INTEGER NOT NULL,
        retry_count      INTEGER DEFAULT 0,
        idempotency_key  TEXT    UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE $_tableCache (
        cache_key   TEXT    PRIMARY KEY,
        data        TEXT    NOT NULL,
        updated_at  INTEGER NOT NULL,
        ttl_seconds INTEGER DEFAULT $_defaultTtlSeconds
      )
    ''');
  }

  void dispose() {
    _connSub?.cancel();
    _db?.close();
  }

  // ── Queue des écritures en attente ─────────────────────────────────────────

  /// Enfile une écriture Firestore pour exécution ultérieure.
  /// [operation] : 'create' | 'update' | 'delete'
  /// [idempotencyKey] : clé unique pour éviter les doublons (ex. uuid côté client)
  Future<void> enqueue({
    required String operation,
    required String collection,
    String? docId,
    Map<String, dynamic>? data,
    String? idempotencyKey,
  }) async {
    if (kIsWeb || _db == null) return;

    await _db!.insert(
      _tablePendingWrites,
      {
        'operation': operation,
        'collection': collection,
        'doc_id': docId,
        'data': jsonEncode(data ?? {}),
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'idempotency_key': idempotencyKey,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Retourne le nombre d'écritures en attente.
  Future<int> pendingCount() async {
    if (kIsWeb || _db == null) return 0;
    final result =
        await _db!.rawQuery('SELECT COUNT(*) as c FROM $_tablePendingWrites');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Rejoue toutes les écritures en attente contre Firestore.
  /// Appelé automatiquement lors du retour de connexion.
  Future<void> syncPendingWrites() async {
    if (kIsWeb || _db == null || _isSyncing) return;
    if (!ConnectivityService.instance.isOnline) return;

    _isSyncing = true;
    try {
      final rows = await _db!.query(
        _tablePendingWrites,
        orderBy: 'created_at ASC',
        limit: 50,
      );

      final toDelete = <int>[];
      for (final row in rows) {
        final ok = await _replayWrite(row);
        if (ok) {
          toDelete.add(row['id'] as int);
        } else {
          // Incrémenter retry_count; abandonner après 5 tentatives
          final retries = (row['retry_count'] as int? ?? 0) + 1;
          if (retries >= 5) {
            toDelete.add(row['id'] as int);
          } else {
            await _db!.update(
              _tablePendingWrites,
              {'retry_count': retries},
              where: 'id = ?',
              whereArgs: [row['id']],
            );
          }
        }
      }

      if (toDelete.isNotEmpty) {
        await _db!.delete(
          _tablePendingWrites,
          where: 'id IN (${toDelete.join(',')})',
        );
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _replayWrite(Map<String, dynamic> row) async {
    try {
      final operation = row['operation'] as String;
      final collection = row['collection'] as String;
      final docId = row['doc_id'] as String?;
      final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;

      final firestore = FirebaseFirestore.instance;
      final colRef = firestore.collection(collection);

      switch (operation) {
        case 'create':
          if (docId != null) {
            await colRef.doc(docId).set(data, SetOptions(merge: true));
          } else {
            await colRef.add(data);
          }
        case 'update':
          if (docId != null) await colRef.doc(docId).update(data);
        case 'delete':
          if (docId != null) await colRef.doc(docId).delete();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Cache lecture ─────────────────────────────────────────────────────────

  /// Sauvegarde une liste d'entités en cache.
  Future<void> cacheEntities(
    String cacheKey,
    List<Map<String, dynamic>> entities, {
    int ttlSeconds = _defaultTtlSeconds,
  }) async {
    if (kIsWeb || _db == null) return;

    await _db!.insert(
      _tableCache,
      {
        'cache_key': cacheKey,
        'data': jsonEncode(entities),
        'updated_at': DateTime.now().millisecondsSinceEpoch,
        'ttl_seconds': ttlSeconds,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Lit les entités en cache si elles ne sont pas expirées.
  Future<List<Map<String, dynamic>>?> getCachedEntities(
      String cacheKey) async {
    if (kIsWeb || _db == null) return null;

    final rows = await _db!.query(
      _tableCache,
      where: 'cache_key = ?',
      whereArgs: [cacheKey],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final row = rows.first;
    final updatedAt = row['updated_at'] as int;
    final ttl = row['ttl_seconds'] as int;
    final expiry = updatedAt + ttl * 1000;

    if (DateTime.now().millisecondsSinceEpoch > expiry) {
      // Cache expiré
      await _db!.delete(_tableCache,
          where: 'cache_key = ?', whereArgs: [cacheKey]);
      return null;
    }

    return (jsonDecode(row['data'] as String) as List)
        .cast<Map<String, dynamic>>();
  }

  /// Invalide un cache spécifique.
  Future<void> invalidateCache(String cacheKey) async {
    if (kIsWeb || _db == null) return;
    await _db!
        .delete(_tableCache, where: 'cache_key = ?', whereArgs: [cacheKey]);
  }

  /// Purge tous les caches expirés.
  Future<void> purgeExpiredCache() async {
    if (kIsWeb || _db == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db!.rawDelete(
      'DELETE FROM $_tableCache WHERE (updated_at + ttl_seconds * 1000) < ?',
      [now],
    );
  }

  // ── Clés de cache standardisées ───────────────────────────────────────────

  static String exploitationsKey(String userId) => 'exploitations:$userId';
  static String parcellesKey(String exploitationId) =>
      'parcelles:$exploitationId';
  static String activitesKey(String exploitationId) =>
      'activites:$exploitationId';
}
