import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'modifier_parcelle_widget.dart' show ModifierParcelleWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ModifierParcelleModel extends FlutterFlowModel<ModifierParcelleWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for NomParcelle widget.
  FocusNode? nomParcelleFocusNode;
  TextEditingController? nomParcelleTextController;
  String? Function(BuildContext, String?)? nomParcelleTextControllerValidator;
  // State field(s) for Budget widget.
  FocusNode? budgetFocusNode;
  TextEditingController? budgetTextController;
  late MaskTextInputFormatter budgetMask;
  String? Function(BuildContext, String?)? budgetTextControllerValidator;
  // State field(s) for rendement widget.
  FocusNode? rendementFocusNode;
  TextEditingController? rendementTextController;
  String? Function(BuildContext, String?)? rendementTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomParcelleFocusNode?.dispose();
    nomParcelleTextController?.dispose();

    budgetFocusNode?.dispose();
    budgetTextController?.dispose();

    rendementFocusNode?.dispose();
    rendementTextController?.dispose();
  }
}
