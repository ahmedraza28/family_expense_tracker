import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/category_model.codegen.dart';

// Providers
import '../providers/categories_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class CategoryDropdownField extends ConsumerWidget {
  final ValueNotifier<CategoryModel?> controller;
  final SelectedCallback<CategoryModel>? onSelected;

  const CategoryDropdownField({
    required this.controller,
    this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(enabledCategoriesStreamProvider).valueOrNull ?? [];
    return CustomDropdownField<CategoryModel>.sheet(
      controller: controller,
      selectedItemBuilder: (item) => CustomText.body(item.name),
      hintText: 'Select category',
      itemsSheet: CustomDropdownSheet<CategoryModel>(
        bottomSheetTitle: 'Categories',
        items: categories,
        onItemSelect: onSelected,
        itemBuilder: (_, category) => DropdownSheetItem(
          label: category.name,
        ),
      ),
    );
  }
}
