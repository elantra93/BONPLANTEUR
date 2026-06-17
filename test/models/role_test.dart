import 'package:flutter_test/flutter_test.dart';
import 'package:demeter_v1_1/models/role.dart';

void main() {
  // ── Parsing ────────────────────────────────────────────────────────────────

  group('RoleParsing.fromString', () {
    test('parse les valeurs Firestore standard', () {
      expect(RoleParsing.fromString('ADMIN'), Role.admin);
      expect(RoleParsing.fromString('CHEF_EXPLOITATION'), Role.chefExploitation);
      expect(RoleParsing.fromString('CHEF_PARCELLE'), Role.chefParcelle);
      expect(RoleParsing.fromString('TECHNICIEN'), Role.technicien);
      expect(RoleParsing.fromString('OUVRIER'), Role.ouvrier);
      expect(RoleParsing.fromString('COMPTABLE'), Role.comptable);
      expect(RoleParsing.fromString('SIGNATAIRE_DEPENSES'), Role.signataire);
      expect(RoleParsing.fromString('LECTEUR'), Role.lecteur);
    });

    test('insensible à la casse et aux espaces', () {
      expect(RoleParsing.fromString('admin'), Role.admin);
      expect(RoleParsing.fromString('  TECHNICIEN  '), Role.technicien);
      expect(RoleParsing.fromString('Chef_Parcelle'), Role.chefParcelle);
    });

    test('rétrocompatibilité typeCompte legacy', () {
      expect(RoleParsing.fromString('Patron'), Role.chefExploitation);
      expect(RoleParsing.fromString('patron'), Role.chefExploitation);
      expect(RoleParsing.fromString('Collaborateur'), Role.technicien);
      expect(RoleParsing.fromString('collaborateur'), Role.technicien);
    });

    test('retourne null pour valeur inconnue', () {
      expect(RoleParsing.fromString('INCONNU'), isNull);
      expect(RoleParsing.fromString(''), isNull);
      expect(RoleParsing.fromString(null), isNull);
    });
  });

  group('Role.firestoreValue', () {
    test('génère la valeur Firestore attendue', () {
      expect(Role.admin.firestoreValue, 'ADMIN');
      expect(Role.chefExploitation.firestoreValue, 'CHEF_EXPLOITATION');
      expect(Role.signataire.firestoreValue, 'SIGNATAIRE_DEPENSES');
    });

    test('aller-retour fromString → firestoreValue', () {
      for (final role in Role.values) {
        expect(RoleParsing.fromString(role.firestoreValue), role,
            reason: 'Aller-retour échoue pour $role');
      }
    });
  });

  // ── Incompatibilités ───────────────────────────────────────────────────────

  group('hasRoleConflict', () {
    test('ouvrier + admin → conflit', () {
      expect(hasRoleConflict([Role.ouvrier, Role.admin]), isTrue);
    });

    test('ouvrier + chefExploitation → conflit', () {
      expect(hasRoleConflict([Role.ouvrier, Role.chefExploitation]), isTrue);
    });

    test('ouvrier + signataire → conflit', () {
      expect(hasRoleConflict([Role.ouvrier, Role.signataire]), isTrue);
    });

    test('lecteur + comptable → conflit', () {
      expect(hasRoleConflict([Role.lecteur, Role.comptable]), isTrue);
    });

    test('lecteur + admin → conflit', () {
      expect(hasRoleConflict([Role.lecteur, Role.admin]), isTrue);
    });

    test('comptable + signataire → pas de conflit', () {
      expect(hasRoleConflict([Role.comptable, Role.signataire]), isFalse);
    });

    test('chefParcelle + technicien → pas de conflit', () {
      expect(hasRoleConflict([Role.chefParcelle, Role.technicien]), isFalse);
    });

    test('chefExploitation + admin → pas de conflit', () {
      expect(hasRoleConflict([Role.chefExploitation, Role.admin]), isFalse);
    });

    test('rôle unique → jamais de conflit', () {
      for (final role in Role.values) {
        expect(hasRoleConflict([role]), isFalse,
            reason: 'Un rôle unique ne peut pas être en conflit avec lui-même');
      }
    });

    test('liste vide → pas de conflit', () {
      expect(hasRoleConflict([]), isFalse);
    });
  });

  // ── Matrice de permissions ─────────────────────────────────────────────────

  group('permissionsForRole', () {
    test('admin a toutes les permissions critiques', () {
      final perms = permissionsForRole(Role.admin);
      expect(perms, contains(P.createActivite));
      expect(perms, contains(P.validateActivite));
      expect(perms, contains(P.validateDepense));
      expect(perms, contains(P.manageUsers));
      expect(perms, contains(P.manageSystem));
    });

    test('ouvrier ne peut que voir et exécuter', () {
      final perms = permissionsForRole(Role.ouvrier);
      expect(perms, contains(P.executeActivite));
      expect(perms, isNot(contains(P.createActivite)));
      expect(perms, isNot(contains(P.validateActivite)));
      expect(perms, isNot(contains(P.createDepense)));
      expect(perms, isNot(contains(P.validateDepense)));
      expect(perms, isNot(contains(P.manageUsers)));
    });

    test('comptable peut créer mais pas valider les dépenses', () {
      final perms = permissionsForRole(Role.comptable);
      expect(perms, contains(P.createDepense));
      expect(perms, isNot(contains(P.validateDepense)));
    });

    test('signataire peut valider mais pas créer les dépenses', () {
      final perms = permissionsForRole(Role.signataire);
      expect(perms, contains(P.validateDepense));
      expect(perms, isNot(contains(P.createDepense)));
    });

    test('lecteur a uniquement accès en lecture', () {
      final perms = permissionsForRole(Role.lecteur);
      expect(perms, contains(P.viewActivite));
      expect(perms, contains(P.viewDepense));
      expect(perms, contains(P.viewRapports));
      expect(perms, isNot(contains(P.createActivite)));
      expect(perms, isNot(contains(P.validateDepense)));
      expect(perms, isNot(contains(P.manageUsers)));
    });
  });

  group('permissionsForRoles — union logique (rôles multiples)', () {
    test('chefParcelle + technicien : union des permissions', () {
      final perms = permissionsForRoles([Role.chefParcelle, Role.technicien]);
      // Du chefParcelle
      expect(perms, contains(P.createActivite));
      expect(perms, contains(P.validateActivite));
      // Du technicien
      expect(perms, contains(P.executeActivite));
      expect(perms, contains(P.manageStock));
    });

    test('comptable + signataire : peut saisir ET valider les dépenses', () {
      final perms =
          permissionsForRoles([Role.comptable, Role.signataire]);
      expect(perms, contains(P.createDepense));
      expect(perms, contains(P.validateDepense));
    });

    test('ouvrier + lecteur : union sans conflits de permission', () {
      final perms = permissionsForRoles([Role.ouvrier, Role.lecteur]);
      expect(perms, contains(P.executeActivite));
      expect(perms, contains(P.viewRapports));
      expect(perms, isNot(contains(P.createActivite)));
      expect(perms, isNot(contains(P.manageUsers)));
    });

    test('liste vide → aucune permission', () {
      expect(permissionsForRoles([]), isEmpty);
    });

    test('rôle unique == permissionsForRole', () {
      for (final role in Role.values) {
        expect(
          permissionsForRoles([role]),
          equals(permissionsForRole(role)),
          reason: 'permissionsForRoles([role]) doit être identique à '
              'permissionsForRole(role) pour $role',
        );
      }
    });

    test('union est commutative', () {
      final ab = permissionsForRoles([Role.comptable, Role.signataire]);
      final ba = permissionsForRoles([Role.signataire, Role.comptable]);
      expect(ab, equals(ba));
    });

    test('admin + autre rôle == admin seul (admin est un sur-ensemble)', () {
      final adminPerms = permissionsForRole(Role.admin);
      final adminAndTech =
          permissionsForRoles([Role.admin, Role.technicien]);
      // L'admin a déjà toutes les permissions du technicien
      for (final p in permissionsForRole(Role.technicien)) {
        expect(adminPerms, contains(p));
      }
      // L'union ne doit pas perdre de permissions admin
      expect(adminAndTech.containsAll(adminPerms), isTrue);
    });
  });

  // ── Scénarios métier complets ──────────────────────────────────────────────

  group('Scénarios métier DEMETER', () {
    test('Jean (CP + Tech) peut créer, exécuter et valider une activité', () {
      final perms =
          permissionsForRoles([Role.chefParcelle, Role.technicien]);
      expect(perms.contains(P.createActivite), isTrue,
          reason: 'Jean peut planifier une activité (CP)');
      expect(perms.contains(P.executeActivite), isTrue,
          reason: 'Jean peut exécuter une activité (Tech)');
      expect(perms.contains(P.validateActivite), isTrue,
          reason: 'Jean peut valider une activité (CP)');
    });

    test('Marie (Compt + Sign) peut saisir et valider une dépense', () {
      final perms =
          permissionsForRoles([Role.comptable, Role.signataire]);
      expect(perms.contains(P.createDepense), isTrue,
          reason: 'Marie peut saisir une dépense (Compt)');
      expect(perms.contains(P.validateDepense), isTrue,
          reason: 'Marie peut valider une dépense (Sign)');
    });

    test('Paul (ChefExpl) supervise tout sauf admin système', () {
      final perms = permissionsForRoles([Role.chefExploitation]);
      expect(perms.contains(P.manageUsers), isTrue);
      expect(perms.contains(P.validateActivite), isTrue);
      expect(perms.contains(P.validateDepense), isTrue);
      expect(perms.contains(P.manageSystem), isFalse,
          reason: 'Seul l\'admin peut gérer le système');
    });

    test('Ouvrier ne peut pas s\'auto-promouvoir via combinaison interdite',
        () {
      expect(hasRoleConflict([Role.ouvrier, Role.admin]), isTrue);
      expect(hasRoleConflict([Role.ouvrier, Role.chefExploitation]), isTrue);
    });
  });
}
