import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/utils/validators.dart';
import 'ajouter_parcelle_page_widget.dart' show AjouterParcellePageWidget;
import 'package:flutter/material.dart';

class AjouterParcellePageModel
    extends FlutterFlowModel<AjouterParcellePageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Exploitation widget.
  FocusNode? exploitationFocusNode;
  TextEditingController? exploitationTextController;
  String? Function(BuildContext, String?)? exploitationTextControllerValidator;
  // State field(s) for NomParcelle widget.
  FocusNode? nomParcelleFocusNode;
  TextEditingController? nomParcelleTextController;
  String? Function(BuildContext, String?)? nomParcelleTextControllerValidator;
  // State field(s) for culture widget.
  String? cultureValue;
  FormFieldController<String>? cultureValueController;
  // State field(s) for surface widget.
  FocusNode? surfaceFocusNode;
  TextEditingController? surfaceTextController;
  String? Function(BuildContext, String?)? surfaceTextControllerValidator;
  // State field(s) for Switchhorssol widget.
  bool? switchhorssolValue;
  // State field(s) for SwitchSerre widget.
  bool? switchSerreValue;
  DateTime? datePicked;
  // State field(s) for Budget widget.
  FocusNode? budgetFocusNode;
  TextEditingController? budgetTextController;
  String? Function(BuildContext, String?)? budgetTextControllerValidator;
  // State field(s) for rendement widget.
  FocusNode? rendementFocusNode;
  TextEditingController? rendementTextController;
  String? Function(BuildContext, String?)? rendementTextControllerValidator;

  @override
  void initState(BuildContext context) {
    nomParcelleTextControllerValidator = V.compose([
      V.required('Le nom de la parcelle est obligatoire'),
      V.minLength(2),
    ]);
    surfaceTextControllerValidator = V.compose([
      V.required('La surface est obligatoire'),
      V.superficie(),
    ]);
    budgetTextControllerValidator = V.positiveNumber('Budget invalide');
    rendementTextControllerValidator =
        V.positiveNumber('Rendement attendu invalide');
  }

  @override
  void dispose() {
    exploitationFocusNode?.dispose();
    exploitationTextController?.dispose();

    nomParcelleFocusNode?.dispose();
    nomParcelleTextController?.dispose();

    surfaceFocusNode?.dispose();
    surfaceTextController?.dispose();

    budgetFocusNode?.dispose();
    budgetTextController?.dispose();

    rendementFocusNode?.dispose();
    rendementTextController?.dispose();
  }
}
