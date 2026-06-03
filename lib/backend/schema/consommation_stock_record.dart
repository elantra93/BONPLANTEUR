import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ConsommationStockRecord extends FirestoreRecord {
  ConsommationStockRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "stock_ref" field.
  DocumentReference? _stockRef;
  DocumentReference? get stockRef => _stockRef;
  bool hasStockRef() => _stockRef != null;

  // "activite_ref" field.
  DocumentReference? _activiteRef;
  DocumentReference? get activiteRef => _activiteRef;
  bool hasActiviteRef() => _activiteRef != null;

  // "quantite" field.
  double? _quantite;
  double get quantite => _quantite ?? 0.0;
  bool hasQuantite() => _quantite != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "IdActivite" field.
  String? _idActivite;
  String get idActivite => _idActivite ?? '';
  bool hasIdActivite() => _idActivite != null;

  // "Commentaire" field.
  String? _commentaire;
  String get commentaire => _commentaire ?? '';
  bool hasCommentaire() => _commentaire != null;

  // "utilisateurstock" field.
  String? _utilisateurstock;
  String get utilisateurstock => _utilisateurstock ?? '';
  bool hasUtilisateurstock() => _utilisateurstock != null;

  // "produit" field.
  String? _produit;
  String get produit => _produit ?? '';
  bool hasProduit() => _produit != null;

  // "activite" field.
  String? _activite;
  String get activite => _activite ?? '';
  bool hasActivite() => _activite != null;

  // "parcelles" field.
  List<String>? _parcelles;
  List<String> get parcelles => _parcelles ?? const [];
  bool hasParcelles() => _parcelles != null;

  void _initializeFields() {
    _stockRef = snapshotData['stock_ref'] as DocumentReference?;
    _activiteRef = snapshotData['activite_ref'] as DocumentReference?;
    _quantite = castToType<double>(snapshotData['quantite']);
    _date = snapshotData['date'] as DateTime?;
    _idActivite = snapshotData['IdActivite'] as String?;
    _commentaire = snapshotData['Commentaire'] as String?;
    _utilisateurstock = snapshotData['utilisateurstock'] as String?;
    _produit = snapshotData['produit'] as String?;
    _activite = snapshotData['activite'] as String?;
    _parcelles = getDataList(snapshotData['parcelles']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('consommation_stock');

  static Stream<ConsommationStockRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ConsommationStockRecord.fromSnapshot(s));

  static Future<ConsommationStockRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ConsommationStockRecord.fromSnapshot(s));

  static ConsommationStockRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ConsommationStockRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ConsommationStockRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ConsommationStockRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ConsommationStockRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ConsommationStockRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createConsommationStockRecordData({
  DocumentReference? stockRef,
  DocumentReference? activiteRef,
  double? quantite,
  DateTime? date,
  String? idActivite,
  String? commentaire,
  String? utilisateurstock,
  String? produit,
  String? activite,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'stock_ref': stockRef,
      'activite_ref': activiteRef,
      'quantite': quantite,
      'date': date,
      'IdActivite': idActivite,
      'Commentaire': commentaire,
      'utilisateurstock': utilisateurstock,
      'produit': produit,
      'activite': activite,
    }.withoutNulls,
  );

  return firestoreData;
}

class ConsommationStockRecordDocumentEquality
    implements Equality<ConsommationStockRecord> {
  const ConsommationStockRecordDocumentEquality();

  @override
  bool equals(ConsommationStockRecord? e1, ConsommationStockRecord? e2) {
    const listEquality = ListEquality();
    return e1?.stockRef == e2?.stockRef &&
        e1?.activiteRef == e2?.activiteRef &&
        e1?.quantite == e2?.quantite &&
        e1?.date == e2?.date &&
        e1?.idActivite == e2?.idActivite &&
        e1?.commentaire == e2?.commentaire &&
        e1?.utilisateurstock == e2?.utilisateurstock &&
        e1?.produit == e2?.produit &&
        e1?.activite == e2?.activite &&
        listEquality.equals(e1?.parcelles, e2?.parcelles);
  }

  @override
  int hash(ConsommationStockRecord? e) => const ListEquality().hash([
        e?.stockRef,
        e?.activiteRef,
        e?.quantite,
        e?.date,
        e?.idActivite,
        e?.commentaire,
        e?.utilisateurstock,
        e?.produit,
        e?.activite,
        e?.parcelles
      ]);

  @override
  bool isValidKey(Object? o) => o is ConsommationStockRecord;
}
