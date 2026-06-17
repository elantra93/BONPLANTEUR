import 'package:flutter/material.dart';

/// Signature standard des validateurs DEMETER (compatible FlutterFlow asValidator).
typedef DValidator = String? Function(BuildContext context, String? value);

/// Bibliothèque de validateurs réutilisables.
abstract class V {
  // ── Primitifs ──────────────────────────────────────────────────────────────

  /// Champ obligatoire — rejette null, vide ou espaces.
  static DValidator required([String? message]) => (ctx, val) {
        if (val == null || val.trim().isEmpty) {
          return message ?? 'Ce champ est obligatoire';
        }
        return null;
      };

  /// Longueur minimale.
  static DValidator minLength(int min, [String? message]) => (ctx, val) {
        if (val != null && val.trim().length < min) {
          return message ?? 'Minimum $min caractères requis';
        }
        return null;
      };

  /// Longueur maximale.
  static DValidator maxLength(int max, [String? message]) => (ctx, val) {
        if (val != null && val.trim().length > max) {
          return message ?? 'Maximum $max caractères autorisés';
        }
        return null;
      };

  // ── Numériques ─────────────────────────────────────────────────────────────

  /// Nombre décimal (positif ou nul).
  static DValidator positiveNumber([String? message]) => (ctx, val) {
        if (val == null || val.trim().isEmpty) return null;
        final n = double.tryParse(val.replaceAll(',', '.'));
        if (n == null) return message ?? 'Veuillez entrer un nombre valide';
        if (n < 0) return message ?? 'La valeur doit être positive';
        return null;
      };

  /// Nombre décimal strictement positif (> 0).
  static DValidator positiveNumberRequired([String? message]) => (ctx, val) {
        if (val == null || val.trim().isEmpty) {
          return message ?? 'Ce champ est obligatoire';
        }
        final n = double.tryParse(val.replaceAll(',', '.'));
        if (n == null) return message ?? 'Veuillez entrer un nombre valide';
        if (n <= 0) return message ?? 'La valeur doit être supérieure à 0';
        return null;
      };

  /// Entier positif ou nul.
  static DValidator positiveInteger([String? message]) => (ctx, val) {
        if (val == null || val.trim().isEmpty) return null;
        final n = int.tryParse(val.trim());
        if (n == null) return message ?? 'Veuillez entrer un entier valide';
        if (n < 0) return message ?? 'La valeur doit être positive';
        return null;
      };

  /// Montant financier (> 0, jusqu'à 2 décimales).
  static DValidator amount([String? message]) => (ctx, val) {
        if (val == null || val.trim().isEmpty) {
          return message ?? 'Le montant est obligatoire';
        }
        final n = double.tryParse(val.replaceAll(',', '.'));
        if (n == null) return message ?? 'Montant invalide (ex: 5000 ou 5000.50)';
        if (n <= 0) return message ?? 'Le montant doit être supérieur à 0';
        return null;
      };

  // ── Contact ────────────────────────────────────────────────────────────────

  /// Numéro de téléphone africain (8–15 chiffres, + optionnel).
  static DValidator phone([String? message]) => (ctx, val) {
        if (val == null || val.trim().isEmpty) return null;
        final cleaned = val.replaceAll(RegExp(r'[\s\-()]'), '');
        final re = RegExp(r'^\+?[0-9]{8,15}$');
        if (!re.hasMatch(cleaned)) {
          return message ?? 'Numéro de téléphone invalide';
        }
        return null;
      };

  /// Adresse e-mail (vérification basique).
  static DValidator email([String? message]) => (ctx, val) {
        if (val == null || val.trim().isEmpty) return null;
        final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
        if (!re.hasMatch(val.trim())) {
          return message ?? 'Adresse e-mail invalide';
        }
        return null;
      };

  // ── Dates ──────────────────────────────────────────────────────────────────

  /// Format JJ/MM/AAAA.
  static DValidator dateJJMMAAAA([String? message]) => (ctx, val) {
        if (val == null || val.trim().isEmpty) return null;
        final re = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$');
        final match = re.firstMatch(val.trim());
        if (match == null) {
          return message ?? 'Format attendu : JJ/MM/AAAA';
        }
        final day = int.parse(match.group(1)!);
        final month = int.parse(match.group(2)!);
        final year = int.parse(match.group(3)!);
        if (month < 1 || month > 12) return 'Mois invalide';
        if (day < 1 || day > 31) return 'Jour invalide';
        if (year < 2000 || year > 2100) return 'Année invalide';
        return null;
      };

  // ── Superficie / Surface ───────────────────────────────────────────────────

  /// Surface en hectares (> 0).
  static DValidator superficie([String? message]) => (ctx, val) {
        if (val == null || val.trim().isEmpty) return null;
        final n = double.tryParse(val.replaceAll(',', '.'));
        if (n == null) return message ?? 'Superficie invalide';
        if (n <= 0) return message ?? 'La superficie doit être > 0 ha';
        if (n > 1000000) return 'Superficie trop grande';
        return null;
      };

  // ── Composition ───────────────────────────────────────────────────────────

  /// Combine plusieurs validateurs en séquence (retourne la première erreur).
  static DValidator compose(List<DValidator> validators) => (ctx, val) {
        for (final v in validators) {
          final err = v(ctx, val);
          if (err != null) return err;
        }
        return null;
      };
}
