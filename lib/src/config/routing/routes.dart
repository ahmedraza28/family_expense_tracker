// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

// Features
import '../../features/auth/auth.dart';

// Helpers
import '../../helpers/typedefs.dart';

/// A utility class that holds screen names for named navigation.
/// This class has no constructor and all variables are `static`.
@immutable
class Routes {
  const Routes._();

  /// The route to be loaded when app launches
  static const String initialRoute = AuthWidgetBuilderRoute;

  /// The route to be loaded in case of unrecognized route name
  static const String fallbackRoute = NotFoundScreenRoute;

  // The name for the auth widget screen
  static const String AuthWidgetBuilderRoute = '/auth-widget-builder';

  /// The name of the route for home dashboard screen
  static const String HomeScreenRoute = '/home-screen';

  /// The name of the route for unrecognized route screen
  static const String NotFoundScreenRoute = '/route-not-found-screen';

  /// The name of the route for login screen.
  static const String LoginScreenRoute = '/login-screen';

  /// The name of the route for qr scanner screen.
  static const String QrScannerScreenRoute = '/qr-scanner-screen';

  /// The name of the route for register screen.
  static const String RegisterScreenRoute = '/register-screen';

  /// The name of the route for forgot password screen.
  static const String ForgotPasswordScreenRoute = '/forgot-password-screen';

  /// The name of the route for change password screen.
  static const String ChangePasswordScreenRoute = '/change-password-screen';

  static final Map<String, RouteBuilder> _routesMap = {
    LoginScreenRoute: (_) => const LoginScreen(),
    AuthWidgetBuilderRoute: (_) => const AuthWidgetBuilder(),
    NotFoundScreenRoute: (_) => const SizedBox.shrink(),
    ForgotPasswordScreenRoute: (_) => const SizedBox.shrink(),
    ChangePasswordScreenRoute: (_) => const SizedBox.shrink(),
  };

  static RouteBuilder getRoute(String? routeName) {
    return routeExists(routeName)
        ? _routesMap[routeName]!
        : _routesMap[Routes.NotFoundScreenRoute]!;
  }

  static bool routeExists(String? routeName) {
    return _routesMap.containsKey(routeName);
  }
}
