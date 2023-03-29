import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../../helpers/constants/constants.dart';

// Providers
import '../../providers/budget_filters_providers.codegen.dart';

// Widgets
import '../../../../global/widgets/widgets.dart';

// Features
import '../../../transactions/transactions.dart';
import '../../../categories/categories.dart';

class FiltersListView extends HookConsumerWidget {
  final ScrollController scrollController;

  const FiltersListView({
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(budgetFiltersProvider);
    final monthFilterController = useValueNotifier<int?>(filters?.month);
    final yearFilterController = useValueNotifier<int?>(filters?.year);
    final categoryFilterController = useValueNotifier<CategoryModel?>(
      ref.watch(categoryByIdProvider(filters?.categoryId)),
    );

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: [
        Row(
          children: [
            // Month Dropdown Filter
            Expanded(
              child: LabeledWidget(
                label: 'Month',
                useDarkerLabel: true,
                child: CustomDropdownField<int>.animated(
                  controller: monthFilterController,
                  hintText: 'Select',
                  items: monthNames,
                  onSelected: ref.read(budgetFiltersProvider.notifier).setMonth,
                ),
              ),
            ),

            Insets.gapW15,

            // Year Dropdown Filter
            Expanded(
              child: LabeledWidget(
                label: 'Year',
                useDarkerLabel: true,
                child: CustomDropdownField<int>.animated(
                  controller: yearFilterController,
                  hintText: 'Select',
                  items: {
                    for (var i = 2023; i <= (DateTime.now().year + 10); i++)
                      i.toString(): i
                  },
                  onSelected: ref.read(budgetFiltersProvider.notifier).setYear,
                ),
              ),
            ),
          ],
        ),

        Insets.gapH20,

        // Category Dropdown Filter
        LabeledWidget(
          label: 'Category',
          useDarkerLabel: true,
          child: CategoryDropdownField(
            controller: categoryFilterController,
            onSelected: ref.read(budgetFiltersProvider.notifier).setCategory,
          ),
        ),
      ],
    );
  }
}
