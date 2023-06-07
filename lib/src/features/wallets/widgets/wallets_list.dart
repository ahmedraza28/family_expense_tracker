import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/wallet_model.codegen.dart';

// Widgets
import 'wallet_list_item.dart';

// Features
import '../../books/books.dart';

class WalletsList extends ConsumerWidget {
  final List<WalletModel> wallets;

  const WalletsList({
    required this.wallets,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      itemCount: wallets.length,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      separatorBuilder: (_, __) => Insets.gapH10,
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 90),
      itemBuilder: (_, i) {
        return WalletListItem(
          wallet: wallets[i],
          isOwner: ref.watch(isOwnerSelectedBookProvider),
        );
      },
    );
  }
}
