import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'ajouter_materiel_widget.dart' show AjouterMaterielWidget;
import 'package:flutter/material.dart';

class AjouterMaterielModel extends FlutterFlowModel<AjouterMaterielWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for Quantitee widget.
  FocusNode? quantiteeFocusNode;
  TextEditingController? quantiteeTextController;
  String? Function(BuildContext, String?)? quantiteeTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  DateTime? datePicked;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  // State field(s) for Switch widget.
  bool? switchValue;
  bool isDataUploading_photoMateriel = false;
  List<FFUploadedFile> uploadedLocalFiles_photoMateriel = [];
  List<String> uploadedFileUrls_photoMateriel = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    quantiteeFocusNode?.dispose();
    quantiteeTextController?.dispose();

    textFieldFocusNode2?.dispose();
    textController3?.dispose();

    textFieldFocusNode3?.dispose();
    textController4?.dispose();
  }
}
