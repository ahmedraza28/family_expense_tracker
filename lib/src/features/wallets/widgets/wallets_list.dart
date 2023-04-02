import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Providers
import '../providers/wallets_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'wallet_list_item.dart';

// Features
import '../../books/books.dart';

class WalletsList extends ConsumerWidget {
  const WalletsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsStream = ref.watch(walletsStreamProvider);
    return walletsStream.maybeWhen(
      data: (wallets) => ListView.separated(
        itemCount: wallets.length,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        separatorBuilder: (_, __) => Insets.gapH10,
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        itemBuilder: (_, i) {
          return WalletListItem(
            wallet: wallets[i],
            isOwner: ref.watch(isOwnerSelectedBookProvider),
          );
        },
      ),
      orElse: () => const CustomCircularLoader(),
    );
  }
}
