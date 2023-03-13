import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/balance_transfer_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../screens/add_edit_balance_transfer_screen.dart';

class BalanceTransferListItem extends ConsumerWidget {
  final BalanceTransferModel balanceTransfer;

  const BalanceTransferListItem({
    required this.balanceTransfer,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
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
      leading: const Icon(
        Icons.swap_horiz_rounded,
        color: AppColors.textLightGreyColor,
      ),
      trailing: InkWell(
        onTap: () => AppRouter.push(
          AddEditBalanceTransferScreen(balanceTransfer: balanceTransfer),
        ),
        child: const Icon(
          Icons.edit_rounded,
          size: 20,
          color: AppColors.primaryColor,
        ),
      ),
      title: CustomText.body(
        '${balanceTransfer.srcWallet.name} -> ${balanceTransfer.destWallet.name}',
      ),
      subtitle: CustomText.subtitle(
        '${balanceTransfer.amount}',
      ),
    );
  }
}
