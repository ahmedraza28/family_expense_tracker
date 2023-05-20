import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Providers
import '../providers/wallets_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class AddWalletFab extends ConsumerWidget {
  final VoidCallback onPressed;

  const AddWalletFab({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      walletsProvider,
      (_, next) => next.whenOrNull(
        data: (message) => AppUtils.showFlushBar(
          context: context,
          message: message ?? 'Wallet operation completed',
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green,
        ),
        error: (reason, st) => AppUtils.showFlushBar(
          context: context,
          message: reason as String,
        ),
      ),
    );
    final walletsFuture = ref.watch(walletsProvider);
    return SizedBox(
      height: 55,
      width: 140,
      child: walletsFuture.maybeWhen(
        loading: () => const CustomCircularLoader(
          color: Colors.white,
        ),
        orElse: () => FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          onPressed: onPressed,
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              // Add icon
              Icon(
                Icons.add,
                color: Colors.white,
              ),

              Insets.gapW5,

              // Label
              Text(
                'Create New',
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
