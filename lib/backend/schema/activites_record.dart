import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ActivitesRecord extends FirestoreRecord {
  ActivitesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "statut" field.
  String? _statut;
  String get statut => _statut ?? '';
  bool hasStatut() => _statut != null;

  // "date_prevue" field.
  DateTime? _datePrevue;
  DateTime? get datePrevue => _datePrevue;
  bool hasDatePrevue() => _datePrevue != null;

  // "date_execution" field.
  DateTime? _dateExecution;
  DateTime? get dateExecution => _dateExecution;
  bool hasDateExecution() => _dateExecution != null;

  // "created_by" field.
  DocumentReference? _createdBy;
  DocumentReference? get createdBy => _createdBy;
  bool hasCreatedBy() => _createdBy != null;

  // "libelle_activite" field.
  String? _libelleActivite;
  String get libelleActivite => _libelleActivite ?? '';
  bool hasLibelleActivite() => _libelleActivite != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "listecommentaire" field.
  List<String>? _listecommentaire;
  List<String> get listecommentaire => _listecommentaire ?? const [];
  bool hasListecommentaire() => _listecommentaire != null;

  // "redacteurcommentaire" field.
  List<String>? _redacteurcommentaire;
  List<String> get redacteurcommentaire => _redacteurcommentaire ?? const [];
  bool hasRedacteurcommentaire() => _redacteurcommentaire != null;

  // "date_creation" field.
  DateTime? _dateCreation;
  DateTime? get dateCreation => _dateCreation;
  bool hasDateCreation() => _dateCreation != null;

  // "approvedby" field.
  DocumentReference? _approvedby;
  DocumentReference? get approvedby => _approvedby;
  bool hasApprovedby() => _approvedby != null;

  // "approvedDate" field.
  DateTime? _approvedDate;
  DateTime? get approvedDate => _approvedDate;
  bool hasApprovedDate() => _approvedDate != null;

  // "RejectedBy" field.
  DocumentReference? _rejectedBy;
  DocumentReference? get rejectedBy => _rejectedBy;
  bool hasRejectedBy() => _rejectedBy != null;

  // "rejectedDate" field.
  DateTime? _rejectedDate;
  DateTime? get rejectedDate => _rejectedDate;
  bool hasRejectedDate() => _rejectedDate != null;

  // "exploitation_ref" field.
  DocumentReference? _exploitationRef;
  DocumentReference? get exploitationRef => _exploitationRef;
  bool hasExploitationRef() => _exploitationRef != null;

  // "photoillustration" field.
  List<String>? _photoillustration;
  List<String> get photoillustration => _photoillustration ?? const [];
  bool hasPhotoillustration() => _photoillustration != null;

  // "inCharge" field.
  DocumentReference? _inCharge;
  DocumentReference? get inCharge => _inCharge;
  bool hasInCharge() => _inCharge != null;

  // "parcelle_ref" field.
  DocumentReference? _parcelleRef;
  DocumentReference? get parcelleRef => _parcelleRef;
  bool hasParcelleRef() => _parcelleRef != null;

  // "NomExploitation" field.
  String? _nomExploitation;
  String get nomExploitation => _nomExploitation ?? '';
  bool hasNomExploitation() => _nomExploitation != null;

  // "NomParcelle" field.
  String? _nomParcelle;
  String get nomParcelle => _nomParcelle ?? '';
  bool hasNomParcelle() => _nomParcelle != null;

  // "NomsDesTravailleurs" field.
  List<String>? _nomsDesTravailleurs;
  List<String> get nomsDesTravailleurs => _nomsDesTravailleurs ?? const [];
  bool hasNomsDesTravailleurs() => _nomsDesTravailleurs != null;

  void _initializeFields() {
    _type = snapshotData['type'] as String?;
    _statut = snapshotData['statut'] as String?;
    _datePrevue = snapshotData['date_prevue'] as DateTime?;
    _dateExecution = snapshotData['date_execution'] as DateTime?;
    _createdBy = snapshotData['created_by'] as DocumentReference?;
    _libelleActivite = snapshotData['libelle_activite'] as String?;
    _description = snapshotData['description'] as String?;
    _listecommentaire = getDataList(snapshotData['listecommentaire']);
    _redacteurcommentaire = getDataList(snapshotData['redacteurcommentaire']);
    _dateCreation = snapshotData['date_creation'] as DateTime?;
    _approvedby = snapshotData['approvedby'] as DocumentReference?;
    _approvedDate = snapshotData['approvedDate'] as DateTime?;
    _rejectedBy = snapshotData['RejectedBy'] as DocumentReference?;
    _rejectedDate = snapshotData['rejectedDate'] as DateTime?;
    _exploitationRef = snapshotData['exploitation_ref'] as DocumentReference?;
    _photoillustration = getDataList(snapshotData['photoillustration']);
    _inCharge = snapshotData['inCharge'] as DocumentReference?;
    _parcelleRef = snapshotData['parcelle_ref'] as DocumentReference?;
    _nomExploitation = snapshotData['NomExploitation'] as String?;
    _nomParcelle = snapshotData['NomParcelle'] as String?;
    _nomsDesTravailleurs = getDataList(snapshotData['NomsDesTravailleurs']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('activites');

  static Stream<ActivitesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ActivitesRecord.fromSnapshot(s));

  static Future<ActivitesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ActivitesRecord.fromSnapshot(s));

  static ActivitesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ActivitesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ActivitesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ActivitesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ActivitesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ActivitesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createActivitesRecordData({
  String? type,
  String? statut,
  DateTime? datePrevue,
  DateTime? dateExecution,
  DocumentReference? createdBy,
  String? libelleActivite,
  String? description,
  DateTime? dateCreation,
  DocumentReference? approvedby,
  DateTime? approvedDate,
  DocumentReference? rejectedBy,
  DateTime? rejectedDate,
  DocumentReference? exploitationRef,
  DocumentReference? inCharge,
  DocumentReference? parcelleRef,
  String? nomExploitation,
  String? nomParcelle,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'type': type,
      'statut': statut,
      'date_prevue': datePrevue,
      'date_execution': dateExecution,
      'created_by': createdBy,
      'libelle_activite': libelleActivite,
      'description': description,
      'date_creation': dateCreation,
      'approvedby': approvedby,
      'approvedDate': approvedDate,
      'RejectedBy': rejectedBy,
      'rejectedDate': rejectedDate,
      'exploitation_ref': exploitationRef,
      'inCharge': inCharge,
      'parcelle_ref': parcelleRef,
      'NomExploitation': nomExploitation,
      'NomParcelle': nomParcelle,
    }.withoutNulls,
  );

  return firestoreData;
}

