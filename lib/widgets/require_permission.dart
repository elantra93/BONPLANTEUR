import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/models/role.dart';
import '/services/rbac_service.dart';

/// Affiche [child] uniquement si l'utilisateur connecté possède les droits requis.
///
/// Usage par rôle :
/// ```dart
/// RequirePermission(
///   anyOf: [Role.chefParcelle, Role.chefExploitation],
///   child: BoutonValider(),
/// )
/// ```
///
/// Usage par permission :
/// ```dart
/// RequirePermission.perm(
///   permission: P.validateDepense,
///   child: BoutonValiderDepense(),
/// )
/// ```
class RequirePermission extends StatelessWidget {
  const RequirePermission({
    super.key,
    this.anyOf = const [],
    this.allOf = const [],
    this.permission,
    required this.child,
    this.fallback,
    this.showAccessDenied = false,
  });

  /// Constructeur rapide par permission directe.
  const RequirePermission.perm({
    super.key,
    required String perm,
    required this.child,
    this.fallback,
    this.showAccessDenied = false,
  })  : anyOf = const [],
        allOf = const [],
        permission = perm;

  /// L'utilisateur doit avoir AU MOINS UN de ces rôles.
  final List<Role> anyOf;

  /// L'utilisateur doit avoir TOUS ces rôles.
  final List<Role> allOf;

  /// Permission directe (ex. [P.validateDepense]).
  final String? permission;

  /// Widget affiché si les droits sont présents.
  final Widget child;

  /// Widget affiché si les droits sont absents. Si null → [SizedBox.shrink()].
  final Widget? fallback;

  /// Affiche un message "Accès refusé" si true (utile pour le débogage).
  final bool showAccessDenied;

  @override
  Widget build(BuildContext context) {
    // S'abonner aux changements d'auth pour re-rendre quand les rôles changent.
    context.watch<FFAppState>();

    final rbac = RbacService.instance;
    final allowed = _check(rbac);

    if (allowed) return child;

    if (showAccessDenied) {
      return _AccessDeniedPlaceholder();
    }

    return fallback ?? const SizedBox.shrink();
  }

  bool _check(RbacService rbac) {
    // Vérification par permission directe
    if (permission != null) return rbac.hasPerm(permission!);

    // Vérification par rôles
    if (anyOf.isNotEmpty && !rbac.hasAnyRole(anyOf)) return false;
    if (allOf.isNotEmpty && !rbac.hasAllRoles(allOf)) return false;

    // Aucune contrainte définie → autorisé
    return true;
  }
}

class _AccessDeniedPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: const [
          Icon(Icons.lock_outline, color: Colors.red, size: 16),
          SizedBox(width: 8),
          Text(
            'Accès non autorisé',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Écran complet affiché quand l'accès à une page entière est refusé.
class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Accès non autorisé',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                message ??
                    'Vous n\'avez pas les droits pour accéder à cette page.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
