import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class DemeterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DemeterAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
    this.backgroundColor,
    this.onBack,
    this.bottom,
    this.subtitle,
    this.centerTitle = false,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final VoidCallback? onBack;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final bg = backgroundColor ?? theme.primary;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return AppBar(
      backgroundColor: bg,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              color: Colors.white,
              onPressed: onBack ??
                  () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
            )
          : null,
      title: subtitle != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.interTight(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(
                  subtitle!,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            )
          : Text(
              title,
              style: GoogleFonts.interTight(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
      actions: actions != null
          ? [
              ...actions!,
              const SizedBox(width: 4),
            ]
          : null,
      bottom: bottom,
    );
  }
}

// Sliver version for scrollable screens
class DemeterSliverAppBar extends StatelessWidget {
  const DemeterSliverAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
    this.onBack,
    this.expandedHeight = 160,
    this.flexibleContent,
  });

  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final double expandedHeight;
  final Widget? flexibleContent;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return SliverAppBar(
      backgroundColor: theme.primary,
      foregroundColor: Colors.white,
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              color: Colors.white,
              onPressed: onBack ??
                  () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
            )
          : null,
      title: Text(
        title,
        style: GoogleFonts.interTight(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      actions: actions,
      flexibleSpace: flexibleContent != null
          ? FlexibleSpaceBar(
              background: flexibleContent,
            )
          : null,
    );
  }
}
