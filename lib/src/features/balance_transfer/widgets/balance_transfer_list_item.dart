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

// Features
import '../../wallets/wallets.dart';

class BalanceTransferListItem extends ConsumerWidget {
  final BalanceTransferModel balanceTransfer;

  const BalanceTransferListItem({
    required this.balanceTransfer,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const color = Color.fromARGB(255, 149, 165, 173);
    final srcWallet = ref.watch(
      walletByIdProvider(balanceTransfer.srcWalletId),
    );
    final destWallet = ref.watch(
      walletByIdProvider(balanceTransfer.destWalletId),
    );
    return InkWell(
      onTap: () => AppRouter.push(
        AddEditBalanceTransferScreen(balanceTransfer: balanceTransfer),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: Corners.rounded15,
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Category icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: Corners.rounded9,
                color: color.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                size: 20,
                color: color,
              ),
            ),

            Insets.gapW10,

            // Transfer details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    children: [
                      // Src wallet
                      CustomText.body(
                        srcWallet!.name,
                        color: AppColors.redColor,
                        fontSize: 15,
                      ),

                      Insets.gapW3,

                      // Arrow
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: AppColors.textLightGreyColor,
                      ),

                      Insets.gapW3,

                      // Dest wallet
                      CustomText.body(
                        destWallet!.name,
                        fontSize: 15,
                        color: Colors.greenAccent.shade700,
                      ),
                    ],
                  ),

                  // Description
                  if (balanceTransfer.description != null) ...[
                    Insets.gapH3,
                    CustomText.subtitle(
                      balanceTransfer.description!,
                      color: AppColors.textLightGreyColor,
                    ),
                  ]
                ],
              ),
            ),

            // Amount
            CustomText.body(
              '${balanceTransfer.amount}',
              color: AppColors.textLightGreyColor,
              fontSize: 14,
            )
          ],
        ),
      ),
    );
  }
}
