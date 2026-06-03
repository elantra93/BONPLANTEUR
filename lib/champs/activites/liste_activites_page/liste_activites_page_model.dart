import '/components/selecteur_exploitation_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'liste_activites_page_widget.dart' show ListeActivitesPageWidget;
import 'package:flutter/material.dart';

class ListeActivitesPageModel
    extends FlutterFlowModel<ListeActivitesPageWidget> {
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
