import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/balance_adjustment_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Screens
import '../screens/add_edit_balance_adjustment_screen.dart';

// Features
import '../../shared/shared.dart';
import '../../auth/auth.dart';
import '../../books/books.dart';
import '../../wallets/wallets.dart';

class BalanceAdjustmentListItem extends ConsumerWidget {
  final BalanceAdjustmentModel balanceAdjustment;

  const BalanceAdjustmentListItem({
    required this.balanceAdjustment,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const color = Color.fromARGB(255, 149, 165, 173);
    final wallet = ref.watch(
      walletByIdProvider(balanceAdjustment.walletId),
    );
    final selectedBook = ref.watch(selectedBookProvider)!;
    final myId = ref.watch(currentUserProvider).value!.uid;
    final isViewer = selectedBook.members[myId]!.isViewer;
    return InkWell(
      onTap: isViewer
          ? null
          : () {
              AppRouter.push(
                AddEditBalanceAdjustmentScreen(
                  balanceAdjustment: balanceAdjustment,
                ),
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

            // Adjustment details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  CustomText.body(
                    wallet!.name,
                    color: AppColors.redColor,
                  ),

                  Insets.gapH5,

                  // Details
                  Row(
                    children: [
                      // Src wallet
                      CustomText.body(
                        '${balanceAdjustment.previousAmount}',
                        color: AppColors.textLightGreyColor,
                      ),

                      Insets.gapW5,

                      // Arrow
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 13,
                        color: AppColors.textLightGreyColor,
                      ),

                      Insets.gapW5,

                      // Dest wallet
                      CustomText.body(
                        '${balanceAdjustment.amount}',
                        color: AppColors.textLightGreyColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount
            Consumer(
              builder: (context, ref, child) {
                final currency = ref.watch(selectedBookCurrencyProvider);
                final diff = (balanceAdjustment.previousAmount -
                        balanceAdjustment.amount)
                    .abs();
                final sign = balanceAdjustment.isDecrement ? '-' : '+';
                return CustomText.body(
                  '$sign ${currency.symbol} $diff',
                  color: balanceAdjustment.isDecrement
                      ? AppColors.redColor
                      : AppColors.greenColor,
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
