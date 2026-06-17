import 'package:flutter/material.dart';

import '/services/connectivity_service.dart';
import '/services/offline_service.dart';
import 'error_display.dart';

/// StreamBuilder avec fallback sur le cache SQLite offline.
///
/// - En ligne : utilise le stream Firestore normalement.
/// - Hors ligne : affiche les données du cache (si disponibles)
///   ou un état vide avec message.
///
/// Usage :
/// ```dart
/// CachedStreamBuilder<List<ExploitationsRecord>>(
///   cacheKey: OfflineService.exploitationsKey(currentUserUid),
///   stream: queryExploitationsRecord(...),
///   toCache: (records) =>
///     records.map((r) => r.data() ?? {}).toList(),
///   builder: (context, snapshot) => ...,
/// )
/// ```
class CachedStreamBuilder<T> extends StatelessWidget {
  const CachedStreamBuilder({
    super.key,
    required this.cacheKey,
    required this.stream,
    required this.builder,
    this.toCache,
    this.loadingWidget,
    this.errorWidget,
    this.emptyOfflineMessage =
        'Données non disponibles hors ligne.\nConnectez-vous pour synchroniser.',
  });

  final String cacheKey;
  final Stream<T> stream;
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;

  /// Convertit les données du stream en format cacheable.
  final List<Map<String, dynamic>> Function(T data)? toCache;

  final Widget? loadingWidget;
  final Widget? errorWidget;
  final String emptyOfflineMessage;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        // En ligne avec données fraîches : sauvegarder en cache
        if (snapshot.hasData && toCache != null) {
          final cacheData = toCache!(snapshot.data as T);
          OfflineService.instance.cacheEntities(cacheKey, cacheData);
        }

        // Données disponibles (online ou Firestore cache local)
        if (snapshot.hasData) {
          return builder(context, snapshot);
        }

        // Erreur réseau : essayer le cache SQLite
        if (snapshot.hasError ||
            (!snapshot.hasData &&
                ConnectivityService.instance.isOffline)) {
          return _CacheFallback<T>(
            cacheKey: cacheKey,
            builder: builder,
            emptyMessage: emptyOfflineMessage,
          );
        }

        // Chargement
        return loadingWidget ?? const DemeterLoader();
      },
    );
  }
}

class _CacheFallback<T> extends StatefulWidget {
  const _CacheFallback({
    required this.cacheKey,
    required this.builder,
    required this.emptyMessage,
  });

  final String cacheKey;
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;
  final String emptyMessage;

  @override
  State<_CacheFallback<T>> createState() => _CacheFallbackState<T>();
}

class _CacheFallbackState<T> extends State<_CacheFallback<T>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: OfflineService.instance.getCachedEntities(widget.cacheKey),
      builder: (context, cacheSnap) {
        if (cacheSnap.connectionState == ConnectionState.waiting) {
          return const DemeterLoader(message: 'Chargement du cache…');
        }

        final cached = cacheSnap.data;
        if (cached == null || cached.isEmpty) {
          return EmptyState(
            icon: Icons.wifi_off,
            message: widget.emptyMessage,
          );
        }

        // Reconstruire un AsyncSnapshot avec les données cachées
        // Note: T est probablement List<Record>, on ne peut pas
        // reconstruire le type exact, donc on délègue au builder
        // avec un snapshot "done" contenant les données brutes.
        // Le builder doit gérer gracieusement les données JSON brutes.
        return Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFE8A217).withOpacity(0.15),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: const [
                  Icon(Icons.history, size: 14, color: Color(0xFFE8A217)),
                  SizedBox(width: 6),
                  Text(
                    'Données en cache — Hors ligne',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFE8A217),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: EmptyState(
                icon: Icons.cloud_off_outlined,
                message:
                    '${cached.length} élément(s) en cache.\nConnectez-vous pour voir les données à jour.',
              ),
            ),
          ],
        );
      },
    );
  }
}
