import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/add_category_fab.dart';
import '../widgets/categories_list.dart';

// Screens
import 'add_edit_category_screen.dart';

// Features
import '../../shared/shared.dart';
import '../../books/books.dart';

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
      drawer: const AppDrawer(),
      body: const CategoriesList(),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final isOwner = ref.watch(isOwnerSelectedBookProvider);
          return !isOwner
              ? Insets.shrink
              : OpenContainer(
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
                );
        },
      ),
    );
  }
}
