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
        final filters = ref.read(filtersProvider);
        monthFilterController.value = filters?.month;
        yearFilterController.value = filters?.year;
        categoryFilterController.value = ref.read(
          categoryByIdProvider(filters?.categoryId),
        );
        return null;
      },
      [],
    );

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: [
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
          ),
        ),
      ],
    );
  }
}
