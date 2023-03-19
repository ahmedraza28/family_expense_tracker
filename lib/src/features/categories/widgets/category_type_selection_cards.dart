// ignore_for_file: use_setters_to_change_properties
import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/app_styles.dart';

// Enums
import '../enums/category_type_enum.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class CategoryTypeSelectionCards extends StatelessWidget {
  final ValueNotifier<CategoryType?> controller;
  final void Function(CategoryType?)? onSelect;

  const CategoryTypeSelectionCards({
    required this.controller,
    super.key,
    this.onSelect,
  });

  void selectCategoryType(CategoryType categoryType) {
    if (controller.value == categoryType) return;
    controller.value = categoryType;
    onSelect?.call(controller.value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CategoryType?>(
      valueListenable: controller,
      builder: (_, categoryType, __) {
        return Row(
          children: [
            // Male Radio
            Expanded(
              child: CustomRadioButton<CategoryType>(
                value: CategoryType.income,
                isSelected: categoryType == CategoryType.income,
                icon: Icons.monetization_on_rounded,
                label: 'Income',
                onTap: selectCategoryType,
              ),
            ),

            Insets.gapW10,

            // Female Radio
            Expanded(
              child: CustomRadioButton<CategoryType>(
                value: CategoryType.expense,
                isSelected: categoryType == CategoryType.expense,
                icon: Icons.money_off_rounded,
                label: 'Expense',
                onTap: selectCategoryType,
              ),
            ),
          ],
        );
      },
    );
  }
}
