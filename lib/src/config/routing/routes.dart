// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

// Features
import '../../features/auth/auth.dart';
import '../../features/balance_transfer/balance_transfer.dart';
import '../../features/books/books.dart';
import '../../features/calculator/calculator.dart';
import '../../features/categories/categories.dart';
import '../../features/home/home.dart';
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
  static const String BookConfigLoaderScreenRoute = '/book-config-loader-screen';

  // The name for the auth widget screen
  static const String AuthWidgetBuilderRoute = '/auth-widget-builder';

  /// The name of the route for home dashboard screen
  static const String HomeScreenRoute = '/home-screen';

  /// The name of the route for unrecognized route screen
  static const String NotFoundScreenRoute = '/route-not-found-screen';

  /// The name of the route for login screen.
  static const String LoginScreenRoute = '/login-screen';

  /// The name of the route for books screen.
  static const String BooksScreenRoute = '/books-screen';

  /// The name of the route for add/edit book screen.
  static const String AddEditBookScreenRoute = '/add-edit-book-screen';

  /// The name of the route for categories screen.
  static const String CategoriesScreenRoute = '/categories-screen';

  /// The name of the route for add/edit category screen.
  static const String AddEditCategoryScreenRoute = '/add-edit-category-screen';

  /// The name of the route for wallets screen.
  static const String WalletsScreenRoute = '/wallets-screen';

  /// The name of the route for add/edit wallet screen.
  static const String AddEditWalletScreenRoute = '/add-edit-wallet-screen';

  /// The name of the route for calculator screen.
  static const String CalculatorScreenRoute = '/calculator-screen';

  /// The name of the route for balance transfer screen.
  static const String AddEditBalanceTransferScreenRoute = '/balance-transfer-screen';

  /// The name of the route for transactions screen.
  static const String TransactionsScreenRoute = '/transactions-screen';

  /// The name of the route for add/edit transaction screen.
  static const String AddEditTransactionScreenRoute = '/add-edit-transaction-screen';

  /// The name of the route for budgets screen.
  static const String BudgetsScreenRoute = '/budgets-screen';

  /// The name of the route for add/edit budget screen.
  static const String AddEditBudgetScreenRoute = '/add-edit-budget-screen';

  /// The name of the route for manage book access screen.
  static const String ManageBookAccessScreenRoute = '/manage-book-access-screen';

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
    HomeScreenRoute: (_) => const HomeScreen(),
    BooksScreenRoute: (_) => const BooksScreen(),
    AddEditBookScreenRoute: (_) => const AddEditBookScreen(),
    CategoriesScreenRoute: (_) => const CategoriesScreen(),
    AddEditCategoryScreenRoute: (_) => const AddEditCategoryScreen(),
    WalletsScreenRoute: (_) => const WalletsScreen(),
    AddEditWalletScreenRoute: (_) => const AddEditWalletScreen(),
    AddEditBalanceTransferScreenRoute: (_) => const AddEditBalanceTransferScreen(),
    CalculatorScreenRoute: (_) => const CalculatorScreen(),
    TransactionsScreenRoute: (_) => const TransactionsScreen(),
    AddEditTransactionScreenRoute: (_) => const AddEditTransactionScreen(),
    // BudgetsScreenRoute: (_) => const SizedBox.shrink(),
    // AddEditBudgetScreenRoute: (_) => const SizedBox.shrink(),
    // ManageBookAccessScreenRoute: (_) => const SizedBox.shrink(),
    // AboutScreenRoute: (_) => const SizedBox.shrink(),
    // InsightsScreenRoute: (_) => const SizedBox.shrink(),
    // QrScannerScreenRoute: (_) => const SizedBox.shrink(),
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
