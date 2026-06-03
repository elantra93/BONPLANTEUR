import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'ajouter_consommation_stock_page_widget.dart'
    show AjouterConsommationStockPageWidget;
import 'package:flutter/material.dart';

class AjouterConsommationStockPageModel
    extends FlutterFlowModel<AjouterConsommationStockPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for parcelles widget.
  List<String>? parcellesValue1;
  FormFieldController<List<String>>? parcellesValueController1;
  // State field(s) for parcelles widget.
  List<String>? parcellesValue2;
  FormFieldController<List<String>>? parcellesValueController2;
  // State field(s) for produit widget.
  List<String>? produitValue;
  FormFieldController<List<String>>? produitValueController;
  // State field(s) for quantite widget.
  FocusNode? quantiteFocusNode;
  TextEditingController? quantiteTextController;
  String? Function(BuildContext, String?)? quantiteTextControllerValidator;
  // State field(s) for consommateur widget.
  String? consommateurValue;
  FormFieldController<String>? consommateurValueController;
  // State field(s) for activite widget.
  String? activiteValue;
  FormFieldController<String>? activiteValueController;
  // State field(s) for Calendar widget.
  DateTimeRange? calendarSelectedDay;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  @override
  void initState(BuildContext context) {
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
  }

  @override
  void dispose() {
    quantiteFocusNode?.dispose();
    quantiteTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController2?.dispose();
  }
}
