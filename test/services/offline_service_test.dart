import 'package:flutter_test/flutter_test.dart';
import 'package:demeter_v1_1/services/offline_service.dart';

/// Tests unitaires de l'OfflineService — logique pure sans Firebase.
/// Les tests SQLite sont skippés si `kIsWeb` (non disponible).
void main() {
  group('OfflineService.generatePath (clés cache)', () {
    test('exploitationsKey inclut le userId', () {
      const uid = 'user123';
      expect(OfflineService.exploitationsKey(uid), contains(uid));
      expect(OfflineService.exploitationsKey(uid), startsWith('exploitations:'));
    });

    test('parcellesKey inclut l\'exploitationId', () {
      const expId = 'exp456';
      expect(OfflineService.parcellesKey(expId), contains(expId));
      expect(OfflineService.parcellesKey(expId), startsWith('parcelles:'));
    });

    test('activitesKey inclut l\'exploitationId', () {
      const expId = 'exp789';
      expect(OfflineService.activitesKey(expId), contains(expId));
      expect(OfflineService.activitesKey(expId), startsWith('activites:'));
    });

    test('clés différentes pour IDs différents', () {
      expect(
        OfflineService.exploitationsKey('a'),
        isNot(equals(OfflineService.exploitationsKey('b'))),
      );
    });
  });
}
