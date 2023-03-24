import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/add_budget_fab.dart';
import '../widgets/budget_filters_bar.dart';
import '../widgets/budgets_list.dart';
import 'add_edit_budget_screen.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(
            'Your Budgets',
            fontSize: 20,
          ),
        ),
        body: Column(
          children: const [
            // Filters
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: BudgetFiltersBar(),
            ),

            // Events List
            Expanded(
              child: BudgetsList(),
            ),
          ],
        ),
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
          closedBuilder: (ctx, openFunction) => AddBudgetFab(
            onPressed: openFunction,
          ),
          openBuilder: (ctx, closeFunction) => AddEditBudgetScreen(
            onPressed: closeFunction,
          ),
        ),
      ),
    );
  }
}
