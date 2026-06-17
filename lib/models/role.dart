// ignore_for_file: constant_identifier_names

/// Les 8 rôles DEMETER. Un utilisateur peut en avoir plusieurs simultanément.
/// Les permissions sont cumulatives (union logique).
enum Role {
  admin,
  chefExploitation,
  chefParcelle,
  technicien,
  ouvrier,
  comptable,
  signataire,
  lecteur,
}

// ── Parsing ────────────────────────────────────────────────────────────────

extension RoleParsing on Role {
  /// Valeur stockée en Firestore (ex. "CHEF_EXPLOITATION").
  String get firestoreValue {
    switch (this) {
      case Role.admin:
        return 'ADMIN';
      case Role.chefExploitation:
        return 'CHEF_EXPLOITATION';
      case Role.chefParcelle:
        return 'CHEF_PARCELLE';
      case Role.technicien:
        return 'TECHNICIEN';
      case Role.ouvrier:
        return 'OUVRIER';
      case Role.comptable:
        return 'COMPTABLE';
      case Role.signataire:
        return 'SIGNATAIRE_DEPENSES';
      case Role.lecteur:
        return 'LECTEUR';
    }
  }

  /// Libellé affiché à l'utilisateur.
  String get label {
    switch (this) {
      case Role.admin:
        return 'Administrateur';
      case Role.chefExploitation:
        return 'Chef d\'exploitation';
      case Role.chefParcelle:
        return 'Chef de parcelle';
      case Role.technicien:
        return 'Technicien';
      case Role.ouvrier:
        return 'Ouvrier';
      case Role.comptable:
        return 'Comptable';
      case Role.signataire:
        return 'Signataire dépenses';
      case Role.lecteur:
        return 'Lecteur';
    }
  }

  static Role? fromString(String? value) {
    if (value == null) return null;
    for (final role in Role.values) {
      if (role.firestoreValue == value.toUpperCase().trim() ||
          role.name == value.toLowerCase().trim()) {
        return role;
      }
    }
    // Rétrocompatibilité avec l'ancien champ typeCompte
    switch (value.toLowerCase().trim()) {
      case 'patron':
        return Role.chefExploitation;
      case 'collaborateur':
        return Role.technicien;
      case 'admin':
        return Role.admin;
    }
    return null;
  }
}

// ── Incompatibilités ────────────────────────────────────────────────────────

/// Combinaisons de rôles interdites (clé = rôle, valeurs = rôles incompatibles).
const Map<Role, List<Role>> incompatibleRoles = {
  Role.ouvrier: [Role.admin, Role.chefExploitation, Role.signataire],
  Role.lecteur: [Role.comptable, Role.admin],
};

/// Vérifie si une liste de rôles contient des combinaisons incompatibles.
bool hasRoleConflict(List<Role> roles) {
  for (final role in roles) {
    final conflicts = incompatibleRoles[role] ?? [];
    if (conflicts.any((c) => roles.contains(c))) return true;
  }
  return false;
}

// ── Matrice de permissions ──────────────────────────────────────────────────

/// Identifiants de permissions au format "action:ressource".
class P {
  // Exploitations
  static const viewExploitation = 'view:exploitation';
  static const createExploitation = 'create:exploitation';
  static const editExploitation = 'edit:exploitation';

  // Parcelles
  static const viewParcelle = 'view:parcelle';
  static const createParcelle = 'create:parcelle';
  static const editParcelle = 'edit:parcelle';

  // Activités
  static const viewActivite = 'view:activite';
  static const createActivite = 'create:activite';
  static const executeActivite = 'execute:activite';
  static const validateActivite = 'validate:activite';

  // Dépenses
  static const viewDepense = 'view:depense';
  static const createDepense = 'create:depense';
  static const validateDepense = 'validate:depense';

