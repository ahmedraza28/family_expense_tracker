import 'package:flutter/material.dart';

// Models
import '../models/wallet_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class WalletListItem extends StatelessWidget {
  final WalletModel? wallet;
  final VoidCallback onTap;

  const WalletListItem({
    required this.onTap,
    super.key,
    this.wallet,
  });

  @override
  Widget build(BuildContext context) {
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
            AppRouter.pushNamed(Routes.AddEditWalletScreenRoute);
          },
          child: const Icon(
            Icons.edit_rounded,
            size: 20,
            color: AppColors.textGreyColor,
          ),
        ),
        subtitle: CustomText.subtitle(
          '${wallet!.balance}',
          color: AppColors.textLightGreyColor,
        ),
        title: CustomText.body(
          'Wallet Name',
        ),
      ),
    );
  }
}
