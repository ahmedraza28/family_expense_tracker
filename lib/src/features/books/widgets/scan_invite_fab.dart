import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/extensions.dart';

// Providers
import '../providers/books_provider.codegen.dart';

// Screens
import '../screens/books_view.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class ScanInviteFab extends ConsumerWidget {
  final VoidCallback onPressed;

  const ScanInviteFab({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      booksProvider,
      (_, next) => next.whenOrNull(
        data: (message) {
          ref
              .read(currentBooksViewTabProvider.notifier)
              .update((_) => BooksViewTabs.shared);
          AppUtils.showFlushBar(
            context: context,
            message: message ?? 'Book saved successfully',
            visibleDuration: 3.seconds,
            icon: Icons.check_circle_rounded,
            iconColor: Colors.green,
          );
        },
        error: (error, stack) => AppUtils.showFlushBar(
          context: context,
          message: error.toString(),
          iconColor: Colors.red,
        ),
      ),
    );
    final stateFuture = ref.watch(booksProvider);
    return SizedBox(
      height: 55,
      width: 149,
      child: stateFuture.maybeWhen(
        loading: () => const CustomCircularLoader(
          size: 25,
          color: Colors.white,
        ),
        orElse: () => FloatingActionButton.extended(
          elevation: 0,
          hoverElevation: 0,
          hoverColor: Colors.black12,
          backgroundColor: AppColors.primaryColor,
          heroTag: 'scanInvite',
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomLeft: Radius.circular(50),
            ),
          ),
          onPressed: onPressed,
          label: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Add icon
              Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
              ),

              Insets.gapW5,

              // Label
              Text(
                'Scan Invite',
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
