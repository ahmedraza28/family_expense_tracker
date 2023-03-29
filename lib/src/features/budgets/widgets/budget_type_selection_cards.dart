// ignore_for_file: use_setters_to_change_properties
import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/app_styles.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class BudgetTypeSelectionCards extends StatelessWidget {
  final ValueNotifier<bool> controller;
  final void Function(bool)? onSelect;

  const BudgetTypeSelectionCards({
    required this.controller,
    super.key,
    this.onSelect,
  });

  void selectBudgetType(bool isExpense) {
    if (controller.value == isExpense) return;
    controller.value = isExpense;
    onSelect?.call(controller.value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller,
      builder: (_, isExpense, __) {
        return Row(
          children: [
            // Expense Radio
            Expanded(
              child: CustomRadioButton<bool>(
                value: false,
                isSelected: !isExpense,
                icon: Icons.monetization_on_rounded,
                label: 'Income',
                onTap: selectBudgetType,
              ),
            ),

            Insets.gapW10,

            // Expense Radio
            Expanded(
              child: CustomRadioButton<bool>(
                value: true,
                isSelected: isExpense,
                icon: Icons.money_off_rounded,
                label: 'Expense',
                onTap: selectBudgetType,
              ),
            ),
          ],
        );
      },
    );
  }
}
