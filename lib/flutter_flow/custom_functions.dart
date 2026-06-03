import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

double? formatDecimal(String? inputString) {
  if (inputString == null || inputString.isEmpty) {
    return null;
  }
  // On remplace la virgule par un point
  String cleaned = inputString.replaceAll(',', '.');
  return double.tryParse(cleaned);
}

DocumentReference? getDocRefFromID(String? docID) {
  if (docID == null || docID.isEmpty) return null;

  return FirebaseFirestore.instance.collection('parcelles').doc(docID);
}

DocumentReference? getExploitationRef(String? docID) {
  if (docID == null || docID.isEmpty) return null;

  return FirebaseFirestore.instance.collection('exploitations').doc(docID);
}

DocumentReference? getWorkerRefFromID(String? docID) {
  if (docID == null || docID.isEmpty) return null;

  return FirebaseFirestore.instance.collection('collaborateurs').doc(docID);
}

DocumentReference? getActiviteRefFromTxt(String? activiteRef) {
  if (activiteRef == null || activiteRef.isEmpty) return null;

  return FirebaseFirestore.instance.collection('activites').doc(activiteRef);
}

String? generateInvitationCode() {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final random = math.Random.secure();
  final code =
      List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
  return 'DEM-$code';
}

List<DocumentReference>? stringListToActiviteRefList(List<String>? idList) {
  if (idList == null || idList.isEmpty) {
    return [];
  }

  return idList
      // ignore: unnecessary_null_comparison
      .where((id) => id != null && id.isNotEmpty)
      .map((id) => FirebaseFirestore.instance.collection('activites').doc(id))
      .toList();
}
