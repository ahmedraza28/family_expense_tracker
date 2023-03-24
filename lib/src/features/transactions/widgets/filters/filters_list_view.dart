import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../../helpers/constants/constants.dart';

// Providers
import '../../providers/transaction_filters_providers.codegen.dart';

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
            Consumer(
              builder: (context, ref, child) {
                final isChecked = ref.watch(balanceTransferOnlyFilterProvider);
                return LabeledWidget(
                  label: 'Balance Transfer',
                  labelDirection: Axis.horizontal,
                  labelPosition: LabelPosition.end,
                  labelGap: 0,
                  useDarkerLabel: true,
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (value) => ref
                        .read(balanceTransferOnlyFilterProvider.notifier)
                        .state = value!,
                  ),
                );
              },
            ),

            // Income Expense Checkbox
            Consumer(
              builder: (context, ref, child) {
                final isChecked = ref.watch(incomeExpenseOnlyFilterProvider);
                return LabeledWidget(
                  label: 'Income Expense',
                  labelDirection: Axis.horizontal,
                  labelPosition: LabelPosition.end,
                  labelGap: 0,
                  useDarkerLabel: true,
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (value) => ref
                        .read(incomeExpenseOnlyFilterProvider.notifier)
                        .state = value!,
                  ),
                );
              },
            ),
          ],
        ),

        Insets.gapH20,

        // Month Dropdown Filter
        LabeledWidget(
          label: 'Month',
          useDarkerLabel: true,
          child: CustomDropdownField<int>.animated(
            controller: monthFilterController,
            hintText: 'Select a month',
            items: monthNames,
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
