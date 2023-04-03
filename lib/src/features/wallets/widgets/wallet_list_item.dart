import 'package:flutter/material.dart';

// Models
import '../models/wallet_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Screens
import '../screens/add_edit_wallet_screen.dart';

// Features
import '../../shared/shared.dart';

class WalletListItem extends StatelessWidget {
  final WalletModel wallet;
  final bool isOwner;

  const WalletListItem({
    required this.wallet,
    required this.isOwner,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: Corners.rounded15,
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          // Category icon
          ShadedIcon(
            color: wallet.color,
            iconData: Icons.wallet_rounded,
          ),

          Insets.gapW10,

          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                CustomText.body(
                  wallet.name,
                  fontSize: 15,
                ),

                Insets.gapH3,

                // Balance
                CustomText.subtitle(
                  '${wallet.balance}',
                  color: AppColors.textLightGreyColor,
                ),
              ],
            ),
          ),

          if (isOwner) ...[
            Insets.gapW10,

            // Edit
            InkWell(
              onTap: () => AppRouter.push(
                AddEditWalletScreen(wallet: wallet),
              ),
              child: const Icon(
                Icons.edit_rounded,
                size: 18,
                color: AppColors.textGreyColor,
              ),
            ),

            Insets.gapW3,
          ]
        ],
      ),
    );
  }
}
