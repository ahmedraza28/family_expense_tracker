import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../../../helpers/extensions/datetime_extension.dart';
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
        title: 'No transactions recorded yet',
        subtitle: 'Check back later',
      ),
      data: (transactions) => ListView.separated(
        itemCount: transactions.length,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        separatorBuilder: (_, i) {
          final trans = transactions[i];
          final nextTrans = transactions[i + 1];

          if (nextTrans.transDate.day == trans.transDate.day) {
            return const SizedBox(
              height: 10,
              child: VerticalDivider(
                width: 2,
                thickness: 1.5,
                color: AppColors.textLightGreyColor,
              ),
            );
          }
          return Insets.gapH10;
        },
        itemBuilder: (_, i) {
          final trans = transactions[i];
          String? headerText;

          if (i == 0 ||
              trans.transDate.day < transactions[i - 1].transDate.day) {
            headerText = trans.transDate.toDateString('d MMM, y');
          }

          final child = trans.isBalanceTransfer
              ? BalanceTransferListItem(
                  balanceTransfer: trans as BalanceTransferModel,
                )
              : IncomeExpenseListItem(
                  transaction: trans as IncomeExpenseModel,
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
      ),
    );
  }
}
