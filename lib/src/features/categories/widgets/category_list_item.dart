import 'package:flutter/material.dart';

// Models
import '../models/category_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class CategoryListItem extends StatelessWidget {
  final CategoryModel? category;
  final VoidCallback onTap;

  const CategoryListItem({
    required this.onTap,
    super.key,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        tileColor: AppColors.textLightGreyColor,
        shape: const RoundedRectangleBorder(
          borderRadius: Corners.rounded15,
        ),
        leading: const Icon(
          Icons.category_rounded,
          color: AppColors.textLightGreyColor,
        ),
        trailing: IconButton(
          onPressed: () {
            AppRouter.pushNamed(Routes.AddEditCategoryScreenRoute);
          },
          icon: const Icon(
            Icons.edit_rounded,
            color: AppColors.primaryColor,
          ),
        ),
        title: const CustomText(
          'Category Name',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlackColor,
        ),
      ),
    );
  }
}
