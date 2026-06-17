import '/auth/firebase_auth/auth_util.dart';
import '/models/role.dart';

/// Service singleton RBAC.
/// Lit les rôles depuis [currentUserDocument] (déjà chargé par le stream Firebase Auth).
/// Les permissions sont calculées à la demande (union des rôles de l'utilisateur).
class RbacService {
  static final RbacService instance = RbacService._();
  RbacService._();

  // ── Rôles courants ────────────────────────────────────────────────────────

  /// Rôles de l'utilisateur connecté, dérivés du champ Firestore `roles`.
  List<Role> get currentRoles {
    final rawRoles = currentUserDocument?.roles ?? [];
    if (rawRoles.isEmpty) {
      // Rétrocompatibilité : si pas de rôles, lire typeCompte
      final typeCompte = currentUserDocument?.typeCompte ?? '';
      final legacy = RoleParsing.fromString(typeCompte);
      return legacy != null ? [legacy] : [];
    }
    return rawRoles
        .map((s) => RoleParsing.fromString(s))
        .whereType<Role>()
        .toList();
  }

  /// Permissions effectives (union de tous les rôles).
  Set<String> get currentPermissions => permissionsForRoles(currentRoles);

  // ── Vérifications de rôles ────────────────────────────────────────────────

  bool hasRole(Role role) => currentRoles.contains(role);

  bool hasAnyRole(List<Role> roles) =>
      roles.any((r) => currentRoles.contains(r));

  bool hasAllRoles(List<Role> roles) =>
      roles.every((r) => currentRoles.contains(r));

  // ── Vérifications de permissions ──────────────────────────────────────────

  /// Vérifie si l'utilisateur a la permission `action:resource`.
  bool canPerform(String action, String resource) =>
      currentPermissions.contains('$action:$resource');

  /// Vérifie si l'utilisateur a directement une permission.
  bool hasPerm(String permission) => currentPermissions.contains(permission);

  // ── Validation des combinaisons ───────────────────────────────────────────

  /// Retourne true si la combinaison de rôles est valide (aucune incompatibilité).
  bool validateRoleCombination(List<Role> roles) => !hasRoleConflict(roles);

  // ── Helpers de haut niveau ────────────────────────────────────────────────

  bool get canCreateActivite => hasPerm(P.createActivite);
  bool get canValidateActivite => hasPerm(P.validateActivite);
  bool get canCreateDepense => hasPerm(P.createDepense);
  bool get canValidateDepense => hasPerm(P.validateDepense);
  bool get canManageRH => hasPerm(P.manageRH);
  bool get canManageUsers => hasPerm(P.manageUsers);
  bool get canViewRapports => hasPerm(P.viewRapports);
  bool get canManageStock => hasPerm(P.manageStock);

  /// True si l'utilisateur peut valider les activités d'un autre utilisateur.
  bool get isSuperior =>
      hasAnyRole([Role.admin, Role.chefExploitation, Role.chefParcelle]);

  /// True si l'utilisateur a au moins un rôle (connexion complète).
  bool get hasAnyRoleAssigned => currentRoles.isNotEmpty;
}
