import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/wallet_model.codegen.dart';

// Providers
import '../providers/wallets_provider.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class WalletListItem extends ConsumerWidget {
  final WalletModel wallet;
  final VoidCallback onTap;

  const WalletListItem({
    required this.onTap,
    required this.wallet,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        dense: true,
        horizontalTitleGap: 0,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        tileColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: Corners.rounded15,
        ),
        leading: Icon(
          Icons.wallet_rounded,
          size: 27,
          color: AppUtils.getRandomColor(),
        ),
        trailing: InkWell(
          onTap: () {
            ref.read(editWalletProvider.notifier).update((state) => wallet);
            AppRouter.pushNamed(Routes.AddEditWalletScreenRoute);
          },
          child: const Icon(
            Icons.edit_rounded,
            size: 20,
            color: AppColors.textGreyColor,
          ),
        ),
        subtitle: CustomText.subtitle(
          '${wallet.balance}',
          color: AppColors.textLightGreyColor,
        ),
        title: CustomText.body(
          'Wallet Name',
        ),
      ),
    );
  }
}
