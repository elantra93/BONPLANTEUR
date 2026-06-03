import '/flutter_flow/flutter_flow_util.dart';
import 'detail_activite_page_widget.dart' show DetailActivitePageWidget;
import 'package:flutter/material.dart';

class DetailActivitePageModel
    extends FlutterFlowModel<DetailActivitePageWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading_preuvesActivite = false;
  FFUploadedFile uploadedLocalFile_preuvesActivite =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_preuvesActivite = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
