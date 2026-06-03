import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ParcellesRecord extends FirestoreRecord {
  ParcellesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "nomparcelle" field.
  String? _nomparcelle;
  String get nomparcelle => _nomparcelle ?? '';
  bool hasNomparcelle() => _nomparcelle != null;

  // "superficieparcelle" field.
  double? _superficieparcelle;
  double get superficieparcelle => _superficieparcelle ?? 0.0;
  bool hasSuperficieparcelle() => _superficieparcelle != null;

  // "speculationparcelle" field.
  String? _speculationparcelle;
  String get speculationparcelle => _speculationparcelle ?? '';
  bool hasSpeculationparcelle() => _speculationparcelle != null;

  // "PleinCiel" field.
  bool? _pleinCiel;
  bool get pleinCiel => _pleinCiel ?? false;
  bool hasPleinCiel() => _pleinCiel != null;

  // "HorsSol" field.
  bool? _horsSol;
  bool get horsSol => _horsSol ?? false;
  bool hasHorsSol() => _horsSol != null;

  // "DateCreation" field.
  DateTime? _dateCreation;
  DateTime? get dateCreation => _dateCreation;
  bool hasDateCreation() => _dateCreation != null;

  // "DateSemis" field.
  DateTime? _dateSemis;
  DateTime? get dateSemis => _dateSemis;
  bool hasDateSemis() => _dateSemis != null;

  // "DateRecolte" field.
  DateTime? _dateRecolte;
  DateTime? get dateRecolte => _dateRecolte;
  bool hasDateRecolte() => _dateRecolte != null;

  // "DepensesParcelle" field.
  double? _depensesParcelle;
  double get depensesParcelle => _depensesParcelle ?? 0.0;
  bool hasDepensesParcelle() => _depensesParcelle != null;

  // "RendementAttendu" field.
  double? _rendementAttendu;
  double get rendementAttendu => _rendementAttendu ?? 0.0;
  bool hasRendementAttendu() => _rendementAttendu != null;

  // "RendementRealise" field.
  double? _rendementRealise;
  double get rendementRealise => _rendementRealise ?? 0.0;
  bool hasRendementRealise() => _rendementRealise != null;

  // "ParcelleActive" field.
  bool? _parcelleActive;
  bool get parcelleActive => _parcelleActive ?? false;
  bool hasParcelleActive() => _parcelleActive != null;

  // "ref_exploitation" field.
  DocumentReference? _refExploitation;
  DocumentReference? get refExploitation => _refExploitation;
  bool hasRefExploitation() => _refExploitation != null;

  // "RevenuParcelle" field.
  double? _revenuParcelle;
  double get revenuParcelle => _revenuParcelle ?? 0.0;
  bool hasRevenuParcelle() => _revenuParcelle != null;

  // "DateModification" field.
  DateTime? _dateModification;
  DateTime? get dateModification => _dateModification;
  bool hasDateModification() => _dateModification != null;

  // "BudgetParcelle" field.
  int? _budgetParcelle;
  int get budgetParcelle => _budgetParcelle ?? 0;
  bool hasBudgetParcelle() => _budgetParcelle != null;

  // "collaborateur_ref" field.
  DocumentReference? _collaborateurRef;
  DocumentReference? get collaborateurRef => _collaborateurRef;
  bool hasCollaborateurRef() => _collaborateurRef != null;

  void _initializeFields() {
    _nomparcelle = snapshotData['nomparcelle'] as String?;
    _superficieparcelle =
        castToType<double>(snapshotData['superficieparcelle']);
    _speculationparcelle = snapshotData['speculationparcelle'] as String?;
    _pleinCiel = snapshotData['PleinCiel'] as bool?;
    _horsSol = snapshotData['HorsSol'] as bool?;
    _dateCreation = snapshotData['DateCreation'] as DateTime?;
    _dateSemis = snapshotData['DateSemis'] as DateTime?;
    _dateRecolte = snapshotData['DateRecolte'] as DateTime?;
    _depensesParcelle = castToType<double>(snapshotData['DepensesParcelle']);
    _rendementAttendu = castToType<double>(snapshotData['RendementAttendu']);
    _rendementRealise = castToType<double>(snapshotData['RendementRealise']);
    _parcelleActive = snapshotData['ParcelleActive'] as bool?;
    _refExploitation = snapshotData['ref_exploitation'] as DocumentReference?;
    _revenuParcelle = castToType<double>(snapshotData['RevenuParcelle']);
    _dateModification = snapshotData['DateModification'] as DateTime?;
    _budgetParcelle = castToType<int>(snapshotData['BudgetParcelle']);
    _collaborateurRef = snapshotData['collaborateur_ref'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Parcelles');

  static Stream<ParcellesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ParcellesRecord.fromSnapshot(s));

  static Future<ParcellesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ParcellesRecord.fromSnapshot(s));

  static ParcellesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ParcellesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ParcellesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ParcellesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ParcellesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ParcellesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createParcellesRecordData({
  String? nomparcelle,
  double? superficieparcelle,
  String? speculationparcelle,
  bool? pleinCiel,
  bool? horsSol,
  DateTime? dateCreation,
  DateTime? dateSemis,
  DateTime? dateRecolte,
  double? depensesParcelle,
  double? rendementAttendu,
  double? rendementRealise,
  bool? parcelleActive,
  DocumentReference? refExploitation,
  double? revenuParcelle,
  DateTime? dateModification,
  int? budgetParcelle,
  DocumentReference? collaborateurRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'nomparcelle': nomparcelle,
      'superficieparcelle': superficieparcelle,
      'speculationparcelle': speculationparcelle,
      'PleinCiel': pleinCiel,
      'HorsSol': horsSol,
      'DateCreation': dateCreation,
      'DateSemis': dateSemis,
      'DateRecolte': dateRecolte,
      'DepensesParcelle': depensesParcelle,
      'RendementAttendu': rendementAttendu,
      'RendementRealise': rendementRealise,
      'ParcelleActive': parcelleActive,
      'ref_exploitation': refExploitation,
      'RevenuParcelle': revenuParcelle,
      'DateModification': dateModification,
      'BudgetParcelle': budgetParcelle,
      'collaborateur_ref': collaborateurRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class ParcellesRecordDocumentEquality implements Equality<ParcellesRecord> {
  const ParcellesRecordDocumentEquality();

  @override
  bool equals(ParcellesRecord? e1, ParcellesRecord? e2) {
    return e1?.nomparcelle == e2?.nomparcelle &&
        e1?.superficieparcelle == e2?.superficieparcelle &&
        e1?.speculationparcelle == e2?.speculationparcelle &&
        e1?.pleinCiel == e2?.pleinCiel &&
        e1?.horsSol == e2?.horsSol &&
        e1?.dateCreation == e2?.dateCreation &&
        e1?.dateSemis == e2?.dateSemis &&
        e1?.dateRecolte == e2?.dateRecolte &&
        e1?.depensesParcelle == e2?.depensesParcelle &&
        e1?.rendementAttendu == e2?.rendementAttendu &&
        e1?.rendementRealise == e2?.rendementRealise &&
        e1?.parcelleActive == e2?.parcelleActive &&
        e1?.refExploitation == e2?.refExploitation &&
        e1?.revenuParcelle == e2?.revenuParcelle &&
        e1?.dateModification == e2?.dateModification &&
        e1?.budgetParcelle == e2?.budgetParcelle &&
        e1?.collaborateurRef == e2?.collaborateurRef;
  }

  @override
  int hash(ParcellesRecord? e) => const ListEquality().hash([
        e?.nomparcelle,
        e?.superficieparcelle,
        e?.speculationparcelle,
        e?.pleinCiel,
        e?.horsSol,
        e?.dateCreation,
        e?.dateSemis,
        e?.dateRecolte,
        e?.depensesParcelle,
        e?.rendementAttendu,
        e?.rendementRealise,
        e?.parcelleActive,
        e?.refExploitation,
        e?.revenuParcelle,
        e?.dateModification,
        e?.budgetParcelle,
        e?.collaborateurRef
      ]);

  @override
  bool isValidKey(Object? o) => o is ParcellesRecord;
}
