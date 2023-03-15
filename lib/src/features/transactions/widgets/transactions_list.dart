import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/income_expense_model.codegen.dart';

// Providers
import '../models/transaction_model.dart';
import '../providers/filter_providers.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'income_expense_list_item.dart';

// Features
import '../../balance_transfer/balance_transfer.dart';

class TransactionsList extends ConsumerWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsStream = ref.watch(filteredTransactionsStreamProvider);
    return AsyncValueWidget<List<TransactionModel>>(
      value: transactionsStream,
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
        title: 'No transactions recoreded yet',
        subtitle: 'Check back later',
      ),
      data: (transactions) => ListView.separated(
        itemCount: transactions.length,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        separatorBuilder: (_, __) => Insets.gapH10,
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        itemBuilder: (_, i) {
          final trans = transactions[i];

          return trans.isBalanceTransfer
              ? BalanceTransferListItem(
                  balanceTransfer: trans as BalanceTransferModel,
                )
              : IncomeExpenseListItem(
                  transaction: trans as IncomeExpenseModel,
                );
        },
      ),
    );
  }
}
