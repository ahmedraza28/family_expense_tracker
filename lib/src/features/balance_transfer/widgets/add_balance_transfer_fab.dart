import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Providers
import '../providers/balance_transfer_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class AddBalanceTransferFab extends ConsumerWidget {
  final VoidCallback onPressed;

  const AddBalanceTransferFab({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      balanceTransferProvider,
      (_, next) => next.whenOrNull(
        data: (_) => AppUtils.showFlushBar(
          context: context,
          message: 'Transfer created successfully',
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green,
        ),
        error: (error, stack) => AppUtils.showFlushBar(
          context: context,
          message: error.toString(),
          iconColor: Colors.red,
        ),
      ),
    );
    final transactionFuture = ref.watch(balanceTransferProvider);
    return SizedBox(
      height: 55,
      width: 140,
      child: transactionFuture.maybeWhen(
        loading: () => const CustomCircularLoader(
          color: Colors.white,
        ),
        orElse: () => FloatingActionButton.extended(
          elevation: 0,
          hoverElevation: 0,
          hoverColor: Colors.black12,
          backgroundColor: AppColors.primaryColor,
          heroTag: 'balanceTransfer',
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomLeft: Radius.circular(50),
            ),
          ),
          onPressed: onPressed,
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              // Add icon
              Icon(
                Icons.swap_horiz_rounded,
                color: Colors.white,
              ),

              Insets.gapW5,

              // Label
              Text(
                'Transfer',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
