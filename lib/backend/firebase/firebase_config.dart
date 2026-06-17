import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCen00V3T3r_vFPkMdYbnfqq3rsOhm1iFM",
            authDomain: "d-e-m-e-t-e-rv1-jorr0i.firebaseapp.com",
            projectId: "d-e-m-e-t-e-rv1-jorr0i",
            storageBucket: "d-e-m-e-t-e-rv1-jorr0i.firebasestorage.app",
            messagingSenderId: "503287044079",
            appId: "1:503287044079:web:60fb950924bf2d1f05081a"));
  } else {
    await Firebase.initializeApp();

    // Activer le cache Firestore pour le mode hors ligne.
    // Le SDK met en cache les lectures et rejoue les écritures automatiquement.
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
}
