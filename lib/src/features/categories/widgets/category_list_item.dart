import 'package:flutter/material.dart';

// Models
import '../models/category_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Screens
import '../screens/add_edit_category_screen.dart';

// Features
import '../../shared/shared.dart';

class CategoryListItem extends StatelessWidget {
  final CategoryModel category;
  final bool isOwner;

  const CategoryListItem({
    required this.category,
    required this.isOwner,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: Corners.rounded15,
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          // Category icon
          ShadedIcon(
            color: category.color,
            iconData: Icons.category_rounded,
          ),

          Insets.gapW10,

          // Name
          Expanded(
            child: CustomText.body(
              category.name,
              fontSize: 15,
            ),
          ),

          if (isOwner) ...[
            Insets.gapW10,

            // Edit
            InkWell(
              onTap: () => AppRouter.push(
                AddEditCategoryScreen(category: category),
              ),
              child: const Icon(
                Icons.edit_rounded,
                size: 20,
                color: AppColors.textGreyColor,
              ),
            ),

            Insets.gapW3,
          ]
        ],
      ),
    );
  }
}
