import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/transaction_model.codegen.dart';

// Widgets
import 'transaction_list_item.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = <TransactionModel>[];
    return ListView.separated(
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
    );
  }
}
