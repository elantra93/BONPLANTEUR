import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/flutter_flow/flutter_flow_theme.dart';

/// Gestion centralisée des erreurs DEMETER.
/// Toutes les opérations Firestore et Firebase Auth doivent passer par ce service.
class ErrorHandler {
  static final ErrorHandler instance = ErrorHandler._();
  ErrorHandler._();

  // ── API publique ───────────────────────────────────────────────────────────

  /// Gère une erreur Firestore et affiche un message utilisateur en français.
  void handleFirestore(BuildContext context, Object e, {String? operation}) {
    final msg = _firestoreMessage(e, operation: operation);
    _show(context, msg, isError: true);
  }

  /// Gère une erreur Firebase Auth.
  void handleAuth(BuildContext context, Object e) {
    final msg = _authMessage(e);
    _show(context, msg, isError: true);
  }

  /// Gère une erreur générique.
  void handleGeneric(BuildContext context, Object e, {String? fallback}) {
    final msg = fallback ?? _genericMessage(e);
    _show(context, msg, isError: true);
  }

  /// Affiche un message de succès.
  void showSuccess(BuildContext context, String message) {
    _show(context, message, isError: false);
  }

  /// Affiche un message d'information.
  void showInfo(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      icon: Icons.info_outline,
      bgColor: FlutterFlowTheme.of(context).info,
    );
  }

  /// Exécute [action] avec gestion automatique des erreurs Firestore.
  /// Retourne true si succès, false si erreur.
  Future<bool> runFirestore(
    BuildContext context,
    Future<void> Function() action, {
    String? operation,
    String? successMessage,
  }) async {
    try {
      await action();
      if (successMessage != null && context.mounted) {
        showSuccess(context, successMessage);
      }
      return true;
    } on FirebaseException catch (e) {
      if (context.mounted) handleFirestore(context, e, operation: operation);
      return false;
    } catch (e) {
      if (context.mounted) handleGeneric(context, e);
      return false;
    }
  }

  // ── Messages d'erreur ──────────────────────────────────────────────────────

  String _firestoreMessage(Object e, {String? operation}) {
    if (e is FirebaseException) {
      switch (e.code) {
        case 'permission-denied':
          return 'Accès refusé. Vérifiez vos permissions.';
        case 'not-found':
          return 'Élément introuvable. Il a peut-être été supprimé.';
        case 'already-exists':
          return 'Cet élément existe déjà.';
        case 'unavailable':
          return 'Service temporairement indisponible. Réessayez dans quelques instants.';
        case 'deadline-exceeded':
          return 'La requête a pris trop de temps. Vérifiez votre connexion.';
        case 'resource-exhausted':
          return 'Quota dépassé. Contactez l\'administrateur.';
        case 'failed-precondition':
          return 'Opération impossible dans l\'état actuel.';
        case 'cancelled':
          return 'Opération annulée.';
        case 'data-loss':
          return 'Erreur de données. Contactez le support.';
        case 'unauthenticated':
          return 'Session expirée. Reconnectez-vous.';
        default:
          return operation != null
              ? 'Erreur lors de $operation. Réessayez.'
              : 'Une erreur est survenue. Réessayez.';
      }
    }
    return _genericMessage(e);
  }

  String _authMessage(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'Aucun compte trouvé avec ces identifiants.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Mot de passe incorrect. Réessayez.';
        case 'user-disabled':
          return 'Ce compte a été désactivé.';
        case 'too-many-requests':
          return 'Trop de tentatives. Réessayez dans quelques minutes.';
        case 'email-already-in-use':
          return 'Ce numéro est déjà associé à un compte.';
        case 'weak-password':
          return 'Mot de passe trop faible (8 caractères minimum).';
        case 'invalid-phone-number':
          return 'Numéro de téléphone invalide.';
        case 'invalid-verification-code':
          return 'Code de vérification incorrect.';
        case 'session-expired':
          return 'Code expiré. Demandez un nouveau code.';
        case 'network-request-failed':
          return 'Pas de connexion réseau. Vérifiez votre connexion.';
        default:
          return 'Erreur d\'authentification. Réessayez.';
      }
    }
    return _genericMessage(e);
  }

  String _genericMessage(Object e) {
    if (e.toString().contains('network') ||
        e.toString().contains('SocketException')) {
      return 'Pas de connexion réseau. Vérifiez votre connexion.';
    }
    return 'Une erreur inattendue s\'est produite. Réessayez.';
  }

  // ── Snackbars ──────────────────────────────────────────────────────────────

  void _show(BuildContext context, String message, {required bool isError}) {
    final theme = FlutterFlowTheme.of(context);
    _showSnackbar(
      context,
      message: message,
      icon: isError ? Icons.error_outline : Icons.check_circle_outline,
      bgColor: isError ? theme.error : theme.success,
    );
  }

  void _showSnackbar(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color bgColor,
  }) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: bgColor,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white70,
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
  }
}
