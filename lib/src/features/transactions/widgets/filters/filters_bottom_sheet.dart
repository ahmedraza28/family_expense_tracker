import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Providers
import '../../providers/transaction_filters_providers.codegen.dart';
import '../../providers/transactions_provider.codegen.dart';

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
      ..invalidate(transactionFiltersProvider)
      ..invalidate(filteredTransactionsStreamProvider);
    AppRouter.pop();
  }

  void _onSaveTap(WidgetRef ref) {
    ref.invalidate(filteredTransactionsStreamProvider);
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
              transactionFiltersProvider.select((value) => value != null),
            );
            return hasFilters ? child! : const SizedBox(width: 50, height: 35);
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
          height: 35,
          gradient: AppColors.buttonGradientPrimary,
          onPressed: () => _onSaveTap(ref),
          child: const Center(
            child: CustomText(
              'Apply',
              fontSize: 14,
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
