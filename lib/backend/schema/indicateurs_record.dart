import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Les indicateurs clés de performance par parcelle
class IndicateursRecord extends FirestoreRecord {
  IndicateursRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Parcelle_ref" field.
  DocumentReference? _parcelleRef;
  DocumentReference? get parcelleRef => _parcelleRef;
  bool hasParcelleRef() => _parcelleRef != null;

  // "Exploitation_ref" field.
  DocumentReference? _exploitationRef;
  DocumentReference? get exploitationRef => _exploitationRef;
  bool hasExploitationRef() => _exploitationRef != null;

  // "Depenses" field.
  double? _depenses;
  double get depenses => _depenses ?? 0.0;
  bool hasDepenses() => _depenses != null;

  // "Investissements" field.
  double? _investissements;
  double get investissements => _investissements ?? 0.0;
  bool hasInvestissements() => _investissements != null;

  // "Ventes" field.
  double? _ventes;
  double get ventes => _ventes ?? 0.0;
  bool hasVentes() => _ventes != null;

  // "Budget" field.
  double? _budget;
  double get budget => _budget ?? 0.0;
  bool hasBudget() => _budget != null;

  // "TauxExecutionBudget" field.
  double? _tauxExecutionBudget;
  double get tauxExecutionBudget => _tauxExecutionBudget ?? 0.0;
  bool hasTauxExecutionBudget() => _tauxExecutionBudget != null;

  // "CoutDeProductionNet" field.
  double? _coutDeProductionNet;
  double get coutDeProductionNet => _coutDeProductionNet ?? 0.0;
  bool hasCoutDeProductionNet() => _coutDeProductionNet != null;

  // "CoutDeProductionBrut" field.
  double? _coutDeProductionBrut;
  double get coutDeProductionBrut => _coutDeProductionBrut ?? 0.0;
  bool hasCoutDeProductionBrut() => _coutDeProductionBrut != null;

  // "AutresRevenus" field.
  double? _autresRevenus;
  double get autresRevenus => _autresRevenus ?? 0.0;
  bool hasAutresRevenus() => _autresRevenus != null;

  // "RendementAttendu" field.
  double? _rendementAttendu;
  double get rendementAttendu => _rendementAttendu ?? 0.0;
  bool hasRendementAttendu() => _rendementAttendu != null;

  // "ResultatTheorique" field.
  double? _resultatTheorique;
  double get resultatTheorique => _resultatTheorique ?? 0.0;
  bool hasResultatTheorique() => _resultatTheorique != null;

  // "RevenuCible" field.
  double? _revenuCible;
  double get revenuCible => _revenuCible ?? 0.0;
  bool hasRevenuCible() => _revenuCible != null;

  // "PrixDeVenteCible" field.
  int? _prixDeVenteCible;
  int get prixDeVenteCible => _prixDeVenteCible ?? 0;
  bool hasPrixDeVenteCible() => _prixDeVenteCible != null;

  void _initializeFields() {
    _parcelleRef = snapshotData['Parcelle_ref'] as DocumentReference?;
    _exploitationRef = snapshotData['Exploitation_ref'] as DocumentReference?;
    _depenses = castToType<double>(snapshotData['Depenses']);
    _investissements = castToType<double>(snapshotData['Investissements']);
    _ventes = castToType<double>(snapshotData['Ventes']);
    _budget = castToType<double>(snapshotData['Budget']);
    _tauxExecutionBudget =
        castToType<double>(snapshotData['TauxExecutionBudget']);
    _coutDeProductionNet =
        castToType<double>(snapshotData['CoutDeProductionNet']);
    _coutDeProductionBrut =
        castToType<double>(snapshotData['CoutDeProductionBrut']);
    _autresRevenus = castToType<double>(snapshotData['AutresRevenus']);
    _rendementAttendu = castToType<double>(snapshotData['RendementAttendu']);
    _resultatTheorique = castToType<double>(snapshotData['ResultatTheorique']);
    _revenuCible = castToType<double>(snapshotData['RevenuCible']);
    _prixDeVenteCible = castToType<int>(snapshotData['PrixDeVenteCible']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Indicateurs');

  static Stream<IndicateursRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => IndicateursRecord.fromSnapshot(s));

  static Future<IndicateursRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => IndicateursRecord.fromSnapshot(s));

  static IndicateursRecord fromSnapshot(DocumentSnapshot snapshot) =>
      IndicateursRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static IndicateursRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      IndicateursRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'IndicateursRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is IndicateursRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createIndicateursRecordData({
  DocumentReference? parcelleRef,
  DocumentReference? exploitationRef,
  double? depenses,
  double? investissements,
  double? ventes,
  double? budget,
  double? tauxExecutionBudget,
  double? coutDeProductionNet,
  double? coutDeProductionBrut,
  double? autresRevenus,
  double? rendementAttendu,
  double? resultatTheorique,
  double? revenuCible,
  int? prixDeVenteCible,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Parcelle_ref': parcelleRef,
      'Exploitation_ref': exploitationRef,
      'Depenses': depenses,
      'Investissements': investissements,
      'Ventes': ventes,
      'Budget': budget,
      'TauxExecutionBudget': tauxExecutionBudget,
      'CoutDeProductionNet': coutDeProductionNet,
      'CoutDeProductionBrut': coutDeProductionBrut,
      'AutresRevenus': autresRevenus,
      'RendementAttendu': rendementAttendu,
      'ResultatTheorique': resultatTheorique,
      'RevenuCible': revenuCible,
      'PrixDeVenteCible': prixDeVenteCible,
    }.withoutNulls,
  );

  return firestoreData;
}

class IndicateursRecordDocumentEquality implements Equality<IndicateursRecord> {
  const IndicateursRecordDocumentEquality();

  @override
  bool equals(IndicateursRecord? e1, IndicateursRecord? e2) {
    return e1?.parcelleRef == e2?.parcelleRef &&
        e1?.exploitationRef == e2?.exploitationRef &&
        e1?.depenses == e2?.depenses &&
        e1?.investissements == e2?.investissements &&
        e1?.ventes == e2?.ventes &&
        e1?.budget == e2?.budget &&
        e1?.tauxExecutionBudget == e2?.tauxExecutionBudget &&
        e1?.coutDeProductionNet == e2?.coutDeProductionNet &&
        e1?.coutDeProductionBrut == e2?.coutDeProductionBrut &&
        e1?.autresRevenus == e2?.autresRevenus &&
        e1?.rendementAttendu == e2?.rendementAttendu &&
        e1?.resultatTheorique == e2?.resultatTheorique &&
        e1?.revenuCible == e2?.revenuCible &&
        e1?.prixDeVenteCible == e2?.prixDeVenteCible;
  }

  @override
  int hash(IndicateursRecord? e) => const ListEquality().hash([
        e?.parcelleRef,
        e?.exploitationRef,
        e?.depenses,
        e?.investissements,
        e?.ventes,
        e?.budget,
        e?.tauxExecutionBudget,
        e?.coutDeProductionNet,
        e?.coutDeProductionBrut,
        e?.autresRevenus,
        e?.rendementAttendu,
        e?.resultatTheorique,
        e?.revenuCible,
        e?.prixDeVenteCible
      ]);

  @override
  bool isValidKey(Object? o) => o is IndicateursRecord;
}
