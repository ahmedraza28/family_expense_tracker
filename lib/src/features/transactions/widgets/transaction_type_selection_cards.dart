// ignore_for_file: use_setters_to_change_properties
import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/app_styles.dart';

// Enums
import '../enums/transaction_type_enum.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class TransactionTypeSelectionCards extends StatelessWidget {
  final ValueNotifier<TransactionType?> controller;
  final void Function(TransactionType?)? onSelect;

  const TransactionTypeSelectionCards({
    required this.controller,
    super.key,
    this.onSelect,
  });

  void selectTransactionType(TransactionType transactionType) {
    if (controller.value == transactionType) return;
    controller.value = transactionType;
    onSelect?.call(controller.value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TransactionType?>(
      valueListenable: controller,
      builder: (_, categoryType, __) {
        return Row(
          children: [
            // Male Radio
            Expanded(
              child: CustomRadioButton<TransactionType>(
                value: TransactionType.income,
                isSelected: categoryType == TransactionType.income,
                icon: Icons.monetization_on_rounded,
                label: 'Income',
                onTap: selectTransactionType,
              ),
            ),

            Insets.gapW10,

            // Female Radio
            Expanded(
              child: CustomRadioButton<TransactionType>(
                value: TransactionType.expense,
                isSelected: categoryType == TransactionType.expense,
                icon: Icons.money_off_rounded,
                label: 'Expense',
                onTap: selectTransactionType,
              ),
            ),
          ],
        );
      },
    );
  }
}
