import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

class AddTransactionFab extends ConsumerWidget {
  final VoidCallback onPressed;

  const AddTransactionFab({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen<FutureState<String>>(
    //   profileHangoutProvider,
    //   (_, next) => next.whenOrNull(
    //     data: (message) => AppUtils.showFlushBar(
    //       context: context,
    //       message: message,
    //       icon: Icons.check_circle_rounded,
    //       iconColor: Colors.green,
    //     ),
    //     failed: (reason) => AppUtils.showFlushBar(
    //       context: context,
    //       message: reason,
    //     ),
    //   ),
    // );
    // final hangoutFuture = ref.watch(profileHangoutProvider);
    return SizedBox(
      height: 55,
      width: 140,
      child: FloatingActionButton.extended(
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
    );
  }
}
