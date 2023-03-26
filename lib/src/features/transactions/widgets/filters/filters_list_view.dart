import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../../helpers/constants/constants.dart';
import '../../enums/transaction_type_enum.dart';

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
        Consumer(
          builder: (context, ref, child) {
            final types = ref.watch(transactionTypesFilterProvider);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Transfer Checkbox
                LabeledWidget(
                  label: 'Transfer',
                  labelDirection: Axis.horizontal,
                  labelPosition: LabelPosition.end,
                  labelGap: 0,
                  useDarkerLabel: true,
                  child: Checkbox(
                    value: types.contains(TransactionType.transfer),
                    onChanged: (value) => ref
                        .read(transactionTypesFilterProvider.notifier)
                        .toggle(TransactionType.transfer, value!),
                  ),
                ),

                // Income Checkbox
                LabeledWidget(
                  label: 'Income',
                  labelDirection: Axis.horizontal,
                  labelPosition: LabelPosition.end,
                  labelGap: 0,
                  useDarkerLabel: true,
                  child: Checkbox(
                    value: types.contains(TransactionType.income),
                    onChanged: (value) => ref
                        .read(transactionTypesFilterProvider.notifier)
                        .toggle(TransactionType.income, value!),
                  ),
                ),

                // Expense Checkbox
                LabeledWidget(
                  label: 'Expense',
                  labelDirection: Axis.horizontal,
                  labelPosition: LabelPosition.end,
                  labelGap: 0,
                  useDarkerLabel: true,
                  child: Checkbox(
                    value: types.contains(TransactionType.expense),
                    onChanged: (value) => ref
                        .read(transactionTypesFilterProvider.notifier)
                        .toggle(TransactionType.expense, value!),
                  ),
                ),
              ],
            );
          },
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
