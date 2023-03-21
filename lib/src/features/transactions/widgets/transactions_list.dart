import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/extensions.dart';

// Models
import '../models/income_expense_model.codegen.dart';
import '../models/transaction_model.dart';

// Providers
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
    return AsyncValueWidget<List<TransactionModel>>(
      value: ref.watch(searchedTransactionsProvider),
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
      data: (transactions) {
        return ListView.separated(
          itemCount: transactions.length,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          separatorBuilder: (_, i) {
            final trans = transactions[i];
            final nextTrans = transactions[i + 1];

            if (nextTrans.date.day == trans.date.day) {
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
                trans.date.day < transactions[i - 1].date.day) {
              headerText = trans.date.toDateString('d MMM, y');
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
        );
      },
    );
  }
}
