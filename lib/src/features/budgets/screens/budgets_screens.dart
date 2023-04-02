import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Providers
import '../providers/budget_filters_providers.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/add_budget_fab.dart';
import '../widgets/budgets_view.dart';
import '../widgets/filters/filters_bottom_sheet.dart';

// Screens
import 'add_edit_budget_screen.dart';

// Features
import '../../books/books.dart';

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
        actions: [
          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  context: context,
                  builder: (context) => const FiltersBottomSheet(),
                );
              },
              child: Consumer(
                builder: (context, ref, child) {
                  final hasFilters = ref.watch(
                    budgetFiltersProvider.select((value) => value != null),
                  );
                  return Icon(
                    Icons.tune_rounded,
                    color: hasFilters
                        ? AppColors.primaryColor
                        : AppColors.textLightGreyColor,
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
