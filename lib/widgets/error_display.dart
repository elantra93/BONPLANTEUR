import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Widget d'affichage d'erreur inline, à utiliser dans les formulaires
/// pour signaler un état d'erreur persistant (ex: échec de soumission).
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
    this.compact = false,
  });

  final String message;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    if (compact) {
      return Row(
        children: [
          Icon(Icons.error_outline, color: theme.error, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(color: theme.error, fontSize: 12),
            ),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.error.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: theme.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: GoogleFonts.inter(
                    color: theme.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: onRetry,
                    child: Text(
                      'Réessayer',
                      style: GoogleFonts.inter(
                        color: theme.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget d'état vide pour les listes sans données.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.actionLabel,
  });

  final String message;
  final IconData icon;
  final VoidCallback? action;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: theme.secondaryText.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: theme.secondaryText,
                fontSize: 14,
              ),
            ),
            if (action != null && actionLabel != null) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: action,
                style: TextButton.styleFrom(
                  foregroundColor: theme.primary,
                ),
                child: Text(
                  actionLabel!,
                  style: GoogleFonts.inter(
                    color: theme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget de chargement centré cohérent avec la charte DEMETER.
class DemeterLoader extends StatelessWidget {
  const DemeterLoader({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              color: theme.primary,
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: GoogleFonts.inter(
                color: theme.secondaryText,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