  // Stock / Récoltes / Ventes
  static const viewStock = 'view:stock';
  static const manageStock = 'manage:stock';
  static const viewRecolte = 'view:recolte';
  static const createRecolte = 'create:recolte';

  // RH
  static const viewRH = 'view:rh';
  static const manageRH = 'manage:rh';

  // Matériel
  static const viewMateriel = 'view:materiel';
  static const manageMateriel = 'manage:materiel';

  // Rapports / Dashboard
  static const viewRapports = 'view:rapports';
  static const viewDashboard = 'view:dashboard';

  // Administration
  static const manageUsers = 'manage:users';
  static const manageSystem = 'manage:system';
}

/// Permissions accordées par rôle.
const Map<Role, Set<String>> _rolePermissions = {
  Role.admin: {
    P.viewExploitation, P.createExploitation, P.editExploitation,
    P.viewParcelle, P.createParcelle, P.editParcelle,
    P.viewActivite, P.createActivite, P.executeActivite, P.validateActivite,
    P.viewDepense, P.createDepense, P.validateDepense,
    P.viewStock, P.manageStock,
    P.viewRecolte, P.createRecolte,
    P.viewRH, P.manageRH,
    P.viewMateriel, P.manageMateriel,
    P.viewRapports, P.viewDashboard,
    P.manageUsers, P.manageSystem,
  },
  Role.chefExploitation: {
    P.viewExploitation, P.createExploitation, P.editExploitation,
    P.viewParcelle, P.createParcelle, P.editParcelle,
    P.viewActivite, P.createActivite, P.validateActivite,
    P.viewDepense, P.createDepense, P.validateDepense,
    P.viewStock, P.manageStock,
    P.viewRecolte, P.createRecolte,
    P.viewRH, P.manageRH,
    P.viewMateriel, P.manageMateriel,
    P.viewRapports, P.viewDashboard,
    P.manageUsers,
  },
  Role.chefParcelle: {
    P.viewExploitation,
    P.viewParcelle, P.createParcelle, P.editParcelle,
    P.viewActivite, P.createActivite, P.executeActivite, P.validateActivite,
    P.viewDepense, P.createDepense,
    P.viewStock, P.manageStock,
    P.viewRecolte, P.createRecolte,
    P.viewRH, P.manageRH,
    P.viewMateriel,
    P.viewRapports, P.viewDashboard,
  },
  Role.technicien: {
    P.viewExploitation,
    P.viewParcelle,
    P.viewActivite, P.createActivite, P.executeActivite,
    P.viewDepense,
    P.viewStock, P.manageStock,
    P.viewRecolte, P.createRecolte,
    P.viewRH,
    P.viewMateriel,
    P.viewDashboard,
  },
  Role.ouvrier: {
    P.viewExploitation,
    P.viewParcelle,
    P.viewActivite, P.executeActivite,
    P.viewDashboard,
  },
  Role.comptable: {
    P.viewExploitation,
    P.viewParcelle,
    P.viewActivite,
    P.viewDepense, P.createDepense,
    P.viewStock,
    P.viewRecolte,
    P.viewRapports, P.viewDashboard,
  },
  Role.signataire: {
    P.viewExploitation,
    P.viewDepense, P.validateDepense,
    P.viewRapports, P.viewDashboard,
  },
  Role.lecteur: {
    P.viewExploitation,
    P.viewParcelle,
    P.viewActivite,
    P.viewDepense,
    P.viewStock,
    P.viewRecolte,
    P.viewRH,
    P.viewMateriel,
    P.viewRapports, P.viewDashboard,
  },
};

/// Retourne l'ensemble des permissions pour un rôle.
Set<String> permissionsForRole(Role role) {
  return _rolePermissions[role] ?? {};
}

/// Retourne l'union de toutes les permissions pour une liste de rôles.
Set<String> permissionsForRoles(List<Role> roles) {
  return roles.fold(<String>{}, (acc, r) => acc.union(permissionsForRole(r)));
}
