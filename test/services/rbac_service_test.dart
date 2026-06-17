import 'package:flutter_test/flutter_test.dart';
import 'package:demeter_v1_1/models/role.dart';

/// Tests unitaires de la logique RBAC.
/// Testent directement les fonctions pures de role.dart
/// sans dépendance Firebase (currentUserDocument).
void main() {
  // ── Tests de base sur une liste de rôles ──────────────────────────────────

  group('hasAnyRole', () {
    bool hasAny(List<Role> userRoles, List<Role> check) =>
        check.any((r) => userRoles.contains(r));

    test('retourne true si au moins un rôle correspond', () {
      final roles = [Role.chefParcelle, Role.technicien];
      expect(hasAny(roles, [Role.chefParcelle]), isTrue);
      expect(hasAny(roles, [Role.technicien]), isTrue);
      expect(hasAny(roles, [Role.admin, Role.chefParcelle]), isTrue);
    });

    test('retourne false si aucun rôle ne correspond', () {
      final roles = [Role.chefParcelle, Role.technicien];
      expect(hasAny(roles, [Role.admin]), isFalse);
      expect(hasAny(roles, [Role.ouvrier, Role.lecteur]), isFalse);
    });

    test('liste vide → false', () {
      expect(hasAny([], [Role.admin]), isFalse);
    });
  });

  group('hasAllRoles', () {
    bool hasAll(List<Role> userRoles, List<Role> check) =>
        check.every((r) => userRoles.contains(r));

    test('retourne true si tous les rôles sont présents', () {
      final roles = [Role.comptable, Role.signataire];
      expect(hasAll(roles, [Role.comptable, Role.signataire]), isTrue);
    });

    test('retourne false s\'il manque un rôle', () {
      final roles = [Role.comptable];
      expect(hasAll(roles, [Role.comptable, Role.signataire]), isFalse);
    });

    test('liste vide de check → toujours true', () {
      expect(hasAll([], []), isTrue);
    });
  });

  // ── canPerform (via permissionsForRoles) ──────────────────────────────────

  group('canPerform', () {
    bool can(List<Role> roles, String action, String resource) {
      final perms = permissionsForRoles(roles);
      return perms.contains('$action:$resource');
    }

    group('Cas Jean : chefParcelle + technicien', () {
      final jean = [Role.chefParcelle, Role.technicien];

      test('peut créer une activité (CP)', () {
        expect(can(jean, 'create', 'activite'), isTrue);
      });

      test('peut exécuter une activité (Tech)', () {
        expect(can(jean, 'execute', 'activite'), isTrue);
      });

      test('peut valider une activité (CP)', () {
        expect(can(jean, 'validate', 'activite'), isTrue);
      });

      test('ne peut pas valider les dépenses', () {
        expect(can(jean, 'validate', 'depense'), isFalse);
      });

      test('ne peut pas gérer les utilisateurs', () {
        expect(can(jean, 'manage', 'users'), isFalse);
      });
    });

    group('Cas Marie : comptable + signataire', () {
      final marie = [Role.comptable, Role.signataire];

      test('peut saisir une dépense (Compt)', () {
        expect(can(marie, 'create', 'depense'), isTrue);
      });

      test('peut valider une dépense (Sign)', () {
        expect(can(marie, 'validate', 'depense'), isTrue);
      });

      test('peut voir les rapports (Sign)', () {
        expect(can(marie, 'view', 'rapports'), isTrue);
      });

      test('ne peut pas créer une parcelle', () {
        expect(can(marie, 'create', 'parcelle'), isFalse);
      });
    });

    group('Cas Paul : chefExploitation seul', () {
      final paul = [Role.chefExploitation];

      test('peut tout superviser', () {
        expect(can(paul, 'validate', 'activite'), isTrue);
        expect(can(paul, 'validate', 'depense'), isTrue);
        expect(can(paul, 'manage', 'rh'), isTrue);
        expect(can(paul, 'create', 'exploitation'), isTrue);
      });

      test('ne peut pas gérer le système', () {
        expect(can(paul, 'manage', 'system'), isFalse);
      });
    });

    group('Cas Ouvrier seul', () {
      final ouvrier = [Role.ouvrier];

      test('peut exécuter une activité', () {
        expect(can(ouvrier, 'execute', 'activite'), isTrue);
      });

      test('ne peut rien créer ni valider', () {
        expect(can(ouvrier, 'create', 'activite'), isFalse);
        expect(can(ouvrier, 'validate', 'activite'), isFalse);
        expect(can(ouvrier, 'create', 'depense'), isFalse);
        expect(can(ouvrier, 'validate', 'depense'), isFalse);
        expect(can(ouvrier, 'manage', 'rh'), isFalse);
      });
    });
  });

  // ── validateRoleCombination ───────────────────────────────────────────────

  group('validateRoleCombination', () {
    bool validate(List<Role> roles) => !hasRoleConflict(roles);

    test('✅ comptable + signataire', () {
      expect(validate([Role.comptable, Role.signataire]), isTrue);
    });

    test('✅ chefParcelle + technicien', () {
      expect(validate([Role.chefParcelle, Role.technicien]), isTrue);
    });

    test('✅ chefExploitation + admin', () {
      expect(validate([Role.chefExploitation, Role.admin]), isTrue);
    });

    test('✅ technicien + lecteur', () {
      expect(validate([Role.technicien, Role.lecteur]), isTrue);
    });

    test('✅ signataire + lecteur', () {
      expect(validate([Role.signataire, Role.lecteur]), isTrue);
    });

    test('❌ ouvrier + admin', () {
      expect(validate([Role.ouvrier, Role.admin]), isFalse);
    });

    test('❌ ouvrier + chefExploitation', () {
      expect(validate([Role.ouvrier, Role.chefExploitation]), isFalse);
    });

    test('❌ ouvrier + signataire', () {
      expect(validate([Role.ouvrier, Role.signataire]), isFalse);
    });

    test('❌ lecteur + comptable', () {
      expect(validate([Role.lecteur, Role.comptable]), isFalse);
    });

    test('❌ lecteur + admin', () {
      expect(validate([Role.lecteur, Role.admin]), isFalse);
    });
  });

  // ── Hiérarchie et délégation ──────────────────────────────────────────────

  group('Hiérarchie DEMETER', () {
    test('chef exploitation voit tout ce que le chef parcelle voit', () {
      final cpPerms = permissionsForRole(Role.chefParcelle);
      final cePerms = permissionsForRole(Role.chefExploitation);
      for (final perm in cpPerms) {
        expect(cePerms, contains(perm),
            reason: 'ChefExploitation doit avoir toute permission de ChefParcelle: $perm');
      }
    });

    test('admin est un sur-ensemble de toute permission', () {
      final adminPerms = permissionsForRole(Role.admin);
      for (final role in Role.values) {
        if (role == Role.admin) continue;
        for (final perm in permissionsForRole(role)) {
          expect(adminPerms, contains(perm),
              reason: 'Admin manque la permission $perm de $role');
        }
      }
    });

    test('ouvrier + lecteur n\'égale pas technicien', () {
      final ouvrierLecteur =
          permissionsForRoles([Role.ouvrier, Role.lecteur]);
      final tech = permissionsForRole(Role.technicien);
      // technicien peut créer des activités, ouvrier+lecteur non
      expect(tech.contains(P.createActivite), isTrue);
      expect(ouvrierLecteur.contains(P.createActivite), isFalse);
    });
  });

  // ── Tests des 5 combinaisons du PRD ──────────────────────────────────────

  group('5 combinaisons PRD v2.1', () {
    test('1. Chef parcelle + Technicien : planifier ET exécuter', () {
      final perms =
          permissionsForRoles([Role.chefParcelle, Role.technicien]);
      expect(perms.contains(P.createActivite), isTrue);
      expect(perms.contains(P.executeActivite), isTrue);
      expect(perms.contains(P.validateActivite), isTrue);
    });

    test('2. Comptable + Signataire : saisir ET valider dépenses', () {
      final perms =
          permissionsForRoles([Role.comptable, Role.signataire]);
      expect(perms.contains(P.createDepense), isTrue);
      expect(perms.contains(P.validateDepense), isTrue);
    });

    test('3. Chef exploitation + Admin : accès total', () {
      final perms =
          permissionsForRoles([Role.chefExploitation, Role.admin]);
      expect(perms.contains(P.manageSystem), isTrue);
      expect(perms.contains(P.manageUsers), isTrue);
      expect(perms.contains(P.validateActivite), isTrue);
    });

    test('4. Ouvrier + Lecteur : exécuter ET voir rapports', () {
      final perms = permissionsForRoles([Role.ouvrier, Role.lecteur]);
      expect(perms.contains(P.executeActivite), isTrue);
      expect(perms.contains(P.viewRapports), isTrue);
      expect(perms.contains(P.createActivite), isFalse);
    });

    test('5. Technicien + Lecteur : exécuter ET rapports complets', () {
      final perms =
          permissionsForRoles([Role.technicien, Role.lecteur]);
      expect(perms.contains(P.executeActivite), isTrue);
      expect(perms.contains(P.viewRapports), isTrue);
      expect(perms.contains(P.createRecolte), isTrue);
    });
  });
}
