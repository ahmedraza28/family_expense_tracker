import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Providers
import '../providers/transactions_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'transaction_list_item.dart';

class TransactionsList extends ConsumerWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsStream = ref.watch(transactionsStreamProvider);
    return transactionsStream.maybeWhen(
      data: (transactions) => ListView.separated(
        itemCount: transactions.length,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        separatorBuilder: (_, __) => Insets.gapH10,
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        itemBuilder: (_, i) {
          return TransactionListItem(
            transaction: transactions[i],
            onTap: () {},
          );
        },
      ),
      orElse: () => const CustomCircularLoader(),
    );
  }
}
