import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../widgets/add_transaction_fab.dart';
import '../widgets/search_and_filters_bar.dart';
import '../widgets/transactions_list.dart';
import '../../../global/widgets/widgets.dart';
import 'add_edit_transaction_screen.dart';

// Features
import '../../books/books.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBook = ref.watch(selectedBookProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          selectedBook.name,
          fontSize: 20,
        ),
        toolbarHeight: kToolbarHeight + 30,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Income
                CustomText(
                  'Income: \$${selectedBook.totalIncome}',
                  fontSize: 16,
                  color: AppColors.textGreyColor,
                ),

                // Expense
                CustomText(
                  'Expense: \$${selectedBook.totalExpense}',
                  fontSize: 16,
                  color: AppColors.textGreyColor,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: const [
          // Filters
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SearchAndFiltersBar(),
          ),

          // Events List
          Expanded(
            child: TransactionsList(),
          ),
        ],
      ),
      floatingActionButton: OpenContainer(
        openElevation: 0,
        closedElevation: 5,
        transitionType: ContainerTransitionType.fadeThrough,
        closedColor: AppColors.primaryColor,
        middleColor: AppColors.lightPrimaryColor,
        closedShape: RoundedRectangleBorder(
          borderRadius: Corners.rounded(50),
        ),
        tappable: false,
        transitionDuration: Durations.medium,
        closedBuilder: (ctx, openFunction) => AddTransactionFab(
          onPressed: openFunction,
        ),
        openBuilder: (ctx, closeFunction) => const AddEditTransactionScreen(),
      ),
    );
  }
}
