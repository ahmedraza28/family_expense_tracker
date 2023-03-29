import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/extensions.dart';

// Providers
import '../providers/budgets_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'budget_list_item.dart';

// Features
import '../../transactions/transactions.dart' show monthNames;

class BudgetsList extends ConsumerWidget {
  const BudgetsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: AsyncValueWidget(
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
              final budget = budgets[i];
              String? headerText;

              if (i == 0 || budget.month != budgets[i - 1].month) {
                final month = monthNames.findKeyByValue(budget.month);
                headerText = '$month, ${budget.year}';
              }
              final child = BudgetListItem(
                budget: budgets[i],
              );

              return headerText != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            0,
                            i == 0 ? 0 : 10,
                            0,
                            10,
                          ),
                          child: CustomText(
                            headerText,
                            fontSize: 15,
                            color: AppColors.textGreyColor,
                          ),
                        ),

                        // Transaction
                        child
                      ],
                    )
                  : child;
            },
          );
        },
      ),
    );
  }
}
