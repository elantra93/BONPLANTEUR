import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Détecte la connectivité réseau via DNS lookup périodique.
/// Pas de dépendance externe — utilise uniquement dart:io.
class ConnectivityService extends ChangeNotifier {
  static final ConnectivityService instance = ConnectivityService._();
  ConnectivityService._();

  bool _isOnline = true;
  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  Timer? _timer;
  bool _initialized = false;

  // Stream public pour les listeners non-widget
  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get onConnectivityChanged => _controller.stream;

  /// Démarre la surveillance réseau (vérification toutes les 15 secondes).
  void startMonitoring() {
    if (_initialized) return;
    _initialized = true;

    // Vérification immédiate
    _check();

    // Puis périodique
    _timer = Timer.periodic(const Duration(seconds: 15), (_) => _check());
  }

  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
    _initialized = false;
  }

  Future<void> _check() async {
    final online = await _isConnected();
    if (online != _isOnline) {
      _isOnline = online;
      _controller.add(online);
      notifyListeners();
    }
  }

  /// Force une re-vérification immédiate.
  Future<bool> checkNow() async {
    await _check();
    return _isOnline;
  }

  static Future<bool> _isConnected() async {
    // Sur le web, on suppose toujours connecté (pas de dart:io)
    if (kIsWeb) return true;

    try {
      final result = await InternetAddress.lookup('google.com').timeout(
        const Duration(seconds: 5),
      );
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    stopMonitoring();
    _controller.close();
    super.dispose();
  }
}
