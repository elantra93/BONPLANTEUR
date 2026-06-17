import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';

enum DemeterStatus {
  planifie,
  enCours,
  realise,
  valide,
  rejete,
  saisie,
  termine,
  inconnu,
}

extension DemeterStatusParsing on DemeterStatus {
  static DemeterStatus fromString(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'planifiée':
      case 'planifié':
      case 'planifie':
      case 'planifiee':
        return DemeterStatus.planifie;
      case 'en_cours':
      case 'en cours':
        return DemeterStatus.enCours;
      case 'réalisé':
      case 'réalisée':
      case 'realise':
      case 'réalisee':
        return DemeterStatus.realise;
      case 'validé':
      case 'validée':
      case 'valide':
      case 'validee':
        return DemeterStatus.valide;
      case 'rejeté':
      case 'rejetée':
      case 'rejete':
      case 'rejetee':
        return DemeterStatus.rejete;
      case 'saisie':
      case 'saisie':
        return DemeterStatus.saisie;
      case 'terminé':
      case 'terminée':
      case 'termine':
      case 'terminee':
        return DemeterStatus.termine;
      default:
        return DemeterStatus.inconnu;
    }
  }

  String get label {
    switch (this) {
      case DemeterStatus.planifie:
        return 'Planifiée';
      case DemeterStatus.enCours:
        return 'En cours';
      case DemeterStatus.realise:
        return 'Réalisée';
      case DemeterStatus.valide:
        return 'Validée';
      case DemeterStatus.rejete:
        return 'Rejetée';
      case DemeterStatus.saisie:
        return 'Saisie';
      case DemeterStatus.termine:
        return 'Terminée';
      case DemeterStatus.inconnu:
        return 'Inconnu';
    }
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.customLabel,
    this.small = false,
  });

  // Convenience constructor from raw string
  factory StatusBadge.fromString(String? value, {bool small = false}) {
    return StatusBadge(
      status: DemeterStatusParsing.fromString(value),
      customLabel: value,
      small: small,
    );
  }

  final DemeterStatus status;
  final String? customLabel;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final color = _colorFor(theme);
    final label = customLabel ?? status.label;
    final fontSize = small ? 10.0 : 11.0;
    final hPad = small ? 7.0 : 10.0;
    final vPad = small ? 2.0 : 4.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFor(FlutterFlowTheme theme) {
    switch (status) {
      case DemeterStatus.planifie:
        return theme.tertiary;
      case DemeterStatus.enCours:
        return theme.info;
      case DemeterStatus.realise:
        return theme.secondary;
      case DemeterStatus.valide:
        return theme.success;
      case DemeterStatus.rejete:
        return theme.error;
      case DemeterStatus.saisie:
        return theme.info;
      case DemeterStatus.termine:
        return theme.success;
      case DemeterStatus.inconnu:
        return theme.secondaryText;
    }
  }
}
