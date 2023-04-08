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

// Screens
import '../screens/add_edit_transaction_screen.dart';

// Features
import '../../auth/auth.dart';
import '../../books/books.dart';
import '../../shared/shared.dart';
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
    final category = ref.watch(
      categoryByIdProvider(transaction.categoryId),
    )!;
    final isExpense = transaction.type == TransactionType.expense;
    final selectedBook = ref.watch(selectedBookProvider)!;
    final myId = ref.watch(currentUserProvider).value!.uid;
    final isViewer = selectedBook.members[myId]!.isViewer;
    return InkWell(
      onTap: isViewer
          ? null
          : () {
              AppRouter.push(
                AddEditTransactionScreen(transaction: transaction),
              );
            },
      borderRadius: Corners.rounded15,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: Corners.rounded15,
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Category icon
            ShadedIcon(
              color: category.color,
              iconData: Icons.monetization_on_rounded,
            ),

            Insets.gapW15,

            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  if (transaction.description != null) ...[
                    CustomText.body(
                      transaction.description ?? '',
                    ),
                    Insets.gapH5,
                  ],

                  // Category Name
                  CustomText(
                    category.name,
                    color: transaction.description != null
                        ? AppColors.textLightGreyColor
                        : null,
                    fontSize: transaction.description != null ? 14 : 16,
                  ),
                ],
              ),
            ),

            Insets.gapW15,

            // Amount
            Consumer(
              builder: (context, ref, child) {
                final currency = ref.watch(selectedBookCurrencyProvider);
                return CustomText.body(
                  '${isExpense ? '-' : '+'}${currency.symbol} ${transaction.amount.toInt()} ',
                  color: isExpense ? AppColors.redColor : AppColors.greenColor,
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
