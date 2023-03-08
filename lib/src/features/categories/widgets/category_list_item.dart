import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/category_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Providers
import '../providers/categories_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class CategoryListItem extends ConsumerWidget {
  final CategoryModel category;

  const CategoryListItem({
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
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
      trailing: InkWell(
        onTap: () {
          ref.read(editCategoryProvider.notifier).update((state) => category);
          AppRouter.pushNamed(Routes.AddEditCategoryScreenRoute);
        },
        child: const Icon(
          Icons.edit_rounded,
          size: 20,
          color: AppColors.primaryColor,
        ),
      ),
      title: CustomText.body(
        'Category Name',
      ),
    );
  }
}
