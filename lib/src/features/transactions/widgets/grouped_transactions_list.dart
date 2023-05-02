import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/extensions.dart';

// Models
import '../../wallets/wallets.dart';

// Providers
import '../providers/transactions_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'daily_transactions_list.dart';

// Features

class TransactionsList extends ConsumerWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueWidget(
      value: ref.watch(groupedTransactionsProvider),
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
        title: 'No transactions recorded yet',
        subtitle: 'Check back later',
      ),
      data: (groupedTransactions) {
        final transactions = groupedTransactions.transactions;
        final days = [...transactions.keys];
        return ListView.separated(
          itemCount: days.length,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 90),
          separatorBuilder: (_, i) => Insets.gapH15,
          itemBuilder: (_, i) {
            final day = days[i];
            final dayTransactions = transactions[day]!;
            final sum = dayTransactions.netTotal;
            final isPositive = sum > 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      // Date
                      CustomText.body(
                        dayTransactions.date.toDateString('d MMM, y'),
                        color: AppColors.textGreyColor,
                      ),

                      // Day Total
                      Expanded(
                        child: Consumer(
                          builder: (context, ref, child) {
                            final currency = ref
                                .watch(
                                  selectedBookCurrencyProvider,
                                )
                                .symbol;
                            return CustomText(
                              '${isPositive ? '+' : '-'} $currency ${sum.abs()}',
                              color: AppColors.textGreyColor,
                              fontSize: 16,
                              textAlign: TextAlign.end,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Daily Transactions List
                DayTransactionsList(
                  transactions: dayTransactions.transactions,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
