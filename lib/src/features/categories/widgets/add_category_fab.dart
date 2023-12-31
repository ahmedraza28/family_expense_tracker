import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Providers
import '../providers/categories_provider.codegen.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class AddCategoryFab extends ConsumerWidget {
  final VoidCallback onPressed;

  const AddCategoryFab({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      categoriesProvider,
      (_, next) => next.whenOrNull(
        data: (message) => AppUtils.showFlushBar(
          context: context,
          message: message ?? 'Category operation completed',
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green,
        ),
        error: (reason, st) => AppUtils.showFlushBar(
          context: context,
          message: reason as String,
        ),
      ),
    );
    final categoryFuture = ref.watch(categoriesProvider);
    return SizedBox(
      height: 55,
      width: 140,
      child: categoryFuture.maybeWhen(
        loading: () => const CustomCircularLoader(
          color: Colors.white,
        ),
        orElse: () => FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
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
