import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Providers
import '../../../helpers/extensions/extensions.dart';
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
    final today = DateTime.now();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Month Filter Value
          LabeledWidget(
            label: 'Month',
            child: CustomText.body(
              "${ref.watch(budgetMonthFilterProvider) ?? today.toDateString('MMMM')}",
            ),
          ),

          // Year Filter Value
          LabeledWidget(
            label: 'Year',
            child: CustomText.body(
              '${ref.watch(budgetYearFilterProvider) ?? today.year}',
            ),
          ),

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
                color: AppColors.lightBackgroundColor,
                borderRadius: Corners.rounded7,
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  final hasFilters = ref.watch(
                    budgetFiltersProvider.select((value) => value != null),
                  );
                  return Icon(
                    Icons.tune_rounded,
                    color: hasFilters
                        ? AppColors.primaryColor
                        : AppColors.textLightGreyColor,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
