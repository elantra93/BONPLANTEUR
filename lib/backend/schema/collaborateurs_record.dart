import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CollaborateursRecord extends FirestoreRecord {
  CollaborateursRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "workerId" field.
  String? _workerId;
  String get workerId => _workerId ?? '';
  bool hasWorkerId() => _workerId != null;

  // "nom" field.
  String? _nom;
  String get nom => _nom ?? '';
  bool hasNom() => _nom != null;

  // "prenoms" field.
  String? _prenoms;
  String get prenoms => _prenoms ?? '';
  bool hasPrenoms() => _prenoms != null;

  // "datedenaissance" field.
  DateTime? _datedenaissance;
  DateTime? get datedenaissance => _datedenaissance;
  bool hasDatedenaissance() => _datedenaissance != null;

  // "salairemensuel" field.
  int? _salairemensuel;
  int get salairemensuel => _salairemensuel ?? 0;
  bool hasSalairemensuel() => _salairemensuel != null;

  // "contact" field.
  String? _contact;
  String get contact => _contact ?? '';
  bool hasContact() => _contact != null;

  // "photoidcard" field.
  String? _photoidcard;
  String get photoidcard => _photoidcard ?? '';
  bool hasPhotoidcard() => _photoidcard != null;

  // "photoworker" field.
  String? _photoworker;
  String get photoworker => _photoworker ?? '';
  bool hasPhotoworker() => _photoworker != null;

  // "exploitationid" field.
  DocumentReference? _exploitationid;
  DocumentReference? get exploitationid => _exploitationid;
  bool hasExploitationid() => _exploitationid != null;

  // "datededebut" field.
  DateTime? _datededebut;
  DateTime? get datededebut => _datededebut;
  bool hasDatededebut() => _datededebut != null;

  void _initializeFields() {
    _workerId = snapshotData['workerId'] as String?;
    _nom = snapshotData['nom'] as String?;
    _prenoms = snapshotData['prenoms'] as String?;
    _datedenaissance = snapshotData['datedenaissance'] as DateTime?;
    _salairemensuel = castToType<int>(snapshotData['salairemensuel']);
    _contact = snapshotData['contact'] as String?;
    _photoidcard = snapshotData['photoidcard'] as String?;
    _photoworker = snapshotData['photoworker'] as String?;
    _exploitationid = snapshotData['exploitationid'] as DocumentReference?;
    _datededebut = snapshotData['datededebut'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('collaborateurs');

  static Stream<CollaborateursRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CollaborateursRecord.fromSnapshot(s));

  static Future<CollaborateursRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CollaborateursRecord.fromSnapshot(s));

  static CollaborateursRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CollaborateursRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CollaborateursRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CollaborateursRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CollaborateursRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CollaborateursRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCollaborateursRecordData({
  String? workerId,
  String? nom,
  String? prenoms,
  DateTime? datedenaissance,
  int? salairemensuel,
  String? contact,
  String? photoidcard,
  String? photoworker,
  DocumentReference? exploitationid,
  DateTime? datededebut,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'workerId': workerId,
      'nom': nom,
      'prenoms': prenoms,
      'datedenaissance': datedenaissance,
      'salairemensuel': salairemensuel,
      'contact': contact,
      'photoidcard': photoidcard,
      'photoworker': photoworker,
      'exploitationid': exploitationid,
      'datededebut': datededebut,
    }.withoutNulls,
  );

  return firestoreData;
}

class CollaborateursRecordDocumentEquality
    implements Equality<CollaborateursRecord> {
  const CollaborateursRecordDocumentEquality();

  @override
  bool equals(CollaborateursRecord? e1, CollaborateursRecord? e2) {
    return e1?.workerId == e2?.workerId &&
        e1?.nom == e2?.nom &&
        e1?.prenoms == e2?.prenoms &&
        e1?.datedenaissance == e2?.datedenaissance &&
        e1?.salairemensuel == e2?.salairemensuel &&
        e1?.contact == e2?.contact &&
        e1?.photoidcard == e2?.photoidcard &&
        e1?.photoworker == e2?.photoworker &&
        e1?.exploitationid == e2?.exploitationid &&
        e1?.datededebut == e2?.datededebut;
  }

  @override
  int hash(CollaborateursRecord? e) => const ListEquality().hash([
        e?.workerId,
        e?.nom,
        e?.prenoms,
        e?.datedenaissance,
        e?.salairemensuel,
        e?.contact,
        e?.photoidcard,
        e?.photoworker,
        e?.exploitationid,
        e?.datededebut
      ]);

  @override
  bool isValidKey(Object? o) => o is CollaborateursRecord;
}
