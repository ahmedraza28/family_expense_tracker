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
    const color = Color.fromARGB(255, 149, 165, 173);
    return InkWell(
      onTap: () => AppRouter.push(
        AddEditBalanceTransferScreen(balanceTransfer: balanceTransfer),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: Corners.rounded15,
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Category icon
            Container(
              padding: const EdgeInsets.all(10),
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

            Insets.gapW15,

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
                        balanceTransfer.srcWallet.name,
                        color: AppColors.redColor,
                      ),

                      Insets.gapW5,

                      // Arrow
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: AppColors.textLightGreyColor,
                      ),

                      Insets.gapW5,

                      // Dest wallet
                      CustomText.body(
                        balanceTransfer.destWallet.name,
                        color: Colors.greenAccent.shade700,
                      ),
                    ],
                  ),

                  // Category Name
                  CustomText.subtitle(
                    balanceTransfer.note ?? '',
                    color: AppColors.textLightGreyColor,
                  ),
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
