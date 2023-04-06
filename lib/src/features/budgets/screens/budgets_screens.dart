import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/add_budget_fab.dart';
import '../widgets/budgets_view.dart';

// Screens
import '../widgets/filters/filters_button.dart';
import 'add_edit_budget_screen.dart';

// Features
import '../../books/books.dart';
import '../../shared/shared.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'Your Budgets',
          fontSize: 20,
        ),
        actions: const [
          // Filters
          FiltersButton(),
        ],
      ),
      drawer: const AppDrawer(),
      body: const BudgetsView(),
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
                  closedBuilder: (ctx, openFunction) => AddBudgetFab(
                    onPressed: openFunction,
                  ),
                  openBuilder: (ctx, closeFunction) => AddEditBudgetScreen(
                    onPressed: closeFunction,
                  ),
                );
        },
      ),
    );
  }
}
