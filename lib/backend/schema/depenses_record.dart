import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DepensesRecord extends FirestoreRecord {
  DepensesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "exploitation_ref" field.
  DocumentReference? _exploitationRef;
  DocumentReference? get exploitationRef => _exploitationRef;
  bool hasExploitationRef() => _exploitationRef != null;

  // "montant" field.
  double? _montant;
  double get montant => _montant ?? 0.0;
  bool hasMontant() => _montant != null;

  // "categorie" field.
  String? _categorie;
  String get categorie => _categorie ?? '';
  bool hasCategorie() => _categorie != null;

  // "justificatif_url" field.
  String? _justificatifUrl;
  String get justificatifUrl => _justificatifUrl ?? '';
  bool hasJustificatifUrl() => _justificatifUrl != null;

  // "statut" field.
  String? _statut;
  String get statut => _statut ?? '';
  bool hasStatut() => _statut != null;

  // "valide_par" field.
  DocumentReference? _validePar;
  DocumentReference? get validePar => _validePar;
  bool hasValidePar() => _validePar != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "photo" field.
  String? _photo;
  String get photo => _photo ?? '';
  bool hasPhoto() => _photo != null;

  // "affectee_a" field.
  String? _affecteeA;
  String get affecteeA => _affecteeA ?? '';
  bool hasAffecteeA() => _affecteeA != null;

  // "parcelle_ref" field.
  DocumentReference? _parcelleRef;
  DocumentReference? get parcelleRef => _parcelleRef;
  bool hasParcelleRef() => _parcelleRef != null;

  // "libelleDepense" field.
  String? _libelleDepense;
  String get libelleDepense => _libelleDepense ?? '';
  bool hasLibelleDepense() => _libelleDepense != null;

  // "CommentaireDepense" field.
  String? _commentaireDepense;
  String get commentaireDepense => _commentaireDepense ?? '';
  bool hasCommentaireDepense() => _commentaireDepense != null;

  // "LibelleParcelle" field.
  String? _libelleParcelle;
  String get libelleParcelle => _libelleParcelle ?? '';
  bool hasLibelleParcelle() => _libelleParcelle != null;

  // "Validateur" field.
  String? _validateur;
  String get validateur => _validateur ?? '';
  bool hasValidateur() => _validateur != null;

  // "Justif_depense" field.
  List<String>? _justifDepense;
  List<String> get justifDepense => _justifDepense ?? const [];
  bool hasJustifDepense() => _justifDepense != null;

  // "autorisation" field.
  String? _autorisation;
  String get autorisation => _autorisation ?? '';
  bool hasAutorisation() => _autorisation != null;

  // "activitesconcern" field.
  List<DocumentReference>? _activitesconcern;
  List<DocumentReference> get activitesconcern => _activitesconcern ?? const [];
  bool hasActivitesconcern() => _activitesconcern != null;

  void _initializeFields() {
    _exploitationRef = snapshotData['exploitation_ref'] as DocumentReference?;
    _montant = castToType<double>(snapshotData['montant']);
    _categorie = snapshotData['categorie'] as String?;
    _justificatifUrl = snapshotData['justificatif_url'] as String?;
    _statut = snapshotData['statut'] as String?;
    _validePar = snapshotData['valide_par'] as DocumentReference?;
    _date = snapshotData['date'] as DateTime?;
    _photo = snapshotData['photo'] as String?;
    _affecteeA = snapshotData['affectee_a'] as String?;
    _parcelleRef = snapshotData['parcelle_ref'] as DocumentReference?;
    _libelleDepense = snapshotData['libelleDepense'] as String?;
    _commentaireDepense = snapshotData['CommentaireDepense'] as String?;
    _libelleParcelle = snapshotData['LibelleParcelle'] as String?;
    _validateur = snapshotData['Validateur'] as String?;
    _justifDepense = getDataList(snapshotData['Justif_depense']);
    _autorisation = snapshotData['autorisation'] as String?;
    _activitesconcern = getDataList(snapshotData['activitesconcern']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('depenses');

  static Stream<DepensesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DepensesRecord.fromSnapshot(s));

  static Future<DepensesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DepensesRecord.fromSnapshot(s));

  static DepensesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DepensesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DepensesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DepensesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DepensesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DepensesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDepensesRecordData({
  DocumentReference? exploitationRef,
  double? montant,
  String? categorie,
  String? justificatifUrl,
  String? statut,
  DocumentReference? validePar,
  DateTime? date,
  String? photo,
  String? affecteeA,
  DocumentReference? parcelleRef,
  String? libelleDepense,
  String? commentaireDepense,
  String? libelleParcelle,
  String? validateur,
  String? autorisation,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'exploitation_ref': exploitationRef,
      'montant': montant,
      'categorie': categorie,
      'justificatif_url': justificatifUrl,
      'statut': statut,
      'valide_par': validePar,
      'date': date,
      'photo': photo,
      'affectee_a': affecteeA,
      'parcelle_ref': parcelleRef,
      'libelleDepense': libelleDepense,
      'CommentaireDepense': commentaireDepense,
      'LibelleParcelle': libelleParcelle,
      'Validateur': validateur,
      'autorisation': autorisation,
    }.withoutNulls,
  );

  return firestoreData;
}

class DepensesRecordDocumentEquality implements Equality<DepensesRecord> {
  const DepensesRecordDocumentEquality();

  @override
  bool equals(DepensesRecord? e1, DepensesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.exploitationRef == e2?.exploitationRef &&
        e1?.montant == e2?.montant &&
        e1?.categorie == e2?.categorie &&
        e1?.justificatifUrl == e2?.justificatifUrl &&
        e1?.statut == e2?.statut &&
        e1?.validePar == e2?.validePar &&
        e1?.date == e2?.date &&
        e1?.photo == e2?.photo &&
        e1?.affecteeA == e2?.affecteeA &&
        e1?.parcelleRef == e2?.parcelleRef &&
        e1?.libelleDepense == e2?.libelleDepense &&
        e1?.commentaireDepense == e2?.commentaireDepense &&
        e1?.libelleParcelle == e2?.libelleParcelle &&
        e1?.validateur == e2?.validateur &&
        listEquality.equals(e1?.justifDepense, e2?.justifDepense) &&
        e1?.autorisation == e2?.autorisation &&
        listEquality.equals(e1?.activitesconcern, e2?.activitesconcern);
  }

  @override
  int hash(DepensesRecord? e) => const ListEquality().hash([
        e?.exploitationRef,
        e?.montant,
        e?.categorie,
        e?.justificatifUrl,
        e?.statut,
        e?.validePar,
        e?.date,
        e?.photo,
        e?.affecteeA,
        e?.parcelleRef,
        e?.libelleDepense,
        e?.commentaireDepense,
        e?.libelleParcelle,
        e?.validateur,
        e?.justifDepense,
        e?.autorisation,
        e?.activitesconcern
      ]);

  @override
  bool isValidKey(Object? o) => o is DepensesRecord;
}
