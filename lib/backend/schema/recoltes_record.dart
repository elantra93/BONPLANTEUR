import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RecoltesRecord extends FirestoreRecord {
  RecoltesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "quantite" field.
  double? _quantite;
  double get quantite => _quantite ?? 0.0;
  bool hasQuantite() => _quantite != null;

  // "unite" field.
  String? _unite;
  String get unite => _unite ?? '';
  bool hasUnite() => _unite != null;

  // "date_recolte" field.
  DateTime? _dateRecolte;
  DateTime? get dateRecolte => _dateRecolte;
  bool hasDateRecolte() => _dateRecolte != null;

  // "parcelle_ref" field.
  DocumentReference? _parcelleRef;
  DocumentReference? get parcelleRef => _parcelleRef;
  bool hasParcelleRef() => _parcelleRef != null;

  // "lot_recolte" field.
  String? _lotRecolte;
  String get lotRecolte => _lotRecolte ?? '';
  bool hasLotRecolte() => _lotRecolte != null;

  void _initializeFields() {
    _quantite = castToType<double>(snapshotData['quantite']);
    _unite = snapshotData['unite'] as String?;
    _dateRecolte = snapshotData['date_recolte'] as DateTime?;
    _parcelleRef = snapshotData['parcelle_ref'] as DocumentReference?;
    _lotRecolte = snapshotData['lot_recolte'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('recoltes');

  static Stream<RecoltesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RecoltesRecord.fromSnapshot(s));

  static Future<RecoltesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RecoltesRecord.fromSnapshot(s));

  static RecoltesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RecoltesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RecoltesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RecoltesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RecoltesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RecoltesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRecoltesRecordData({
  double? quantite,
  String? unite,
  DateTime? dateRecolte,
  DocumentReference? parcelleRef,
  String? lotRecolte,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'quantite': quantite,
      'unite': unite,
      'date_recolte': dateRecolte,
      'parcelle_ref': parcelleRef,
      'lot_recolte': lotRecolte,
    }.withoutNulls,
  );

  return firestoreData;
}

class RecoltesRecordDocumentEquality implements Equality<RecoltesRecord> {
  const RecoltesRecordDocumentEquality();

  @override
  bool equals(RecoltesRecord? e1, RecoltesRecord? e2) {
    return e1?.quantite == e2?.quantite &&
        e1?.unite == e2?.unite &&
        e1?.dateRecolte == e2?.dateRecolte &&
        e1?.parcelleRef == e2?.parcelleRef &&
        e1?.lotRecolte == e2?.lotRecolte;
  }

  @override
  int hash(RecoltesRecord? e) => const ListEquality().hash(
      [e?.quantite, e?.unite, e?.dateRecolte, e?.parcelleRef, e?.lotRecolte]);

  @override
  bool isValidKey(Object? o) => o is RecoltesRecord;
}
