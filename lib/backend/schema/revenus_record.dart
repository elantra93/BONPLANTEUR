import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RevenusRecord extends FirestoreRecord {
  RevenusRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "montant" field.
  double? _montant;
  double get montant => _montant ?? 0.0;
  bool hasMontant() => _montant != null;

  // "typeOperation" field.
  String? _typeOperation;
  String get typeOperation => _typeOperation ?? '';
  bool hasTypeOperation() => _typeOperation != null;

  // "libelle" field.
  String? _libelle;
  String get libelle => _libelle ?? '';
  bool hasLibelle() => _libelle != null;

  // "dateOperation" field.
  DateTime? _dateOperation;
  DateTime? get dateOperation => _dateOperation;
  bool hasDateOperation() => _dateOperation != null;

  // "origine" field.
  String? _origine;
  String get origine => _origine ?? '';
  bool hasOrigine() => _origine != null;

  // "referenceInterne" field.
  String? _referenceInterne;
  String get referenceInterne => _referenceInterne ?? '';
  bool hasReferenceInterne() => _referenceInterne != null;

  // "photoJustifs" field.
  List<String>? _photoJustifs;
  List<String> get photoJustifs => _photoJustifs ?? const [];
  bool hasPhotoJustifs() => _photoJustifs != null;

  // "commentaire" field.
  String? _commentaire;
  String get commentaire => _commentaire ?? '';
  bool hasCommentaire() => _commentaire != null;

  // "created_by" field.
  DocumentReference? _createdBy;
  DocumentReference? get createdBy => _createdBy;
  bool hasCreatedBy() => _createdBy != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updated_at" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  // "recolteAssocie" field.
  DocumentReference? _recolteAssocie;
  DocumentReference? get recolteAssocie => _recolteAssocie;
  bool hasRecolteAssocie() => _recolteAssocie != null;

  void _initializeFields() {
    _montant = castToType<double>(snapshotData['montant']);
    _typeOperation = snapshotData['typeOperation'] as String?;
    _libelle = snapshotData['libelle'] as String?;
    _dateOperation = snapshotData['dateOperation'] as DateTime?;
    _origine = snapshotData['origine'] as String?;
    _referenceInterne = snapshotData['referenceInterne'] as String?;
    _photoJustifs = getDataList(snapshotData['photoJustifs']);
    _commentaire = snapshotData['commentaire'] as String?;
    _createdBy = snapshotData['created_by'] as DocumentReference?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _updatedAt = snapshotData['updated_at'] as DateTime?;
    _recolteAssocie = snapshotData['recolteAssocie'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('revenus');

  static Stream<RevenusRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RevenusRecord.fromSnapshot(s));

  static Future<RevenusRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RevenusRecord.fromSnapshot(s));

  static RevenusRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RevenusRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RevenusRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RevenusRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RevenusRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RevenusRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRevenusRecordData({
  double? montant,
  String? typeOperation,
  String? libelle,
  DateTime? dateOperation,
  String? origine,
  String? referenceInterne,
  String? commentaire,
  DocumentReference? createdBy,
  DateTime? createdAt,
  DateTime? updatedAt,
  DocumentReference? recolteAssocie,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'montant': montant,
      'typeOperation': typeOperation,
      'libelle': libelle,
      'dateOperation': dateOperation,
      'origine': origine,
      'referenceInterne': referenceInterne,
      'commentaire': commentaire,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'recolteAssocie': recolteAssocie,
    }.withoutNulls,
  );

  return firestoreData;
}

class RevenusRecordDocumentEquality implements Equality<RevenusRecord> {
  const RevenusRecordDocumentEquality();

  @override
  bool equals(RevenusRecord? e1, RevenusRecord? e2) {
    const listEquality = ListEquality();
    return e1?.montant == e2?.montant &&
        e1?.typeOperation == e2?.typeOperation &&
        e1?.libelle == e2?.libelle &&
        e1?.dateOperation == e2?.dateOperation &&
        e1?.origine == e2?.origine &&
        e1?.referenceInterne == e2?.referenceInterne &&
        listEquality.equals(e1?.photoJustifs, e2?.photoJustifs) &&
        e1?.commentaire == e2?.commentaire &&
        e1?.createdBy == e2?.createdBy &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt &&
        e1?.recolteAssocie == e2?.recolteAssocie;
  }

  @override
  int hash(RevenusRecord? e) => const ListEquality().hash([
        e?.montant,
        e?.typeOperation,
        e?.libelle,
        e?.dateOperation,
        e?.origine,
        e?.referenceInterne,
        e?.photoJustifs,
        e?.commentaire,
        e?.createdBy,
        e?.createdAt,
        e?.updatedAt,
        e?.recolteAssocie
      ]);

  @override
  bool isValidKey(Object? o) => o is RevenusRecord;
}
