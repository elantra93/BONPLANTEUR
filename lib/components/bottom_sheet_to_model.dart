import '/components/button3_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'bottom_sheet_to_widget.dart' show BottomSheetToWidget;
import 'package:flutter/material.dart';

class BottomSheetToModel extends FlutterFlowModel<BottomSheetToWidget> {
  ///  Local state fields for this component.

  DocumentReference? selectedExploitationRef;

  ///  State fields for stateful widgets in this component.

  // Model for Button.
  late Button3Model buttonModel;

  @override
  void initState(BuildContext context) {
    buttonModel = createModel(context, () => Button3Model());
  }

  @override
  void dispose() {
    buttonModel.dispose();
  }
}
