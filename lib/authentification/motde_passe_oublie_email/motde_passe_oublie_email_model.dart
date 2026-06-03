import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'motde_passe_oublie_email_widget.dart' show MotdePasseOublieEmailWidget;
import 'package:flutter/material.dart';

class MotdePasseOublieEmailModel
    extends FlutterFlowModel<MotdePasseOublieEmailWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();
  }
}
