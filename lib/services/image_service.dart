import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/upload_data.dart';

class ImageService {
  static const int _maxDimension = 1200;
  static const int _quality = 80;

  static final ImageService instance = ImageService._();
  ImageService._();

  // Pick (caméra ou galerie) + compression + upload Firebase Storage.
  // Retourne la liste de download URLs uploadées avec succès.
  Future<List<String>> pickAndUpload({
    required BuildContext context,
    required String folder,
    bool allowMultiple = false,
    int maxImages = 5,
  }) async {
    final theme = FlutterFlowTheme.of(context);

    final selectedMedia = await selectMediaWithSourceBottomSheet(
      context: context,
      storageFolderPath: folder,
      maxWidth: _maxDimension.toDouble(),
      maxHeight: _maxDimension.toDouble(),
      imageQuality: _quality,
      allowPhoto: true,
      allowVideo: false,
      pickerFontFamily: 'Inter',
      textColor: theme.primaryText,
      backgroundColor: theme.secondaryBackground,
    );

    if (selectedMedia == null || selectedMedia.isEmpty) return [];

    if (!context.mounted) return [];
    _showProgress(context);

    final urls = <String>[];
    try {
      final results = await Future.wait(
        selectedMedia
            .take(allowMultiple ? maxImages : 1)
            .map((m) => uploadData(m.storagePath, m.bytes)),
      );

      for (final url in results) {
        if (url != null) urls.add(url);
      }

      if (!context.mounted) return urls;

      if (urls.length == results.length) {
        _showSuccess(context);
      } else {
        _showError(context, 'Certaines photos n\'ont pas pu être envoyées.');
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Erreur lors de l\'envoi de la photo.');
      }
    }

    return urls;
  }

  // Upload de bytes bruts vers un chemin Firebase Storage.
  Future<String?> uploadBytes({
    required Uint8List bytes,
    required String storagePath,
  }) async {
    return uploadData(storagePath, bytes);
  }

  // Supprime un fichier depuis son download URL Firebase.
  Future<void> deleteFromUrl(String downloadUrl) async {
    try {
      await FirebaseStorage.instance.refFromURL(downloadUrl).delete();
    } catch (_) {
      // Fichier déjà supprimé ou URL invalide — on ignore silencieusement
    }
  }

  // Génère un chemin de stockage unique dans le dossier donné.
  String generatePath(String folder) {
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '$folder/$ts.jpg';
  }

  // ── Snackbars ─────────────────────────────────────────────────────────────

  void _showProgress(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                'Envoi en cours…',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          duration: const Duration(seconds: 30),
          backgroundColor: const Color(0xFF1B6B3A),
        ),
      );
  }

  void _showSuccess(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                'Photo envoyée avec succès',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: const Color(0xFF2E9050),
        ),
      );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 5),
          backgroundColor: const Color(0xFFCF4343),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
  }
}
