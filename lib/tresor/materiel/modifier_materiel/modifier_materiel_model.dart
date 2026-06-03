import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'modifier_materiel_widget.dart' show ModifierMaterielWidget;
import 'package:flutter/material.dart';

class ModifierMaterielModel extends FlutterFlowModel<ModifierMaterielWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for NomMateriel widget.
  FocusNode? nomMaterielFocusNode;
  TextEditingController? nomMaterielTextController;
  String? Function(BuildContext, String?)? nomMaterielTextControllerValidator;
  // State field(s) for Exploitation widget.
  String? exploitationValue;
  FormFieldController<String>? exploitationValueController;
  // State field(s) for TypeMateriel widget.
  String? typeMaterielValue;
  FormFieldController<String>? typeMaterielValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomMaterielFocusNode?.dispose();
    nomMaterielTextController?.dispose();
  }
}
