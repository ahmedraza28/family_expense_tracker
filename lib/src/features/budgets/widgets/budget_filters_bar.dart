import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Providers
import '../providers/budget_filters_providers.codegen.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'filters/filters_bottom_sheet.dart';

class BudgetFiltersBar extends ConsumerWidget {
  const BudgetFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Filter Value
          LabeledWidget(
            label: 'Month',
            child: CustomText.body(
              ref.watch(budgetMonthFilterProvider).toString(),
            ),
          ),

          Insets.gapW20,

          // Year Filter Value
          LabeledWidget(
            label: 'Year',
            child: CustomText.body(
              ref.watch(budgetYearFilterProvider).toString(),
            ),
          ),

          Insets.expand,

          // Filters Button
          InkWell(
            onTap: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (context) {
                  return const FiltersBottomSheet();
                },
              );
            },
            child: Container(
              height: 47,
              width: 47,
              decoration: const BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: Corners.rounded7,
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: AppColors.textLightGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
