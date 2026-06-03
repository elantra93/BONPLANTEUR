import 'package:flutter/material.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _CurrentExploitationId =
          prefs.getString('ff_CurrentExploitationId')?.ref ??
              _CurrentExploitationId;
    });
    _safeInit(() {
      _ParcelleId = prefs.getString('ff_ParcelleId')?.ref ?? _ParcelleId;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  DocumentReference? _CurrentExploitationId =
      FirebaseFirestore.instance.doc('/exploitations/x');
  DocumentReference? get CurrentExploitationId => _CurrentExploitationId;
  set CurrentExploitationId(DocumentReference? value) {
    _CurrentExploitationId = value;
    value != null
        ? prefs.setString('ff_CurrentExploitationId', value.path)
        : prefs.remove('ff_CurrentExploitationId');
  }

  DocumentReference? _ParcelleId =
      FirebaseFirestore.instance.doc('/Parcelles/x');
  DocumentReference? get ParcelleId => _ParcelleId;
  set ParcelleId(DocumentReference? value) {
    _ParcelleId = value;
    value != null
        ? prefs.setString('ff_ParcelleId', value.path)
        : prefs.remove('ff_ParcelleId');
  }

  bool _searchactive = false;
  bool get searchactive => _searchactive;
  set searchactive(bool value) {
    _searchactive = value;
  }

  final _listeDesExploitationsManager =
      StreamRequestManager<List<ExploitationsRecord>>();
  Stream<List<ExploitationsRecord>> listeDesExploitations({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<ExploitationsRecord>> Function() requestFn,
  }) =>
      _listeDesExploitationsManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearListeDesExploitationsCache() =>
      _listeDesExploitationsManager.clear();
  void clearListeDesExploitationsCacheKey(String? uniqueKey) =>
      _listeDesExploitationsManager.clearRequest(uniqueKey);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
