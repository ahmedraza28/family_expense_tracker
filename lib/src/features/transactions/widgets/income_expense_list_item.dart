import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/income_expense_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../screens/add_edit_transaction_screen.dart';

// Features
import '../../wallets/wallets.dart';
import '../../categories/categories.dart';

class IncomeExpenseListItem extends ConsumerWidget {
  final IncomeExpenseModel transaction;

  const IncomeExpenseListItem({
    required this.transaction,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryByIdProvider(transaction.categoryId))!;
    final wallet = ref.watch(walletByIdProvider(transaction.walletId))!;
    final isExpense = category.type == CategoryType.expense;
    final seed = transaction.categoryId;
    final color = AppUtils.getRandomColor(seed);
    return InkWell(
      onTap: () => AppRouter.push(
        AddEditTransactionScreen(transaction: transaction),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: Corners.rounded15,
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Category icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: Corners.rounded9,
                color: color.withOpacity(0.2),
              ),
              child: Icon(
                Icons.monetization_on_rounded,
                size: 20,
                color: color,
              ),
            ),

            Insets.gapW15,

            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  CustomText.body(
                    transaction.description ?? '',
                    fontSize: 15,
                  ),

                  // Category Name
                  CustomText.subtitle(
                    category.name,
                    color: AppColors.textLightGreyColor,
                  ),
                ],
              ),
            ),

            // Amount
            CustomText.body(
              '${isExpense ? '-' : '+'}${wallet.currency.symbol} ${transaction.amount} ',
              color:
                  isExpense ? AppColors.redColor : Colors.greenAccent.shade700,
              fontSize: 14,
            )
          ],
        ),
      ),
    );
  }
}
