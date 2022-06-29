import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Controllers
// States
// Helpers
import '../../../helpers/constants/app_assets.dart';
import '../../../helpers/constants/app_colors.dart';
import '../../../helpers/constants/app_styles.dart';

// Widgets

class AddBookFab extends ConsumerWidget {
  final VoidCallback onPressed;

  const AddBookFab({
    super.key,
    required this.onPressed,
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
      width: 125,
      child: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        onPressed: onPressed,
        label: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Hangout Icon
            Image.asset(
              AppAssets.maleStudent,
              height: 20,
              width: 20,
            ),

            Insets.gapW10,

            // Label
            const Text(
              'Create',
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
