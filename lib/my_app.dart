import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Routers
import 'src/config/routing/routing.dart';

// Helpers
import 'src/helpers/constants/constants.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Family Expense Tracker';
    const showDebugBanner = false;
    final navigatorObservers = <NavigatorObserver>[SentryNavigatorObserver()];
    final platformIsIOS = Platform.isIOS;
    final app = platformIsIOS
        ? Theme(
            data: AppThemes.mainTheme,
            child: CupertinoApp(
              title: title,
              navigatorObservers: navigatorObservers,
              debugShowCheckedModeBanner: showDebugBanner,
              initialRoute: Routes.initialRoute,
              color: AppColors.primaryColor,
              onGenerateRoute: AppRouter.generateRoute,
              navigatorKey: AppRouter.navigatorKey,
            ),
          )
        : MaterialApp(
            title: title,
            navigatorObservers: navigatorObservers,
            debugShowCheckedModeBanner: showDebugBanner,
            color: AppColors.primaryColor,
            theme: AppThemes.mainTheme,
            initialRoute: Routes.initialRoute,
            onGenerateRoute: AppRouter.generateRoute,
            navigatorKey: AppRouter.navigatorKey,
          );
    return ProviderScope(child: app);
  }
}
