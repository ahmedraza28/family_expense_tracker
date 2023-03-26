import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Providers
import '../providers/budget_filters_providers.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'budget_list_item.dart';

class BudgetsList extends ConsumerWidget {
  const BudgetsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(filteredBudgetsStreamProvider),
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 70),
        child: CustomCircularLoader(),
      ),
      error: (error, st) => ErrorResponseHandler(
        error: error,
        retryCallback: () {},
        stackTrace: st,
      ),
      emptyOrNull: () => const EmptyStateWidget(
        height: 395,
        width: double.infinity,
        margin: EdgeInsets.only(top: 20),
        title: 'No budgets built yet',
        subtitle: 'Check back later',
      ),
      data: (budgets) {
        return ListView.separated(
          itemCount: budgets.length,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          separatorBuilder: (_, __) => Insets.gapH15,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemBuilder: (_, i) {
            return BudgetListItem(
              budget: budgets[i],
            );
          },
        );
      },
    );
  }
}
