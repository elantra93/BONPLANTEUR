import '/flutter_flow/flutter_flow_util.dart';
import 'ajouter_collaborateur_page_widget.dart'
    show AjouterCollaborateurPageWidget;
import 'package:flutter/material.dart';

class AjouterCollaborateurPageModel
    extends FlutterFlowModel<AjouterCollaborateurPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Nom widget.
  FocusNode? nomFocusNode;
  TextEditingController? nomTextController;
  String? Function(BuildContext, String?)? nomTextControllerValidator;
  // State field(s) for prenoms widget.
  FocusNode? prenomsFocusNode;
  TextEditingController? prenomsTextController;
  String? Function(BuildContext, String?)? prenomsTextControllerValidator;
  // State field(s) for surnom widget.
  FocusNode? surnomFocusNode;
  TextEditingController? surnomTextController;
  String? Function(BuildContext, String?)? surnomTextControllerValidator;
  DateTime? datePicked1;
  // State field(s) for salaire widget.
  FocusNode? salaireFocusNode;
  TextEditingController? salaireTextController;
  String? Function(BuildContext, String?)? salaireTextControllerValidator;
  // State field(s) for contact widget.
  FocusNode? contactFocusNode;
  TextEditingController? contactTextController;
  String? Function(BuildContext, String?)? contactTextControllerValidator;
  DateTime? datePicked2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nomFocusNode?.dispose();
    nomTextController?.dispose();

    prenomsFocusNode?.dispose();
    prenomsTextController?.dispose();

    surnomFocusNode?.dispose();
    surnomTextController?.dispose();

    salaireFocusNode?.dispose();
    salaireTextController?.dispose();

    contactFocusNode?.dispose();
    contactTextController?.dispose();
  }
}
