import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Providers
import '../../providers/budget_filters_providers.codegen.dart';
import '../../providers/budgets_provider.codegen.dart';

// Helpers
import '../../../../helpers/constants/constants.dart';

// Routing
import '../../../../config/routing/routing.dart';

// Widgets
import '../../../../global/widgets/widgets.dart';
import 'filters_list_view.dart';

class FiltersBottomSheet extends ConsumerWidget {
  const FiltersBottomSheet({super.key});

  void _onResetTap(WidgetRef ref) {
    ref
      ..invalidate(budgetFiltersProvider)
      ..invalidate(filteredBudgetsStreamProvider);
    AppRouter.pop();
  }

  void _onSaveTap(WidgetRef ref) {
    ref.invalidate(filteredBudgetsStreamProvider);
    AppRouter.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: CustomScrollableBottomSheet(
        titleText: 'Filters',
        leading: Consumer(
          builder: (_, ref, child) {
            final hasFilters = ref.watch(
              budgetFiltersProvider.select((value) => value != null),
            );
            return hasFilters ? child! : const SizedBox(width: 50, height: 30);
          },
          child: InkWell(
            onTap: () => _onResetTap(ref),
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: CustomText(
                'Reset',
                fontSize: 16,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
        action: CustomTextButton.gradient(
          width: 60,
          height: 30,
          gradient: AppColors.buttonGradientPrimary,
          onPressed: () => _onSaveTap(ref),
          child: const Center(
            child: CustomText(
              'Apply',
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
        builder: (_, scrollController) => FiltersListView(
          scrollController: scrollController,
        ),
      ),
    );
  }
}
