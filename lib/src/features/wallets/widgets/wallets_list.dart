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
    const wallets = [
      WalletModel(
        id: 1,
        name: 'Wallet 1',
        imageUrl: 'https://picsum.photos/200/300',
        balance: 200000,
      ),
      WalletModel(
        id: 2,
        name: 'Wallet 2',
        imageUrl: 'https://picsum.photos/200/300',
        balance: 200000,
      ),
      WalletModel(
        id: 3,
        name: 'Wallet 3',
        imageUrl: 'https://picsum.photos/200/300',
        balance: 200000,
      ),
      WalletModel(
        id: 4,
        name: 'Wallet 4',
        imageUrl: 'https://picsum.photos/200/300',
        balance: 200000,
      ),
    ];
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
