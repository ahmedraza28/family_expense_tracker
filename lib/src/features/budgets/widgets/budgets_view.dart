import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/budget_model.codegen.dart';

// Providers
import '../providers/budgets_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'budgets_list.dart';

class BudgetsView extends ConsumerStatefulWidget {
  const BudgetsView({super.key});

  @override
  ConsumerState<BudgetsView> createState() => BudgetsViewState();
}

class BudgetsViewState extends ConsumerState<BudgetsView> {
  int _selectedSegmentValue = 0;

  @override
  Widget build(BuildContext context) {
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
          final expenseBudgets = <BudgetModel>[];
          final incomeBudgets = <BudgetModel>[];

          for (final budget in budgets) {
            if (budget.isExpense) {
              expenseBudgets.add(budget);
            } else {
              incomeBudgets.add(budget);
            }
          }

          return Column(
            children: [
              // Filters
              CupertinoSlidingSegmentedControl(
                children: {
                  0: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Expense',
                      style: TextStyle(
                        fontSize: 13,
                        color: _selectedSegmentValue == 0
                            ? AppColors.textWhite80Color
                            : AppColors.primaryColor,
                      ),
                    ),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Income',
                      style: TextStyle(
                        fontSize: 13,
                        color: _selectedSegmentValue == 1
                            ? AppColors.textWhite80Color
                            : AppColors.primaryColor,
                      ),
                    ),
                  ),
                },
                padding: const EdgeInsets.all(5),
                thumbColor: AppColors.primaryColor,
                backgroundColor: Colors.white,
                groupValue: _selectedSegmentValue,
                onValueChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSegmentValue = newValue;
                    });
                  }
                },
              ),

              Insets.gapH15,

              // Budgets List
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeIn,
                  child: _selectedSegmentValue == 0
                      ? BudgetsList(
                          budgets: expenseBudgets,
                        )
                      : BudgetsList(
                          budgets: incomeBudgets,
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
