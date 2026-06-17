import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/utils/validators.dart';
import '/index.dart';
import 'ajouter_depense_page_widget.dart' show AjouterDepensePageWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AjouterDepensePageModel
    extends FlutterFlowModel<AjouterDepensePageWidget> {
  ///  Local state fields for this page.

  bool justifcharge = true;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for exploitationdepense widget.
  String? exploitationdepenseValue;
  FormFieldController<String>? exploitationdepenseValueController;
  // State field(s) for parcelledepense widget.
  String? parcelledepenseValue;
  FormFieldController<String>? parcelledepenseValueController;
  // State field(s) for activitedepense widget.
  String? activitedepenseValue;
  FormFieldController<String>? activitedepenseValueController;
  // State field(s) for Categoriedepense widget.
  String? categoriedepenseValue;
  FormFieldController<String>? categoriedepenseValueController;
  // State field(s) for Montantdepense widget.
  FocusNode? montantdepenseFocusNode;
  TextEditingController? montantdepenseTextController;
  String? Function(BuildContext, String?)?
      montantdepenseTextControllerValidator;
  // State field(s) for Beneficiaire widget.
  FocusNode? beneficiaireFocusNode;
  TextEditingController? beneficiaireTextController;
  String? Function(BuildContext, String?)? beneficiaireTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for Date widget.
  FocusNode? dateFocusNode;
  TextEditingController? dateTextController;
  late MaskTextInputFormatter dateMask;
  String? Function(BuildContext, String?)? dateTextControllerValidator;
  // State field(s) for libelleDepense widget.
  FocusNode? libelleDepenseFocusNode;
  TextEditingController? libelleDepenseTextController;
  String? Function(BuildContext, String?)?
      libelleDepenseTextControllerValidator;
  // State field(s) for CommentaireDepense widget.
  FocusNode? commentaireDepenseFocusNode;
  TextEditingController? commentaireDepenseTextController;
  String? Function(BuildContext, String?)?
      commentaireDepenseTextControllerValidator;
  @override
  void initState(BuildContext context) {
    montantdepenseTextControllerValidator =
        V.compose([V.required('Le montant est obligatoire'), V.amount()]);
    libelleDepenseTextControllerValidator =
        V.compose([V.required('Le libellé est obligatoire'), V.minLength(3)]);
    beneficiaireTextControllerValidator =
        V.required('Le bénéficiaire est obligatoire');
    dateTextControllerValidator =
        V.compose([V.required('La date est obligatoire'), V.dateJJMMAAAA()]);
  }

  @override
  void dispose() {
    montantdepenseFocusNode?.dispose();
    montantdepenseTextController?.dispose();

    beneficiaireFocusNode?.dispose();
    beneficiaireTextController?.dispose();

    dateFocusNode?.dispose();
    dateTextController?.dispose();

    libelleDepenseFocusNode?.dispose();
    libelleDepenseTextController?.dispose();

    commentaireDepenseFocusNode?.dispose();
    commentaireDepenseTextController?.dispose();
  }
}
