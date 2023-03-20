import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/wallet_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../screens/add_edit_wallet_screen.dart';

final isWalletSelectableProvider = StateProvider.autoDispose<bool>(
  name: 'isWalletSelectableProvider',
  (ref) {
    ref.delayDispose();
    return false;
  },
);

class WalletListItem extends ConsumerWidget {
  final WalletModel wallet;

  const WalletListItem({
    required this.wallet,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelectable = ref.watch(isWalletSelectableProvider);
    return ListTile(
      onTap: isSelectable ? () => AppRouter.pop(wallet) : null,
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
      trailing: isSelectable
          ? null
          : InkWell(
              onTap: () => AppRouter.push(
                AddEditWalletScreen(wallet: wallet),
              ),
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
      title: CustomText.body(wallet.name),
    );
  }
}
