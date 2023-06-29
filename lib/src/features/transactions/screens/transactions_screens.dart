import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../widgets/filters/search_and_filters_bar.dart';
import '../widgets/grouped_transactions_list.dart';
import '../widgets/transactions_summary.dart';
import '../../../global/widgets/widgets.dart';

// Screens
import 'add_edit_transaction_screen.dart';

// Features
import '../../income_expense/income_expense.dart';
import '../../balance_transfer/balance_transfer.dart';
import '../../balance_adjustment/balance_adjustment.dart';
import '../../auth/auth.dart';
import '../../shared/shared.dart';
import '../../books/books.dart';

class TransactionsScreen extends HookConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      balanceAdjustmentProvider,
      (_, next) => next.whenOrNull(
        data: (message) => AppUtils.showFlushBar(
          context: context,
          message: message ?? 'Transaction operation completed',
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green,
        ),
        error: (error, stack) => AppUtils.showFlushBar(
          context: context,
          message: error.toString(),
          iconColor: Colors.red,
        ),
      ),
    );
    final selectedBook = ref.watch(selectedBookProvider)!;
    final myId = ref.watch(currentUserProvider).value!.uid;
    final isViewer = selectedBook.members[myId]!.isViewer;
    final isBackPressedOnce = useValueNotifier(false);
    return WillPopScope(
      onWillPop: () { 
        if (isBackPressedOnce.value) {
          return Future.value(true);
        }
        isBackPressedOnce.value = true;
        AppUtils.showFlushBar(
          context: context,
          message: 'Press back again to exit',
          icon: Icons.info_outline_rounded,
          iconColor: Colors.blue,
        );
        Future.delayed(const Duration(seconds: 2), () {
          isBackPressedOnce.value = false;
        });
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            selectedBook.name,
            fontSize: 20,
          ),
        ),
        drawer: const AppDrawer(),
        body: const Column(
          children: [
            // Transactions summary
            TransactionsSummary(),
    
            // Filters
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SearchAndFiltersBar(),
            ),
    
            // Transactions List
            Expanded(
              child: TransactionsList(),
            ),
          ],
        ),
        floatingActionButtonLocation:
            isViewer ? null : FloatingActionButtonLocation.centerFloat,
        floatingActionButton: isViewer
            ? Insets.shrink
            : SizedBox(
                height: 55,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Balance transfer fab
                    OpenContainer(
                      openElevation: 0,
                      closedElevation: 5,
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedColor: AppColors.primaryColor,
                      middleColor: AppColors.lightPrimaryColor,
                      closedShape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        ),
                      ),
                      tappable: false,
                      transitionDuration: Durations.medium,
                      closedBuilder: (ctx, openFunction) => SizedBox(
                        height: 55,
                        child: AddBalanceTransferFab(onPressed: openFunction),
                      ),
                      openBuilder: (ctx, closeFunction) =>
                          AddEditBalanceTransferScreen(
                        onPressed: closeFunction,
                      ),
                    ),
    
                    // Divider
                    const VerticalDivider(
                      color: Colors.white,
                      thickness: 1,
                      width: 1,
                    ),
    
                    // Add transaction fab
                    OpenContainer(
                      openElevation: 0,
                      closedElevation: 5,
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedColor: AppColors.primaryColor,
                      middleColor: AppColors.lightPrimaryColor,
                      closedShape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      tappable: false,
                      transitionDuration: Durations.medium,
                      closedBuilder: (ctx, openFunction) => SizedBox(
                        height: 55,
                        child: AddIncomeExpenseFab(onPressed: openFunction),
                      ),
                      openBuilder: (ctx, closeFunction) =>
                          AddEditTransactionScreen(
                        onPressed: closeFunction,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
