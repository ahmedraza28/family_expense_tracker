import 'package:flutter/material.dart';

// Models
import '../models/category_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../screens/add_edit_category_screen.dart';

class CategoryListItem extends StatelessWidget {
  final CategoryModel category;

  const CategoryListItem({
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
