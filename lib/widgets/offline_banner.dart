import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '/services/connectivity_service.dart';
import '/services/offline_service.dart';

/// Banderole affichée en haut de l'écran quand le réseau est absent.
/// S'auto-cache lors du retour de connexion.
///
/// Usage : enrouler n'importe quel écran avec ce widget :
/// ```dart
/// OfflineBanner(child: Scaffold(...))
/// ```
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ConnectivityService.instance,
      builder: (context, _) {
        final isOffline = ConnectivityService.instance.isOffline;
        return Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => SizeTransition(
                sizeFactor: animation,
                child: child,
              ),
              child: isOffline
                  ? _OfflineBar(key: const ValueKey('offline'))
                  : const SizedBox.shrink(key: ValueKey('online')),
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}

class _OfflineBar extends StatefulWidget {
  const _OfflineBar({super.key});

  @override
  State<_OfflineBar> createState() => _OfflineBarState();
}

class _OfflineBarState extends State<_OfflineBar> {
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  Future<void> _loadCount() async {
    final count = await OfflineService.instance.pendingCount();
    if (mounted) setState(() => _pendingCount = count);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE8A217), // secondary ambre DEMETER
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.wifi_off, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _pendingCount > 0
                      ? 'Mode hors ligne — $_pendingCount action(s) en attente'
                      : 'Mode hors ligne — Les données peuvent ne pas être à jour',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final ok =
                      await ConnectivityService.instance.checkNow();
                  if (ok) await OfflineService.instance.syncPendingWrites();
                  await _loadCount();
                },
                child: Text(
                  'Actualiser',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Indicateur compact de statut réseau (pour AppBar ou coin d'écran).
class ConnectivityDot extends StatelessWidget {
  const ConnectivityDot({super.key, this.size = 10});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ConnectivityService.instance,
      builder: (context, _) {
        final isOnline = ConnectivityService.instance.isOnline;
        return Tooltip(
          message: isOnline ? 'Connecté' : 'Hors ligne',
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline
                  ? const Color(0xFF2E9050) // success vert
                  : const Color(0xFFE8A217), // warning ambre
            ),
          ),
        );
      },
    );
  }
}

/// Wrapper de Scaffold qui intègre automatiquement la bannière offline.
/// Remplace les [Scaffold] des pages principales.
class DemeterScaffold extends StatelessWidget {
  const DemeterScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return OfflineBanner(
      child: Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }
}
