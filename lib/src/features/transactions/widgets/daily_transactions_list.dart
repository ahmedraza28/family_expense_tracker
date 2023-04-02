import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/income_expense_model.codegen.dart';
import '../models/transaction_model.dart';

// Widgets
import 'income_expense_list_item.dart';

// Features
import '../../balance_transfer/balance_transfer.dart';

class DayTransactionsList extends StatelessWidget {
  const DayTransactionsList({
    required this.transactions,
    super.key,
  });

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: transactions.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (_, i) => const SizedBox(
        height: 10,
        child: VerticalDivider(
          width: 2,
          thickness: 1.5,
          color: AppColors.textLightGreyColor,
        ),
      ),
      itemBuilder: (_, i) {
        final trans = transactions[i];
        return trans.isBalanceTransfer
            ? BalanceTransferListItem(
                balanceTransfer: trans as BalanceTransferModel,
              )
            : IncomeExpenseListItem(
                transaction: trans as IncomeExpenseModel,
              );
      },
    );
  }
}
