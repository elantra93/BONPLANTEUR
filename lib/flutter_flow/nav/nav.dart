import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';

import '/auth/base_auth_user_provider.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? NavBarPage() : CreateAccount1Widget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          requireAuth: false,
          builder: (context, _) =>
              appStateNotifier.loggedIn ? NavBarPage() : CreateAccount1Widget(),
        ),
        FFRoute(
          name: LoginPhonePageWidget.routeName,
          path: LoginPhonePageWidget.routePath,
          requireAuth: false,
          builder: (context, params) => LoginPhonePageWidget(),
        ),
        FFRoute(
          name: OTPVerificationPageWidget.routeName,
          path: OTPVerificationPageWidget.routePath,
          requireAuth: false,
          builder: (context, params) => OTPVerificationPageWidget(
            phonenumber: params.getParam(
              'phonenumber',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: DashboardPageWidget.routeName,
          path: DashboardPageWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'DashboardPage')
              : DashboardPageWidget(),
        ),
        FFRoute(
          name: MesExploitationsWidget.routeName,
          path: MesExploitationsWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'MesExploitations')
              : MesExploitationsWidget(),
        ),
        FFRoute(
          name: AjouterActivitePageWidget.routeName,
          path: AjouterActivitePageWidget.routePath,
          builder: (context, params) => AjouterActivitePageWidget(),
        ),
        FFRoute(
          name: ListeActivitesPageWidget.routeName,
          path: ListeActivitesPageWidget.routePath,
          builder: (context, params) => ListeActivitesPageWidget(),
        ),
        FFRoute(
          name: StocksPageWidget.routeName,
          path: StocksPageWidget.routePath,
          builder: (context, params) => StocksPageWidget(
            exploitationid: params.getParam(
              'exploitationid',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['exploitations'],
            ),
          ),
        ),
        FFRoute(
          name: AjouterConsommationStockPageWidget.routeName,
          path: AjouterConsommationStockPageWidget.routePath,
          builder: (context, params) => AjouterConsommationStockPageWidget(
            exploitationid: params.getParam(
              'exploitationid',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['exploitations'],
            ),
          ),
        ),
        FFRoute(
          name: RecoltesPageWidget.routeName,
          path: RecoltesPageWidget.routePath,
          builder: (context, params) => RecoltesPageWidget(
            exploitationId: params.getParam(
              'exploitationId',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['exploitations'],
            ),
            parcelleid: params.getParam(
              'parcelleid',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['Parcelles'],
            ),
          ),
        ),
        FFRoute(
          name: ProfilPageWidget.routeName,
          path: ProfilPageWidget.routePath,
          builder: (context, params) => ProfilPageWidget(),
        ),
        FFRoute(
          name: NotificationsPageWidget.routeName,
          path: NotificationsPageWidget.routePath,
          builder: (context, params) => NotificationsPageWidget(),
        ),
        FFRoute(
          name: AjouterDepensePageWidget.routeName,
          path: AjouterDepensePageWidget.routePath,
          builder: (context, params) => AjouterDepensePageWidget(),
        ),
        FFRoute(
          name: ListeDepensesWidget.routeName,
          path: ListeDepensesWidget.routePath,
          builder: (context, params) => ListeDepensesWidget(),
        ),
        FFRoute(
          name: DetailActivitePageWidget.routeName,
          path: DetailActivitePageWidget.routePath,
          builder: (context, params) => DetailActivitePageWidget(
            activiteref: params.getParam(
              'activiteref',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['activites'],
            ),
          ),
        ),
        FFRoute(
          name: DetailParcellePageWidget.routeName,
          path: DetailParcellePageWidget.routePath,
          builder: (context, params) => DetailParcellePageWidget(
            exploitationid: params.getParam(
              'exploitationid',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['exploitations'],
            ),
            parcelleid: params.getParam(
              'parcelleid',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['Parcelles'],
            ),
          ),
        ),
        FFRoute(
          name: ListeParcellesWidget.routeName,
          path: ListeParcellesWidget.routePath,
          builder: (context, params) => ListeParcellesWidget(
            exploitationid: params.getParam(
              'exploitationid',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['exploitations'],
            ),
          ),
        ),
        FFRoute(
          name: Login1Widget.routeName,
          path: Login1Widget.routePath,
          requireAuth: false,
          builder: (context, params) => Login1Widget(),
        ),
        FFRoute(
          name: CreateAccount1Widget.routeName,
          path: CreateAccount1Widget.routePath,
          requireAuth: false,
          builder: (context, params) => CreateAccount1Widget(),
        ),
        FFRoute(
          name: AjouterExploitationPageWidget.routeName,
          path: AjouterExploitationPageWidget.routePath,
          builder: (context, params) => AjouterExploitationPageWidget(),
        ),
        FFRoute(
          name: AjouterParcellePageWidget.routeName,
          path: AjouterParcellePageWidget.routePath,
          builder: (context, params) => AjouterParcellePageWidget(
            exploitationId: params.getParam(
              'exploitationId',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['exploitations'],
            ),
          ),
        ),
        FFRoute(
          name: DetailExploitationPageWidget.routeName,
          path: DetailExploitationPageWidget.routePath,
          builder: (context, params) => DetailExploitationPageWidget(
            exploitationid: params.getParam(
              'exploitationid',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['exploitations'],
            ),
          ),
        ),
        FFRoute(
          name: ListeTeamWidget.routeName,
          path: ListeTeamWidget.routePath,
          builder: (context, params) => ListeTeamWidget(
            exploitationid: params.getParam(
              'exploitationid',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['exploitations'],
            ),
          ),
        ),
        FFRoute(
          name: AjouterCollaborateurPageWidget.routeName,
          path: AjouterCollaborateurPageWidget.routePath,
          builder: (context, params) => AjouterCollaborateurPageWidget(
            exploitationid: params.getParam(
              'exploitationid',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['exploitations'],
            ),
          ),
        ),
        FFRoute(
          name: TresorWidget.routeName,
          path: TresorWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'Tresor')
              : TresorWidget(),
        ),
        FFRoute(
          name: ModifierExploitationWidget.routeName,
          path: ModifierExploitationWidget.routePath,
          builder: (context, params) => ModifierExploitationWidget(
            exploitationid: params.getParam(
              'exploitationid',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['exploitations'],
            ),
          ),
        ),
        FFRoute(
          name: MotdePasseOublieEmailWidget.routeName,
          path: MotdePasseOublieEmailWidget.routePath,
          requireAuth: false,
          builder: (context, params) => MotdePasseOublieEmailWidget(),
        ),
        FFRoute(
          name: ModifierParcelleWidget.routeName,
          path: ModifierParcelleWidget.routePath,
          builder: (context, params) => ModifierParcelleWidget(
            exploitationId: params.getParam(
              'exploitationId',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['exploitations'],
            ),
            parcelleID: params.getParam(
              'parcelleID',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['Parcelles'],
            ),
          ),
        ),
        FFRoute(
          name: DetailsDepenseWidget.routeName,
          path: DetailsDepenseWidget.routePath,
          asyncParams: {
            'depenseid': getDoc(['depenses'], DepensesRecord.fromSnapshot),
          },
          builder: (context, params) => DetailsDepenseWidget(
            depenseid: params.getParam(
              'depenseid',
              ParamType.Document,
            ),
          ),
        ),
        FFRoute(
          name: ListeMaterielWidget.routeName,
          path: ListeMaterielWidget.routePath,
          builder: (context, params) => ListeMaterielWidget(),
        ),
        FFRoute(
          name: DetailMaterielWidget.routeName,
          path: DetailMaterielWidget.routePath,
          builder: (context, params) => DetailMaterielWidget(
            referenceMateriel: params.getParam(
              'referenceMateriel',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['Materiels'],
            ),
          ),
        ),
        FFRoute(
          name: AjouterMaterielWidget.routeName,
          path: AjouterMaterielWidget.routePath,
          builder: (context, params) => AjouterMaterielWidget(),
        ),
        FFRoute(
          name: ModifierMaterielWidget.routeName,
          path: ModifierMaterielWidget.routePath,
          builder: (context, params) => ModifierMaterielWidget(
            materielid: params.getParam(
              'materielid',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['Materiels'],
            ),
          ),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = true,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/createAccount1';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: SpinKitFadingCube(
                      color: FlutterFlowTheme.of(context).tertiary,
                      size: 50.0,
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
