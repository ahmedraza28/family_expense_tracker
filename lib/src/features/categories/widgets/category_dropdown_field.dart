import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../enums/category_type_enum.dart';

// Models
import '../models/category_model.codegen.dart';

// Providers
import '../providers/categories_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class CategoryDropdownField extends HookWidget {
  final ValueNotifier<CategoryModel?> controller;
  final SelectedCallback<CategoryModel> onSelected;

  const CategoryDropdownField({
    required this.controller,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);
    return CustomDropdownField<CategoryModel>.sheet(
      controller: controller,
      onSelected: onSelected,
      selectedItemBuilder: (item) => CustomText.body(item.name),
      hintText: 'Select category',
      itemsSheet: CustomDropdownSheet<CategoryModel>.builder(
        bottomSheetTitle: 'Categories',
        builder: (_, scrollController) => Column(
          children: [
            // Tab bar
            TabBar(
              controller: tabController,
              tabs: [
                Tab(
                  child: CustomText.body(
                    'Income',
                    color:
                        tabController.index == 0 ? Colors.black : Colors.grey,
                  ),
                ),
                Tab(
                  child: CustomText.body(
                    'Expense',
                    color:
                        tabController.index == 1 ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),

            // Tab bar view
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  // Income Categories
                  Consumer(
                    builder: (context, ref, _) {
                      final categoriesStream = ref.watch(
                        categoriesByTypeProvider(
                          CategoryType.income,
                        ),
                      );
                      return _CategoriesSheetList(
                        scrollController: scrollController,
                        categories: categoriesStream.value ?? [],
                      );
                    },
                  ),

                  // Expense Categories
                  Consumer(
                    builder: (context, ref, _) {
                      final categoriesStream = ref.watch(
                        categoriesByTypeProvider(
                          CategoryType.expense,
                        ),
                      );
                      return _CategoriesSheetList(
                        scrollController: scrollController,
                        categories: categoriesStream.value ?? [],
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CategoriesSheetList extends StatelessWidget {
  final List<CategoryModel> categories;
  final ScrollController scrollController;

  const _CategoriesSheetList({
    required this.categories,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final item = categories[index];
        return InkWell(
          onTap: () => AppRouter.pop(item),
          child: DropdownSheetItem(label: item.name),
        );
      },
    );
  }
}
