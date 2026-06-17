// Tests de fumée — vérifient que les imports compilent correctement.
// Les tests Firebase (MyApp) nécessitent un environnement Firebase configuré.
import 'package:flutter_test/flutter_test.dart';
import 'package:demeter_v1_1/models/role.dart';
import 'package:demeter_v1_1/utils/validators.dart';

void main() {
  test('Les modèles compilent correctement', () {
    expect(Role.values.length, 8);
    expect(Role.admin.firestoreValue, 'ADMIN');
  });

  test('Les validators compilent correctement', () {
    final v = V.compose([V.required(), V.minLength(2)]);
    expect(v, isNotNull);
  });
}
