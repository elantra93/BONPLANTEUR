import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demeter_v1_1/utils/validators.dart';

/// Helper : exécute un validateur sans BuildContext réel.
/// Les validators DEMETER ne lisent pas BuildContext → safe.
String? _validate(DValidator validator, String? value) {
  return validator(const _FakeContext(), value);
}

void main() {
  // ── V.required ─────────────────────────────────────────────────────────────

  group('V.required', () {
    test('accepte une valeur non vide', () {
      expect(_validate(V.required(), 'test'), isNull);
      expect(_validate(V.required(), '  a  '), isNull);
    });

    test('rejette null, vide et espaces seuls', () {
      expect(_validate(V.required(), null), isNotNull);
      expect(_validate(V.required(), ''), isNotNull);
      expect(_validate(V.required(), '   '), isNotNull);
    });

    test('utilise le message personnalisé', () {
      expect(_validate(V.required('Champ X requis'), ''), 'Champ X requis');
    });
  });

  // ── V.minLength / V.maxLength ──────────────────────────────────────────────

  group('V.minLength', () {
    test('accepte la longueur exacte', () {
      expect(_validate(V.minLength(3), 'abc'), isNull);
    });

    test('accepte au-dessus du minimum', () {
      expect(_validate(V.minLength(3), 'abcdef'), isNull);
    });

    test('rejette en dessous', () {
      expect(_validate(V.minLength(3), 'ab'), isNotNull);
    });

    test('ignore null et vide (laissé à V.required)', () {
      expect(_validate(V.minLength(3), null), isNull);
      expect(_validate(V.minLength(3), ''), isNull);
    });
  });

  group('V.maxLength', () {
    test('accepte sous la limite', () {
      expect(_validate(V.maxLength(5), 'abc'), isNull);
    });

    test('accepte la longueur exacte', () {
      expect(_validate(V.maxLength(5), 'abcde'), isNull);
    });

    test('rejette au-dessus', () {
      expect(_validate(V.maxLength(5), 'abcdef'), isNotNull);
    });
  });

  // ── V.amount ───────────────────────────────────────────────────────────────

  group('V.amount', () {
    test('accepte montant entier', () {
      expect(_validate(V.amount(), '5000'), isNull);
    });

    test('accepte montant décimal avec point', () {
      expect(_validate(V.amount(), '5000.50'), isNull);
    });

    test('accepte montant décimal avec virgule', () {
      expect(_validate(V.amount(), '5000,50'), isNull);
    });

    test('rejette zéro', () {
      expect(_validate(V.amount(), '0'), isNotNull);
    });

    test('rejette négatif', () {
      expect(_validate(V.amount(), '-100'), isNotNull);
    });

    test('rejette texte non numérique', () {
      expect(_validate(V.amount(), 'abc'), isNotNull);
    });

    test('rejette vide', () {
      expect(_validate(V.amount(), ''), isNotNull);
      expect(_validate(V.amount(), null), isNotNull);
    });
  });

  // ── V.positiveNumber ───────────────────────────────────────────────────────

  group('V.positiveNumber', () {
    test('accepte zéro', () {
      expect(_validate(V.positiveNumber(), '0'), isNull);
    });

    test('accepte nombre positif', () {
      expect(_validate(V.positiveNumber(), '42.5'), isNull);
    });

    test('rejette négatif', () {
      expect(_validate(V.positiveNumber(), '-1'), isNotNull);
    });

    test('accepte vide (non obligatoire)', () {
      expect(_validate(V.positiveNumber(), ''), isNull);
      expect(_validate(V.positiveNumber(), null), isNull);
    });

    test('rejette texte', () {
      expect(_validate(V.positiveNumber(), 'xyz'), isNotNull);
    });
  });

  // ── V.phone ────────────────────────────────────────────────────────────────

  group('V.phone', () {
    test('accepte numéros africains courants', () {
      expect(_validate(V.phone(), '+22507123456'), isNull);   // Côte d'Ivoire
      expect(_validate(V.phone(), '+221701234567'), isNull);  // Sénégal
      expect(_validate(V.phone(), '0701234567'), isNull);     // local
    });

    test('accepte numéros avec espaces/tirets (nettoyés)', () {
      expect(_validate(V.phone(), '+225 07 12 34 56'), isNull);
      expect(_validate(V.phone(), '07-12-34-56'), isNull);
    });

    test('rejette trop court', () {
      expect(_validate(V.phone(), '1234567'), isNotNull);
    });

    test('rejette avec lettres', () {
      expect(_validate(V.phone(), 'abc123'), isNotNull);
    });

    test('accepte vide (non obligatoire)', () {
      expect(_validate(V.phone(), ''), isNull);
      expect(_validate(V.phone(), null), isNull);
    });
  });

  // ── V.email ────────────────────────────────────────────────────────────────

  group('V.email', () {
    test('accepte emails valides', () {
      expect(_validate(V.email(), 'user@example.com'), isNull);
      expect(_validate(V.email(), 'user.name+tag@domain.org'), isNull);
    });

    test('rejette format invalide', () {
      expect(_validate(V.email(), 'not-an-email'), isNotNull);
      expect(_validate(V.email(), '@domain.com'), isNotNull);
      expect(_validate(V.email(), 'user@'), isNotNull);
    });

    test('accepte vide (non obligatoire)', () {
      expect(_validate(V.email(), ''), isNull);
      expect(_validate(V.email(), null), isNull);
    });
  });

  // ── V.dateJJMMAAAA ────────────────────────────────────────────────────────

  group('V.dateJJMMAAAA', () {
    test('accepte format correct', () {
      expect(_validate(V.dateJJMMAAAA(), '15/06/2026'), isNull);
      expect(_validate(V.dateJJMMAAAA(), '01/01/2024'), isNull);
    });

    test('rejette format incorrect', () {
      expect(_validate(V.dateJJMMAAAA(), '2026-06-15'), isNotNull);
      expect(_validate(V.dateJJMMAAAA(), '15/06/26'), isNotNull);
      expect(_validate(V.dateJJMMAAAA(), '31/13/2026'), isNotNull); // mois > 12
      expect(_validate(V.dateJJMMAAAA(), '32/06/2026'), isNotNull); // jour > 31
    });

    test('accepte vide', () {
      expect(_validate(V.dateJJMMAAAA(), ''), isNull);
      expect(_validate(V.dateJJMMAAAA(), null), isNull);
    });
  });

  // ── V.superficie ─────────────────────────────────────────────────────────

  group('V.superficie', () {
    test('accepte superficie valide', () {
      expect(_validate(V.superficie(), '10'), isNull);
      expect(_validate(V.superficie(), '0.5'), isNull);
    });

    test('rejette zéro et négatif', () {
      expect(_validate(V.superficie(), '0'), isNotNull);
      expect(_validate(V.superficie(), '-1'), isNotNull);
    });

    test('rejette texte', () {
      expect(_validate(V.superficie(), 'abc'), isNotNull);
    });

    test('accepte vide (non obligatoire)', () {
      expect(_validate(V.superficie(), null), isNull);
      expect(_validate(V.superficie(), ''), isNull);
    });
  });

  // ── V.compose ─────────────────────────────────────────────────────────────

  group('V.compose', () {
    test('retourne null si tous les validators passent', () {
      final v = V.compose([V.required(), V.minLength(3), V.maxLength(10)]);
      expect(_validate(v, 'hello'), isNull);
    });

    test('retourne la première erreur', () {
      final v = V.compose([V.required(), V.minLength(5)]);
      // required échoue en premier
      expect(_validate(v, ''), isNotNull);
    });

    test('erreur du second validator si le premier passe', () {
      final v = V.compose([V.required(), V.minLength(5)]);
      // required passe mais minLength échoue
      final result = _validate(v, 'ab');
      expect(result, isNotNull);
      expect(result, contains('5')); // message contient la longueur min
    });

    test('compose vide → toujours null', () {
      expect(_validate(V.compose([]), 'anything'), isNull);
    });
  });

  // ── Scénarios formulaires DEMETER ────────────────────────────────────────

  group('Scénarios formulaires', () {
    test('champ montant dépense : obligatoire et > 0', () {
      final v = V.compose([V.required('Montant obligatoire'), V.amount()]);
      expect(_validate(v, ''), 'Montant obligatoire');
      expect(_validate(v, '0'), isNotNull);
      expect(_validate(v, '-50'), isNotNull);
      expect(_validate(v, '5000'), isNull);
      expect(_validate(v, '5000,50'), isNull);
    });

    test('champ libellé : obligatoire min 3 caractères', () {
      final v =
          V.compose([V.required('Libellé obligatoire'), V.minLength(3)]);
      expect(_validate(v, ''), 'Libellé obligatoire');
      expect(_validate(v, 'ab'), isNotNull);
      expect(_validate(v, 'abc'), isNull);
    });

    test('champ superficie parcelle : obligatoire > 0 ha', () {
      final v =
          V.compose([V.required('Superficie obligatoire'), V.superficie()]);
      expect(_validate(v, ''), 'Superficie obligatoire');
      expect(_validate(v, '0'), isNotNull);
      expect(_validate(v, '2.5'), isNull);
    });
  });
}

/// BuildContext factice — les validators DEMETER n'utilisent pas le contexte.
class _FakeContext extends Fake implements BuildContext {}
