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
    final categoryTypeController =
        useValueNotifier<CategoryType>(CategoryType.income);

    useEffect(
      () {
        monthFilterController.value = ref.read(expenseMonthFilterProvider);
        yearFilterController.value = ref.read(expenseYearFilterProvider);
        categoryFilterController.value = ref.read(categoryFilterProvider);
        categoryTypeController.value = categoryFilterController.value?.type ??
            categoryTypeController.value;
        return null;
      },
      [],
    );

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: [
        // Month Dropdown Filter
        Consumer(
          builder: (context, ref, child) {
            return LabeledWidget(
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
            );
          },
        ),

        Insets.gapH20,

        // Year Dropdown Filter
        Consumer(
          builder: (context, ref, child) {
            final today = DateTime.now();
            final maxYear = today.year + 10;
            const minYear = 2023;
            return LabeledWidget(
              label: 'Year',
              useDarkerLabel: true,
              child: CustomDropdownField<int>.animated(
                controller: yearFilterController,
                hintText: 'Select a year',
                items: {
                  for (var i = minYear; i <= maxYear; i++) i.toString(): i
                },
                onSelected: (month) {
                  ref.read(expenseYearFilterProvider.notifier).state = month;
                },
              ),
            );
          },
        ),

        Insets.gapH20,

        // Category Type
        LabeledWidget(
          label: 'Category Type',
          useDarkerLabel: true,
          child: CategoryTypeSelectionCards(
            controller: categoryTypeController,
          ),
        ),

        Insets.gapH20,

        // Category Dropdown Filter
        Consumer(
          builder: (context, ref, _) {
            final categoriesStream = ref.watch(
              categoriesStreamProvider(categoryTypeController.value),
            );
            return LabeledWidget(
              label: 'Category',
              child: CustomDropdownField<CategoryModel>.sheet(
                controller: categoryFilterController,
                selectedItemBuilder: (item) => CustomText.body(item.name),
                hintText: 'Select category',
                itemsSheet: CustomDropdownSheet(
                  items: categoriesStream.valueOrNull ?? [],
                  bottomSheetTitle: 'Categories',
                  itemBuilder: (_, item) => DropdownSheetItem(
                    label: item.name,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
