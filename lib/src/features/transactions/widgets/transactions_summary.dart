import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Routing
import '../../../config/routing/routing.dart';

// Providers
import '../providers/transactions_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class TransactionsSummary extends StatelessWidget {
  const TransactionsSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: Corners.rounded15,
      onTap: () => AppRouter.pushNamed(Routes.InsightsScreenRoute),
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: Corners.rounded15,
          color: Colors.white,
        ),
        child: Consumer(
          builder: (_, ref, __) {
            final state = ref.watch(groupedTransactionsProvider);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Balance and Arrears
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance
                    LabeledWidget(
                      label: 'Balance',
                      child: state.when(
                        data: (data) {
                          final diff = data.totalIncome - data.totalExpenses;
                          final isNeg = diff < 0;
                          return CustomText.body(
                            "${isNeg ? '-' : ''} \$${diff.abs()}",
                            color: AppColors.textGreyColor,
                          );
                        },
                        error: (error, st) => CustomText.body(
                          'Unavailable',
                          color: AppColors.textGreyColor,
                        ),
                        loading: () => const CustomCircularLoader(size: 25),
                      ),
                    ),

                    Insets.gapH15,

                    // Arrears
                    LabeledWidget(
                      label: 'Arreas',
                      child: state.when(
                        data: (data) {
                          final isNeg = data.totalArrears < 0;
                          return CustomText.body(
                            "${isNeg ? '-' : ''} \$${data.totalArrears.abs()}",
                            color: AppColors.textGreyColor,
                          );
                        },
                        error: (error, st) => CustomText.body(
                          'Unavailable',
                          color: AppColors.textGreyColor,
                        ),
                        loading: () => const CustomCircularLoader(size: 25),
                      ),
                    ),
                  ],
                ),

                // Income and Expense
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Income
                    LabeledWidget(
                      label: 'Income',
                      child: state.when(
                        data: (data) {
                          final isNeg = data.totalIncome < 0;
                          return CustomText.body(
                            "${isNeg ? '-' : ''} \$${data.totalIncome.abs()}",
                            color: AppColors.textGreyColor,
                          );
                        },
                        error: (error, st) => CustomText.body(
                          'Unavailable',
                          color: AppColors.textGreyColor,
                        ),
                        loading: () => const CustomCircularLoader(size: 25),
                      ),
                    ),

                    Insets.gapH15,

                    // Expense
                    LabeledWidget(
                      label: 'Expense',
                      child: state.when(
                        data: (data) {
                          final isNeg = data.totalExpenses < 0;
                          return CustomText.body(
                            "${isNeg ? '-' : ''} \$${data.totalExpenses.abs()}",
                            color: AppColors.textGreyColor,
                          );
                        },
                        error: (error, st) => CustomText.body(
                          'Unavailable',
                          color: AppColors.textGreyColor,
                        ),
                        loading: () => const CustomCircularLoader(size: 25),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
