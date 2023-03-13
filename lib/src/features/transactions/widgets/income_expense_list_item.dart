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

class IncomeExpenseListItem extends ConsumerWidget {
  final IncomeExpenseModel transaction;

  const IncomeExpenseListItem({
    required this.transaction,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      dense: true,
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      tileColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: Corners.rounded15,
      ),
      leading: const Icon(
        Icons.money,
        color: AppColors.textLightGreyColor,
      ),
      trailing: InkWell(
        onTap: () => AppRouter.push(
          AddEditTransactionScreen(transaction: transaction),
        ),
        child: const Icon(
          Icons.edit_rounded,
          size: 20,
          color: AppColors.primaryColor,
        ),
      ),
      title: CustomText.body(
        transaction.category.name,
      ),
      subtitle: CustomText.subtitle(
        transaction.description ?? '',
      ),
    );
  }
}
