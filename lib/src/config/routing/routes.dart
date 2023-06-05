// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

// Features
import '../../features/auth/auth.dart';
import '../../features/balance_adjustment/balance_adjustment.dart';
import '../../features/balance_transfer/balance_transfer.dart';
import '../../features/books/books.dart';
import '../../features/budgets/budgets.dart';
import '../../features/calculator/calculator.dart';
import '../../features/categories/categories.dart';
import '../../features/shared/shared.dart';
import '../../features/transactions/transactions.dart';
import '../../features/wallets/wallets.dart';

// Screens
import '../../global/screens/screens.dart';

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

  // The name for the app startup screen
  static const String BookConfigLoaderScreenRoute =
      '/book-config-loader-screen';

  // The name for the auth widget screen
  static const String AuthWidgetBuilderRoute = '/auth-widget-builder';

  /// The name of the route for balance transfer screen
  static const String AddEditBalanceTransferScreenRoute =
      '/add-edit-balance-transfer-screen';

  /// The name of the route for unrecognized route screen
  static const String NotFoundScreenRoute = '/route-not-found-screen';

  /// The name of the route for login screen.
  static const String LoginScreenRoute = '/login-screen';

  /// The name of the route for books screen.
  static const String BooksScreenRoute = '/books-screen';

  /// The name of the route for categories screen.
  static const String CategoriesScreenRoute = '/categories-screen';

  /// The name of the route for selectable categories screen.
  static const String SelectCategoriesScreenRoute = '/select-categories-screen';

  /// The name of the route for selectable budgets screen.
  static const String SelectBudgetsScreenRoute = '/select-budgets-screen';

  /// The name of the route for wallets screen.
  static const String WalletsScreenRoute = '/wallets-screen';

  /// The name of the route for add/edit wallet balance screen.
  static const String AddEditBalanceAdjustmentScreenRoute =
      '/add-edit-balance-adjustment-screen';

  /// The name of the route for calculator screen.
  static const String CalculatorScreenRoute = '/calculator-screen';

  /// The name of the route for transactions screen.
  static const String TransactionsScreenRoute = '/transactions-screen';

  /// The name of the route for budgets screen.
  static const String BudgetsScreenRoute = '/budgets-screen';

  /// The name of the route for budget screen
  static const String AddEditBudgetScreenRoute = '/add-edit-budget-screen';

  /// The name of the route for manage book access screen.
  static const String ManageBookAccessScreenRoute =
      '/manage-book-access-screen';

  /// The name of the route for about screen.
  static const String AboutScreenRoute = '/about-screen';

  /// The name of the route for insights screen.
  static const String InsightsScreenRoute = '/insights-screen';

  /// The name of the route for qr scanner screen.
  static const String QrScannerScreenRoute = '/qr-scanner-screen';

  static final Map<String, RouteBuilder> _routesMap = {
    LoginScreenRoute: (_) => const LoginScreen(),
    BookConfigLoaderScreenRoute: (_) => const BookConfigLoaderScreen(),
    AuthWidgetBuilderRoute: (_) => const AuthWidgetBuilder(),
    NotFoundScreenRoute: (_) => const NotFoundScreen(),
    BooksScreenRoute: (_) => const BooksScreen(),
    CategoriesScreenRoute: (_) => const CategoriesScreen(),
    SelectCategoriesScreenRoute: (_) => const SelectCategoriesScreen(),
    WalletsScreenRoute: (_) => const WalletsScreen(),
    CalculatorScreenRoute: (_) => const CalculatorScreen(),
    TransactionsScreenRoute: (_) => const TransactionsScreen(),
    AddEditBalanceTransferScreenRoute: (_) =>
        const AddEditBalanceTransferScreen(),
    BudgetsScreenRoute: (_) => const BudgetsScreen(),
    SelectBudgetsScreenRoute: (_) => const SelectBudgetsScreen(),
    AddEditBudgetScreenRoute: (_) => const AddEditBudgetScreen(),
    AddEditBalanceAdjustmentScreenRoute: (_) =>
        AddEditBalanceAdjustmentScreen(),
    // ManageBookAccessScreenRoute: (_) => const SizedBox.shrink(),
    // AboutScreenRoute: (_) => const SizedBox.shrink(),
    // InsightsScreenRoute: (_) => const SizedBox.shrink(),
    QrScannerScreenRoute: (_) => const QrScannerScreen(),
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
