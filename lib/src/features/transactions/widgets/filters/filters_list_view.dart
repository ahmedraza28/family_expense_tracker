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
    final filters = ref.watch(transactionFiltersProvider);
    final monthFilterController = useValueNotifier<int?>(filters?.month);
    final yearFilterController = useValueNotifier<int?>(filters?.year);
    final categoryFilterController = useValueNotifier<CategoryModel?>(
      ref.watch(categoryByIdProvider(filters?.categoryId)),
    );

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: [
        // Checkboxes Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Transfer Checkbox
            LabeledWidget(
              label: 'Transfer',
              labelDirection: Axis.horizontal,
              labelPosition: LabelPosition.end,
              labelGap: 0,
              useDarkerLabel: true,
              child: CustomCheckbox(
                value: filters?.hasTransfer,
                onChanged: (value) => ref
                    .read(transactionFiltersProvider.notifier)
                    .toggleType(TransactionType.transfer, value!),
              ),
            ),

            // Income Checkbox
            LabeledWidget(
              label: 'Income',
              labelDirection: Axis.horizontal,
              labelPosition: LabelPosition.end,
              labelGap: 0,
              useDarkerLabel: true,
              child: CustomCheckbox(
                value: filters?.hasIncome,
                onChanged: (value) => ref
                    .read(transactionFiltersProvider.notifier)
                    .toggleType(TransactionType.income, value!),
              ),
            ),

            // Expense Checkbox
            LabeledWidget(
              label: 'Expense',
              labelDirection: Axis.horizontal,
              labelPosition: LabelPosition.end,
              labelGap: 0,
              useDarkerLabel: true,
              child: CustomCheckbox(
                value: filters?.hasExpense,
                onChanged: (value) => ref
                    .read(transactionFiltersProvider.notifier)
                    .toggleType(TransactionType.expense, value!),
              ),
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
            items: AppConstants.monthNames,
            onSelected: ref.read(transactionFiltersProvider.notifier).setMonth,
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
            onSelected: ref.read(transactionFiltersProvider.notifier).setYear,
          ),
        ),

        Insets.gapH20,

        // Category Dropdown Filter
        LabeledWidget(
          label: 'Category',
          useDarkerLabel: true,
          child: CategoryDropdownField(
            controller: categoryFilterController,
            onSelected:
                ref.read(transactionFiltersProvider.notifier).setCategory,
          ),
        ),
      ],
    );
  }
}
