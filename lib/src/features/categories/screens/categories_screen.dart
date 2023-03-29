import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/add_category_fab.dart';
import '../widgets/categories_list.dart';
import 'add_edit_category_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'Your Categories',
          fontSize: 20,
        ),
      ),
      body: const CategoriesList(),
      floatingActionButton: OpenContainer(
        openElevation: 0,
        closedElevation: 5,
        transitionType: ContainerTransitionType.fadeThrough,
        closedColor: AppColors.primaryColor,
        middleColor: AppColors.lightPrimaryColor,
        closedShape: RoundedRectangleBorder(
          borderRadius: Corners.rounded(50),
        ),
        tappable: false,
        transitionDuration: Durations.medium,
        closedBuilder: (ctx, openFunction) => AddCategoryFab(
          onPressed: openFunction,
        ),
        openBuilder: (ctx, closeFunction) => AddEditCategoryScreen(
          onPressed: closeFunction,
        ),
      ),
    );
  }
}
