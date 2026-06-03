import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'statut_activite_code_couleur_model.dart';
export 'statut_activite_code_couleur_model.dart';

class StatutActiviteCodeCouleurWidget extends StatefulWidget {
  const StatutActiviteCodeCouleurWidget({
    super.key,
    this.parameter1,
    this.parameter2,
  });

  final String? parameter1;
  final String? parameter2;

  @override
  State<StatutActiviteCodeCouleurWidget> createState() =>
      _StatutActiviteCodeCouleurWidgetState();
}

class _StatutActiviteCodeCouleurWidgetState
    extends State<StatutActiviteCodeCouleurWidget> {
  late StatutActiviteCodeCouleurModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StatutActiviteCodeCouleurModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.0,
      decoration: BoxDecoration(
        color: valueOrDefault<Color>(
          () {
            if (widget.parameter2 == 'Planifié') {
              return FlutterFlowTheme.of(context).tertiary;
            } else if (widget.parameter2 == 'Réalisé') {
              return FlutterFlowTheme.of(context).secondary;
            } else if (widget.parameter2 == 'Validé') {
              return FlutterFlowTheme.of(context).success;
            } else {
              return FlutterFlowTheme.of(context).error;
            }
          }(),
          FlutterFlowTheme.of(context).warning,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
        child: Text(
          widget.parameter1!,
          style: FlutterFlowTheme.of(context).labelSmall.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).secondaryBackground,
                fontSize: 12.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
                fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
              ),
        ),
      ),
    );
  }
}
