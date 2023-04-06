import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Providers
import '../providers/selected_budgets_provider.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../widgets/filters/filters_button.dart';
import '../widgets/selectable/selectable_budgets_view.dart';

class SelectBudgetsScreen extends ConsumerWidget {
  const SelectBudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: const SelectableBudgetsView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: double.infinity,
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: FloatingActionButton(
          onPressed: () {
            final budgets = ref.read(selectedBudgetsProvider);
            AppRouter.pop(budgets);
            ref.invalidate(selectedBudgetsProvider);
          },
          elevation: 5,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: Corners.rounded7,
          ),
          child: const DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: Corners.rounded7,
              gradient: AppColors.buttonGradientPrimary,
            ),
            child: Center(
              child: CustomText(
                'Done',
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
