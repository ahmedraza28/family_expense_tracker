import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../../models/category_model.codegen.dart';

// Helpers
import '../../../../helpers/constants/constants.dart';

// Providers
import '../../providers/selected_categories_provider.codegen.dart';

// Widgets
import '../../../../global/widgets/widgets.dart';

class SelectableCategoryListItem extends ConsumerWidget {
  final CategoryModel category;

  const SelectableCategoryListItem({
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref
        .watch(selectedCategoriesProvider)
        .any((element) => element.id == category.id);
    return ListTile(
      onTap: () {
        ref
            .read(selectedCategoriesProvider.notifier)
            .toggle(category, !isSelected);
      },
      dense: true,
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      tileColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: Corners.rounded15,
      ),
      leading: const Icon(
        Icons.category_rounded,
        color: AppColors.textLightGreyColor,
      ),
      trailing: !isSelected
          ? null
          : const Icon(
              Icons.check_rounded,
              size: 20,
              color: AppColors.primaryColor,
            ),
      title: CustomText.body(category.name),
    );
  }
}