class ActivitesRecordDocumentEquality implements Equality<ActivitesRecord> {
  const ActivitesRecordDocumentEquality();

  @override
  bool equals(ActivitesRecord? e1, ActivitesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.type == e2?.type &&
        e1?.statut == e2?.statut &&
        e1?.datePrevue == e2?.datePrevue &&
        e1?.dateExecution == e2?.dateExecution &&
        e1?.createdBy == e2?.createdBy &&
        e1?.libelleActivite == e2?.libelleActivite &&
        e1?.description == e2?.description &&
        listEquality.equals(e1?.listecommentaire, e2?.listecommentaire) &&
        listEquality.equals(
            e1?.redacteurcommentaire, e2?.redacteurcommentaire) &&
        e1?.dateCreation == e2?.dateCreation &&
        e1?.approvedby == e2?.approvedby &&
        e1?.approvedDate == e2?.approvedDate &&
        e1?.rejectedBy == e2?.rejectedBy &&
        e1?.rejectedDate == e2?.rejectedDate &&
        e1?.exploitationRef == e2?.exploitationRef &&
        listEquality.equals(e1?.photoillustration, e2?.photoillustration) &&
        e1?.inCharge == e2?.inCharge &&
        e1?.parcelleRef == e2?.parcelleRef &&
        e1?.nomExploitation == e2?.nomExploitation &&
        e1?.nomParcelle == e2?.nomParcelle &&
        listEquality.equals(e1?.nomsDesTravailleurs, e2?.nomsDesTravailleurs);
  }

  @override
  int hash(ActivitesRecord? e) => const ListEquality().hash([
        e?.type,
        e?.statut,
        e?.datePrevue,
        e?.dateExecution,
        e?.createdBy,
        e?.libelleActivite,
        e?.description,
        e?.listecommentaire,
        e?.redacteurcommentaire,
        e?.dateCreation,
        e?.approvedby,
        e?.approvedDate,
        e?.rejectedBy,
        e?.rejectedDate,
        e?.exploitationRef,
        e?.photoillustration,
        e?.inCharge,
        e?.parcelleRef,
        e?.nomExploitation,
        e?.nomParcelle,
        e?.nomsDesTravailleurs
      ]);

  @override
  bool isValidKey(Object? o) => o is ActivitesRecord;
}
