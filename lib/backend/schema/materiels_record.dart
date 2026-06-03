import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MaterielsRecord extends FirestoreRecord {
  MaterielsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "DateAcquisition" field.
  DateTime? _dateAcquisition;
  DateTime? get dateAcquisition => _dateAcquisition;
  bool hasDateAcquisition() => _dateAcquisition != null;

  // "ValeurAchat" field.
  int? _valeurAchat;
  int get valeurAchat => _valeurAchat ?? 0;
  bool hasValeurAchat() => _valeurAchat != null;

  // "DureeDeVie" field.
  int? _dureeDeVie;
  int get dureeDeVie => _dureeDeVie ?? 0;
  bool hasDureeDeVie() => _dureeDeVie != null;

  // "ValeurVenale" field.
  int? _valeurVenale;
  int get valeurVenale => _valeurVenale ?? 0;
  bool hasValeurVenale() => _valeurVenale != null;

  // "ExploitationId" field.
  DocumentReference? _exploitationId;
  DocumentReference? get exploitationId => _exploitationId;
  bool hasExploitationId() => _exploitationId != null;

  // "Exploitation" field.
  String? _exploitation;
  String get exploitation => _exploitation ?? '';
  bool hasExploitation() => _exploitation != null;

  // "Active" field.
  bool? _active;
  bool get active => _active ?? false;
  bool hasActive() => _active != null;

  // "PhotosMateriel" field.
  List<String>? _photosMateriel;
  List<String> get photosMateriel => _photosMateriel ?? const [];
  bool hasPhotosMateriel() => _photosMateriel != null;

  // "NomMateriel" field.
  String? _nomMateriel;
  String get nomMateriel => _nomMateriel ?? '';
  bool hasNomMateriel() => _nomMateriel != null;

  // "Quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  bool hasQuantity() => _quantity != null;

  void _initializeFields() {
    _type = snapshotData['Type'] as String?;
    _dateAcquisition = snapshotData['DateAcquisition'] as DateTime?;
    _valeurAchat = castToType<int>(snapshotData['ValeurAchat']);
    _dureeDeVie = castToType<int>(snapshotData['DureeDeVie']);
    _valeurVenale = castToType<int>(snapshotData['ValeurVenale']);
    _exploitationId = snapshotData['ExploitationId'] as DocumentReference?;
    _exploitation = snapshotData['Exploitation'] as String?;
    _active = snapshotData['Active'] as bool?;
    _photosMateriel = getDataList(snapshotData['PhotosMateriel']);
    _nomMateriel = snapshotData['NomMateriel'] as String?;
    _quantity = castToType<int>(snapshotData['Quantity']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Materiels');

  static Stream<MaterielsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MaterielsRecord.fromSnapshot(s));

  static Future<MaterielsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MaterielsRecord.fromSnapshot(s));

  static MaterielsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      MaterielsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MaterielsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MaterielsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MaterielsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MaterielsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMaterielsRecordData({
  String? type,
  DateTime? dateAcquisition,
  int? valeurAchat,
  int? dureeDeVie,
  int? valeurVenale,
  DocumentReference? exploitationId,
  String? exploitation,
  bool? active,
  String? nomMateriel,
  int? quantity,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Type': type,
      'DateAcquisition': dateAcquisition,
      'ValeurAchat': valeurAchat,
      'DureeDeVie': dureeDeVie,
      'ValeurVenale': valeurVenale,
      'ExploitationId': exploitationId,
      'Exploitation': exploitation,
      'Active': active,
      'NomMateriel': nomMateriel,
      'Quantity': quantity,
    }.withoutNulls,
  );

  return firestoreData;
}

class MaterielsRecordDocumentEquality implements Equality<MaterielsRecord> {
  const MaterielsRecordDocumentEquality();

  @override
  bool equals(MaterielsRecord? e1, MaterielsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.type == e2?.type &&
        e1?.dateAcquisition == e2?.dateAcquisition &&
        e1?.valeurAchat == e2?.valeurAchat &&
        e1?.dureeDeVie == e2?.dureeDeVie &&
        e1?.valeurVenale == e2?.valeurVenale &&
        e1?.exploitationId == e2?.exploitationId &&
        e1?.exploitation == e2?.exploitation &&
        e1?.active == e2?.active &&
        listEquality.equals(e1?.photosMateriel, e2?.photosMateriel) &&
        e1?.nomMateriel == e2?.nomMateriel &&
        e1?.quantity == e2?.quantity;
  }

  @override
  int hash(MaterielsRecord? e) => const ListEquality().hash([
        e?.type,
        e?.dateAcquisition,
        e?.valeurAchat,
        e?.dureeDeVie,
        e?.valeurVenale,
        e?.exploitationId,
        e?.exploitation,
        e?.active,
        e?.photosMateriel,
        e?.nomMateriel,
        e?.quantity
      ]);

  @override
  bool isValidKey(Object? o) => o is MaterielsRecord;
}
