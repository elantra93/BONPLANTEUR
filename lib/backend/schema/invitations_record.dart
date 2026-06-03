import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class InvitationsRecord extends FirestoreRecord {
  InvitationsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "telephone" field.
  String? _telephone;
  String get telephone => _telephone ?? '';
  bool hasTelephone() => _telephone != null;

  // "exploitation_ref" field.
  DocumentReference? _exploitationRef;
  DocumentReference? get exploitationRef => _exploitationRef;
  bool hasExploitationRef() => _exploitationRef != null;

  // "code_invitation" field.
  String? _codeInvitation;
  String get codeInvitation => _codeInvitation ?? '';
  bool hasCodeInvitation() => _codeInvitation != null;

  // "statut" field.
  String? _statut;
  String get statut => _statut ?? '';
  bool hasStatut() => _statut != null;

  // "invited_by" field.
  DocumentReference? _invitedBy;
  DocumentReference? get invitedBy => _invitedBy;
  bool hasInvitedBy() => _invitedBy != null;

  // "date_envoi" field.
  DateTime? _dateEnvoi;
  DateTime? get dateEnvoi => _dateEnvoi;
  bool hasDateEnvoi() => _dateEnvoi != null;

  // "date_expiration" field.
  DateTime? _dateExpiration;
  DateTime? get dateExpiration => _dateExpiration;
  bool hasDateExpiration() => _dateExpiration != null;

  void _initializeFields() {
    _telephone = snapshotData['telephone'] as String?;
    _exploitationRef = snapshotData['exploitation_ref'] as DocumentReference?;
    _codeInvitation = snapshotData['code_invitation'] as String?;
    _statut = snapshotData['statut'] as String?;
    _invitedBy = snapshotData['invited_by'] as DocumentReference?;
    _dateEnvoi = snapshotData['date_envoi'] as DateTime?;
    _dateExpiration = snapshotData['date_expiration'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('invitations');

  static Stream<InvitationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => InvitationsRecord.fromSnapshot(s));

  static Future<InvitationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => InvitationsRecord.fromSnapshot(s));

  static InvitationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      InvitationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static InvitationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      InvitationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'InvitationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is InvitationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createInvitationsRecordData({
  String? telephone,
  DocumentReference? exploitationRef,
  String? codeInvitation,
  String? statut,
  DocumentReference? invitedBy,
  DateTime? dateEnvoi,
  DateTime? dateExpiration,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'telephone': telephone,
      'exploitation_ref': exploitationRef,
      'code_invitation': codeInvitation,
      'statut': statut,
      'invited_by': invitedBy,
      'date_envoi': dateEnvoi,
      'date_expiration': dateExpiration,
    }.withoutNulls,
  );

  return firestoreData;
}

class InvitationsRecordDocumentEquality implements Equality<InvitationsRecord> {
  const InvitationsRecordDocumentEquality();

  @override
  bool equals(InvitationsRecord? e1, InvitationsRecord? e2) {
    return e1?.telephone == e2?.telephone &&
        e1?.exploitationRef == e2?.exploitationRef &&
        e1?.codeInvitation == e2?.codeInvitation &&
        e1?.statut == e2?.statut &&
        e1?.invitedBy == e2?.invitedBy &&
        e1?.dateEnvoi == e2?.dateEnvoi &&
        e1?.dateExpiration == e2?.dateExpiration;
  }

  @override
  int hash(InvitationsRecord? e) => const ListEquality().hash([
        e?.telephone,
        e?.exploitationRef,
        e?.codeInvitation,
        e?.statut,
        e?.invitedBy,
        e?.dateEnvoi,
        e?.dateExpiration
      ]);

  @override
  bool isValidKey(Object? o) => o is InvitationsRecord;
}
