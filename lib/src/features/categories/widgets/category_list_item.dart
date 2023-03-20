import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/category_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../screens/add_edit_category_screen.dart';

final isCategorySelectableProvider = StateProvider.autoDispose<bool>(
  name: 'isCategorySelectableProvider',
  (ref) {
    ref.delayDispose();
    return false;
  },
);

class CategoryListItem extends ConsumerWidget {
  final CategoryModel category;

  const CategoryListItem({
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectable = ref.watch(isCategorySelectableProvider);
    return ListTile(
      onTap: isSelectable ? () => AppRouter.pop(category) : null,
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
      trailing: isSelectable
          ? null
          : InkWell(
              onTap: () => AppRouter.push(
                AddEditCategoryScreen(category: category),
              ),
              child: const Icon(
                Icons.edit_rounded,
                size: 20,
                color: AppColors.primaryColor,
              ),
            ),
      title: CustomText.body(
        category.name,
      ),
    );
  }
}
