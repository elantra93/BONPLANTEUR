import '/components/selecteur_exploitation_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'dashboard_page_widget.dart' show DashboardPageWidget;
import 'package:flutter/material.dart';

class DashboardPageModel extends FlutterFlowModel<DashboardPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for SelecteurExploitation component.
  late SelecteurExploitationModel selecteurExploitationModel;

  @override
  void initState(BuildContext context) {
    selecteurExploitationModel =
        createModel(context, () => SelecteurExploitationModel());
  }

  @override
  void dispose() {
    selecteurExploitationModel.dispose();
  }
}
