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

// Screens
import '../screens/add_edit_balance_transfer_screen.dart';

// Features
import '../../shared/shared.dart';
import '../../auth/auth.dart';
import '../../books/books.dart';
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
    final selectedBook = ref.watch(selectedBookProvider)!;
    final myId = ref.watch(currentUserProvider).value!.uid;
    final isViewer = selectedBook.members[myId]!.isViewer;
    return InkWell(
      onTap: isViewer
          ? null
          : () {
              AppRouter.push(
                AddEditBalanceTransferScreen(balanceTransfer: balanceTransfer),
              );
            },
      borderRadius: Corners.rounded15,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: Corners.rounded15,
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Swap icon
            const ShadedIcon(
              color: color,
              padding: EdgeInsets.all(15),
              iconData: Icons.swap_horiz_rounded,
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
                        srcWallet!.name,
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
                        destWallet!.name,
                        color: AppColors.greenColor,
                      ),
                    ],
                  ),

                  // Description
                  if (balanceTransfer.description != null) ...[
                    Insets.gapH5,
                    CustomText.subtitle(
                      balanceTransfer.description!,
                      color: AppColors.textLightGreyColor,
                    ),
                  ]
                ],
              ),
            ),

            // Amount
            Consumer(
              builder: (context, ref, child) {
                final currency = ref.watch(selectedBookCurrencyProvider);
                return CustomText.body(
                  '${currency.symbol} ${balanceTransfer.amount}',
                  color: AppColors.textLightGreyColor,
                  fontSize: 14,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
