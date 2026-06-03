import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SpeculationRecord extends FirestoreRecord {
  SpeculationRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Nom" field.
  String? _nom;
  String get nom => _nom ?? '';
  bool hasNom() => _nom != null;

  // "Illustration" field.
  String? _illustration;
  String get illustration => _illustration ?? '';
  bool hasIllustration() => _illustration != null;

  // "Categorie" field.
  String? _categorie;
  String get categorie => _categorie ?? '';
  bool hasCategorie() => _categorie != null;

  void _initializeFields() {
    _nom = snapshotData['Nom'] as String?;
    _illustration = snapshotData['Illustration'] as String?;
    _categorie = snapshotData['Categorie'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Speculation');

  static Stream<SpeculationRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SpeculationRecord.fromSnapshot(s));

  static Future<SpeculationRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SpeculationRecord.fromSnapshot(s));

  static SpeculationRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SpeculationRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SpeculationRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SpeculationRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SpeculationRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SpeculationRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSpeculationRecordData({
  String? nom,
  String? illustration,
  String? categorie,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Nom': nom,
      'Illustration': illustration,
      'Categorie': categorie,
    }.withoutNulls,
  );

  return firestoreData;
}

class SpeculationRecordDocumentEquality implements Equality<SpeculationRecord> {
  const SpeculationRecordDocumentEquality();

  @override
  bool equals(SpeculationRecord? e1, SpeculationRecord? e2) {
    return e1?.nom == e2?.nom &&
        e1?.illustration == e2?.illustration &&
        e1?.categorie == e2?.categorie;
  }

  @override
  int hash(SpeculationRecord? e) =>
      const ListEquality().hash([e?.nom, e?.illustration, e?.categorie]);

  @override
  bool isValidKey(Object? o) => o is SpeculationRecord;
}
