import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../enums/transaction_type_enum.dart';
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
    final isExpense = transaction.type == TransactionType.expense;
    return InkWell(
      onTap: () => AppRouter.push(
        AddEditTransactionScreen(transaction: transaction),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: Corners.rounded15,
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Category icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: Corners.rounded9,
                color: category.color.withOpacity(0.2),
              ),
              child: Icon(
                Icons.monetization_on_rounded,
                size: 20,
                color: category.color,
              ),
            ),

            Insets.gapW10,

            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  if (transaction.description != null) ...[
                    CustomText.body(
                      transaction.description ?? '',
                      fontSize: 15,
                    ),
                    Insets.gapH3,
                  ],

                  // Category Name
                  CustomText(
                    category.name,
                    color: transaction.description != null
                        ? AppColors.textLightGreyColor
                        : null,
                    fontSize: transaction.description != null ? 13 : 15,
                  ),
                ],
              ),
            ),

            Insets.gapW10,

            // Amount
            Consumer(
              builder: (context, ref, child) {
                final currency = ref.watch(selectedBookCurrencyProvider);
                return CustomText.body(
                  '${isExpense ? '-' : '+'}${currency.symbol} ${transaction.amount.toInt()} ',
                  color: isExpense
                      ? AppColors.redColor
                      : Colors.greenAccent.shade700,
                  fontSize: 14,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
