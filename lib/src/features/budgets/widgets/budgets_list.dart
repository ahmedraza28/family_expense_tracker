import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/extensions.dart';

// Providers
import '../models/budget_model.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'budget_list_item.dart';

// Features
import '../../books/books.dart';

class BudgetsList extends ConsumerWidget {
  final List<BudgetModel> budgets;

  const BudgetsList({
    required this.budgets,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          final month = AppConstants.monthNames.findKeyByValue(budget.month);
          headerText = '$month, ${budget.year}';
        }
        final child = BudgetListItem(
          budget: budgets[i],
          isOwner: ref.watch(isOwnerSelectedBookProvider),
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
                    child: CustomText.body(
                      headerText,
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
  }
}
