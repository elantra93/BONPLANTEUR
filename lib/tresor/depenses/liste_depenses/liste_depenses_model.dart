import '/backend/backend.dart';
import '/components/selecteur_exploitation_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'liste_depenses_widget.dart' show ListeDepensesWidget;
import 'package:flutter/material.dart';

class ListeDepensesModel extends FlutterFlowModel<ListeDepensesWidget> {
  ///  Local state fields for this page.

  bool fullpageview = true;

  bool searchactive = true;

  ///  State fields for stateful widgets in this page.

  // Model for SelecteurExploitation component.
  late SelecteurExploitationModel selecteurExploitationModel;
  // State field(s) for TextField widget.
  final textFieldKey = GlobalKey();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? textFieldSelectedOption;
  String? Function(BuildContext, String?)? textControllerValidator;
  List<DepensesRecord> simpleSearchResults = [];

  @override
  void initState(BuildContext context) {
    selecteurExploitationModel =
        createModel(context, () => SelecteurExploitationModel());
  }

  @override
  void dispose() {
    selecteurExploitationModel.dispose();
    textFieldFocusNode?.dispose();
  }
}
