import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../../helpers/constants/constants.dart';

// Providers
import '../../providers/filter_providers.codegen.dart';

// Widgets
import '../../../../global/widgets/widgets.dart';

// Features
import '../../../categories/categories.dart';

class FiltersListView extends HookConsumerWidget {
  final ScrollController scrollController;

  const FiltersListView({
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthFilterController = useValueNotifier<int?>(null);
    final yearFilterController = useValueNotifier<int?>(null);
    final categoryFilterController = useValueNotifier<CategoryModel?>(null);

    useEffect(
      () {
        monthFilterController.value = ref.read(expenseMonthFilterProvider);
        yearFilterController.value = ref.read(expenseYearFilterProvider);
        categoryFilterController.value = ref.read(categoryFilterProvider);
        return null;
      },
      [],
    );

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: [
        // Checkboxes Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Balance Transfer Checkbox
            LabeledWidget(
              label: 'Balance Transfer Only',
              labelDirection: Axis.horizontal,
              labelPosition: LabelPosition.end,
              labelGap: 10,
              labelStyle: const TextStyle(
                fontSize: 14,
                color: AppColors.textBlackColor,
              ),
              useDarkerLabel: true,
              child: Checkbox(
                value: ref.watch(balanceTransferOnlyFilterProvider),
                onChanged: (value) => ref
                    .read(balanceTransferOnlyFilterProvider.notifier)
                    .state = value!,
              ),
            ),

            // Income Expense Checkbox
            LabeledWidget(
              label: 'Income Expense Only',
              labelDirection: Axis.horizontal,
              labelPosition: LabelPosition.end,
              labelGap: 10,
              labelStyle: const TextStyle(
                fontSize: 14,
                color: AppColors.textBlackColor,
              ),
              useDarkerLabel: true,
              child: Checkbox(
                value: ref.watch(incomeExpenseOnlyFilterProvider),
                onChanged: (value) => ref
                    .read(incomeExpenseOnlyFilterProvider.notifier)
                    .state = value!,
              ),
            ),
          ],
        ),

        // Month Dropdown Filter
        LabeledWidget(
          label: 'Month',
          useDarkerLabel: true,
          child: CustomDropdownField<int>.animated(
            controller: monthFilterController,
            hintText: 'Select a month',
            items: const {
              'January': 1,
              'February': 2,
              'March': 3,
              'April': 4,
              'May': 5,
              'June': 6,
              'July': 7,
              'August': 8,
              'September': 9,
              'October': 10,
              'November': 11,
              'December': 12,
            },
            onSelected: (month) {
              ref.read(expenseMonthFilterProvider.notifier).state = month;
            },
          ),
        ),

        Insets.gapH20,

        // Year Dropdown Filter
        LabeledWidget(
          label: 'Year',
          useDarkerLabel: true,
          child: CustomDropdownField<int>.animated(
            controller: yearFilterController,
            hintText: 'Select a year',
            items: {
              for (var i = 2023; i <= (DateTime.now().year + 10); i++)
                i.toString(): i
            },
            onSelected: (month) {
              ref.read(expenseYearFilterProvider.notifier).state = month;
            },
          ),
        ),

        Insets.gapH20,

        // Category Dropdown Filter
        LabeledWidget(
          label: 'Category',
          useDarkerLabel: true,
          child: CategoryDropdownField(
            controller: categoryFilterController,
            onSelected: (category) {
              ref.read(categoryFilterProvider.notifier).state = category;
            },
          ),
        ),
      ],
    );
  }
}
