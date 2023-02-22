import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/wallet_model.codegen.dart';

// Widgets
import 'wallet_list_item.dart';

class WalletsList extends StatelessWidget {
  const WalletsList({super.key});

  @override
  Widget build(BuildContext context) {
    final wallets = <WalletModel>[];
    return ListView.separated(
      itemCount: wallets.length,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      separatorBuilder: (_, __) => Insets.gapH10,
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      itemBuilder: (_, i) {
        return WalletListItem(
          wallet: wallets[i],
          onTap: () {},
        );
      },
    );
  }
}
