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
    final monthFilterController = useValueNotifier<int?>(null);
    final yearFilterController = useValueNotifier<int?>(null);
    final categoryFilterController = useValueNotifier<CategoryModel?>(null);

    useEffect(
      () {
        monthFilterController.value = ref.read(budgetMonthFilterProvider);
        yearFilterController.value = ref.read(budgetYearFilterProvider);
        categoryFilterController.value = ref.read(budgetCategoryFilterProvider);
        return null;
      },
      [],
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
                  hintText: 'Select month',
                  items: monthNames,
                  onSelected: (month) {
                    ref.read(budgetMonthFilterProvider.notifier).state = month;
                  },
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
                  hintText: 'Select year',
                  items: {
                    for (var i = 2023; i <= (DateTime.now().year + 10); i++)
                      i.toString(): i
                  },
                  onSelected: (month) {
                    ref.read(budgetYearFilterProvider.notifier).state = month;
                  },
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
            onSelected: (category) {
              ref.read(budgetCategoryFilterProvider.notifier).state = category;
            },
          ),
        ),
      ],
    );
  }
}
