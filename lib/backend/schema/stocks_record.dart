import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StocksRecord extends FirestoreRecord {
  StocksRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "exploitation_ref" field.
  DocumentReference? _exploitationRef;
  DocumentReference? get exploitationRef => _exploitationRef;
  bool hasExploitationRef() => _exploitationRef != null;

  // "produit" field.
  String? _produit;
  String get produit => _produit ?? '';
  bool hasProduit() => _produit != null;

  // "categorie" field.
  String? _categorie;
  String get categorie => _categorie ?? '';
  bool hasCategorie() => _categorie != null;

  // "quantite" field.
  double? _quantite;
  double get quantite => _quantite ?? 0.0;
  bool hasQuantite() => _quantite != null;

  // "unite" field.
  String? _unite;
  String get unite => _unite ?? '';
  bool hasUnite() => _unite != null;

  // "seuil_alerte" field.
  double? _seuilAlerte;
  double get seuilAlerte => _seuilAlerte ?? 0.0;
  bool hasSeuilAlerte() => _seuilAlerte != null;

  // "Cout_total" field.
  int? _coutTotal;
  int get coutTotal => _coutTotal ?? 0;
  bool hasCoutTotal() => _coutTotal != null;

  // "Cout_unitaire" field.
  double? _coutUnitaire;
  double get coutUnitaire => _coutUnitaire ?? 0.0;
  bool hasCoutUnitaire() => _coutUnitaire != null;

  void _initializeFields() {
    _exploitationRef = snapshotData['exploitation_ref'] as DocumentReference?;
    _produit = snapshotData['produit'] as String?;
    _categorie = snapshotData['categorie'] as String?;
    _quantite = castToType<double>(snapshotData['quantite']);
    _unite = snapshotData['unite'] as String?;
    _seuilAlerte = castToType<double>(snapshotData['seuil_alerte']);
    _coutTotal = castToType<int>(snapshotData['Cout_total']);
    _coutUnitaire = castToType<double>(snapshotData['Cout_unitaire']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('stocks');

  static Stream<StocksRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => StocksRecord.fromSnapshot(s));

  static Future<StocksRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => StocksRecord.fromSnapshot(s));

  static StocksRecord fromSnapshot(DocumentSnapshot snapshot) => StocksRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static StocksRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      StocksRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'StocksRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is StocksRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createStocksRecordData({
  DocumentReference? exploitationRef,
  String? produit,
  String? categorie,
  double? quantite,
  String? unite,
  double? seuilAlerte,
  int? coutTotal,
  double? coutUnitaire,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'exploitation_ref': exploitationRef,
      'produit': produit,
      'categorie': categorie,
      'quantite': quantite,
      'unite': unite,
      'seuil_alerte': seuilAlerte,
      'Cout_total': coutTotal,
      'Cout_unitaire': coutUnitaire,
    }.withoutNulls,
  );

  return firestoreData;
}

class StocksRecordDocumentEquality implements Equality<StocksRecord> {
  const StocksRecordDocumentEquality();

  @override
  bool equals(StocksRecord? e1, StocksRecord? e2) {
    return e1?.exploitationRef == e2?.exploitationRef &&
        e1?.produit == e2?.produit &&
        e1?.categorie == e2?.categorie &&
        e1?.quantite == e2?.quantite &&
        e1?.unite == e2?.unite &&
        e1?.seuilAlerte == e2?.seuilAlerte &&
        e1?.coutTotal == e2?.coutTotal &&
        e1?.coutUnitaire == e2?.coutUnitaire;
  }

  @override
  int hash(StocksRecord? e) => const ListEquality().hash([
        e?.exploitationRef,
        e?.produit,
        e?.categorie,
        e?.quantite,
        e?.unite,
        e?.seuilAlerte,
        e?.coutTotal,
        e?.coutUnitaire
      ]);

  @override
  bool isValidKey(Object? o) => o is StocksRecord;
}
