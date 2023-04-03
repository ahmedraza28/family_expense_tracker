import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Routers
import 'src/config/logging/provider_logger.dart';
import 'src/config/routing/routing.dart';

// Helpers
import 'src/helpers/constants/constants.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const showDebugBanner = false;
    final navigatorObservers = <NavigatorObserver>[SentryNavigatorObserver()];
    return ProviderScope(
      observers: const [
        ProviderLogger(),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        navigatorObservers: navigatorObservers,
        debugShowCheckedModeBanner: showDebugBanner,
        color: AppColors.primaryColor,
        theme: AppThemes.mainTheme,
        initialRoute: Routes.initialRoute,
        onGenerateRoute: AppRouter.generateRoute,
        navigatorKey: AppRouter.navigatorKey,
      ),
    );
  }
}
