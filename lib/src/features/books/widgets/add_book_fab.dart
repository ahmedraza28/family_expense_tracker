import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Providers
import '../providers/books_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class AddBookFab extends ConsumerWidget {
  final VoidCallback onPressed;

  const AddBookFab({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      booksProvider,
      (_, next) => next.whenOrNull(
        data: (message) => AppUtils.showFlushBar(
          context: context,
          message: message ?? 'Book operation completed',
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green,
        ),
        error: (reason, st) => AppUtils.showFlushBar(
          context: context,
          message: reason as String,
        ),
      ),
    );
    final booksFuture = ref.watch(booksProvider);
    return SizedBox(
      height: 55,
      width: 149,
      child: booksFuture.maybeWhen(
        loading: () => const CustomCircularLoader(
          size: 25,
          color: Colors.white,
        ),
        orElse: () => FloatingActionButton.extended(
          elevation: 0,
          hoverElevation: 0,
          hoverColor: Colors.black12,
          backgroundColor: AppColors.primaryColor,
          heroTag: 'addBook',
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          onPressed: onPressed,
          label: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
