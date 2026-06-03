import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'login_phone_page_widget.dart' show LoginPhonePageWidget;
import 'package:flutter/material.dart';

class LoginPhonePageModel extends FlutterFlowModel<LoginPhonePageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PhoneNumberAuth widget.
  FocusNode? phoneNumberAuthFocusNode;
  TextEditingController? phoneNumberAuthTextController;
  String? Function(BuildContext, String?)?
      phoneNumberAuthTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    phoneNumberAuthFocusNode?.dispose();
    phoneNumberAuthTextController?.dispose();
  }
}
