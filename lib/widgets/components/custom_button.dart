import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';

enum DemeterButtonVariant { primary, secondary, outlined, danger, ghost }

class DemeterButton extends StatelessWidget {
  const DemeterButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = DemeterButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.fullWidth = false,
    this.small = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final DemeterButtonVariant variant;
  final IconData? icon;
  final bool loading;
  final bool fullWidth;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final vPad = small ? 10.0 : 14.0;
    final hPad = small ? 14.0 : 20.0;
    final fontSize = small ? 13.0 : 15.0;

    Color bgColor;
    Color fgColor;
    BorderSide borderSide;
    double elevation;

    switch (variant) {
      case DemeterButtonVariant.primary:
        bgColor = theme.primary;
        fgColor = Colors.white;
        borderSide = BorderSide.none;
        elevation = 1;
      case DemeterButtonVariant.secondary:
        bgColor = theme.secondary;
        fgColor = theme.primaryText;
        borderSide = BorderSide.none;
        elevation = 1;
      case DemeterButtonVariant.outlined:
        bgColor = Colors.transparent;
        fgColor = theme.primary;
        borderSide = BorderSide(color: theme.primary, width: 1.5);
        elevation = 0;
      case DemeterButtonVariant.danger:
        bgColor = theme.error;
        fgColor = Colors.white;
        borderSide = BorderSide.none;
        elevation = 1;
      case DemeterButtonVariant.ghost:
        bgColor = Colors.transparent;
        fgColor = theme.secondaryText;
        borderSide = BorderSide(color: theme.alternate, width: 1.5);
        elevation = 0;
    }

    Widget label = loading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: fgColor,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: small ? 16 : 18, color: fgColor),
                const SizedBox(width: 6),
              ],
              Text(
                text,
                style: GoogleFonts.inter(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                ),
              ),
            ],
          );

    final btn = ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        disabledBackgroundColor: bgColor.withOpacity(0.5),
        disabledForegroundColor: fgColor.withOpacity(0.5),
        shadowColor: Colors.transparent,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              FlutterFlowTheme.of(context).designToken.radius.md),
          side: borderSide,
        ),
        padding:
            EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      ),
      child: label,
    );

    return fullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}
