import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'o_t_p_verification_page_widget.dart' show OTPVerificationPageWidget;
import 'package:flutter/material.dart';

class OTPVerificationPageModel
    extends FlutterFlowModel<OTPVerificationPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for OTPAuthform widget.
  FocusNode? oTPAuthformFocusNode;
  TextEditingController? oTPAuthformTextController;
  String? Function(BuildContext, String?)? oTPAuthformTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    oTPAuthformFocusNode?.dispose();
    oTPAuthformTextController?.dispose();
  }
}
