import '/backend/backend.dart';
import '/components/date_picker_texfield_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/utils/validators.dart';
import '/index.dart';
import 'ajouter_activite_page_widget.dart' show AjouterActivitePageWidget;
import 'package:flutter/material.dart';

class AjouterActivitePageModel
    extends FlutterFlowModel<AjouterActivitePageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  List<ParcellesRecord>? dropDownPreviousSnapshot;
  // State field(s) for Libelle_activite widget.
  FocusNode? libelleActiviteFocusNode;
  TextEditingController? libelleActiviteTextController;
  String? Function(BuildContext, String?)?
      libelleActiviteTextControllerValidator;
  // State field(s) for consignes widget.
  FocusNode? consignesFocusNode;
  TextEditingController? consignesTextController;
  String? Function(BuildContext, String?)? consignesTextControllerValidator;
  // State field(s) for categorie widget.
  String? categorieValue;
  FormFieldController<String>? categorieValueController;
  // Model for DatePickerTexfield component.
  late DatePickerTexfieldModel datePickerTexfieldModel;
  // State field(s) for affectation widget.
  String? affectationValue;
  FormFieldController<String>? affectationValueController;

  @override
  void initState(BuildContext context) {
    datePickerTexfieldModel =
        createModel(context, () => DatePickerTexfieldModel());
    libelleActiviteTextControllerValidator = V.compose([
      V.required('Le libellé de l\'activité est obligatoire'),
      V.minLength(3),
    ]);
  }

  @override
  void dispose() {
    libelleActiviteFocusNode?.dispose();
    libelleActiviteTextController?.dispose();

    consignesFocusNode?.dispose();
    consignesTextController?.dispose();

    datePickerTexfieldModel.dispose();
  }
}
