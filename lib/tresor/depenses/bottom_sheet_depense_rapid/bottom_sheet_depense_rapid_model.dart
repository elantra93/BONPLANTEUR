import '/components/text_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'bottom_sheet_depense_rapid_widget.dart'
    show BottomSheetDepenseRapidWidget;
import 'package:flutter/material.dart';

class BottomSheetDepenseRapidModel
    extends FlutterFlowModel<BottomSheetDepenseRapidWidget> {
  ///  Local state fields for this component.

  String? selectedCategorie;

  ///  State fields for stateful widgets in this component.

  // Model for Montant.
  late TextFieldModel montantModel;
  // State field(s) for DropdownCollaborateur widget.
  String? dropdownCollaborateurValue;
  FormFieldController<String>? dropdownCollaborateurValueController;
  // Model for NoteRapide.
  late TextFieldModel noteRapideModel;
  // State field(s) for DropDownActivite widget.
  List<String>? dropDownActiviteValue;
  FormFieldController<List<String>>? dropDownActiviteValueController;
  @override
  void initState(BuildContext context) {
    montantModel = createModel(context, () => TextFieldModel());
    noteRapideModel = createModel(context, () => TextFieldModel());
  }

  @override
  void dispose() {
    montantModel.dispose();
    noteRapideModel.dispose();
  }
}
