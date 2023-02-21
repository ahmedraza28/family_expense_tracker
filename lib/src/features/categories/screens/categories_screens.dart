import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/add_category_fab.dart';
import '../widgets/category_type_tabs.dart';
import 'add_edit_category_screen.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(
            'Your Categories',
            fontSize: 20,
          ),
          bottom: const TabBar(
            labelColor: AppColors.primaryColor,
            indicatorWeight: 3,
            indicatorColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.textLightGreyColor,
            tabs: [
              Tab(child: Text('Income')),
              Tab(child: Text('Expense')),
            ],
          ),
        ),
        body: const CategoryTypesTabs(),
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
          openBuilder: (ctx, closeFunction) => const AddEditCategoryScreen(),
        ),
      ),
    );
  }
}
