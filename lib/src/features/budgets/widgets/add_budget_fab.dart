import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Providers
import '../providers/budgets_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

class AddBudgetFab extends ConsumerWidget {
  final VoidCallback onPressed;

  const AddBudgetFab({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      budgetsProvider,
      (_, next) => next.whenOrNull(
        data: (_) => AppUtils.showFlushBar(
          context: context,
          message: 'Budget saved successfully',
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green,
        ),
        error: (error, stack) => AppUtils.showFlushBar(
          context: context,
          message: error.toString(),
        ),
      ),
    );
    final budgetFuture = ref.watch(budgetsProvider);
    return SizedBox(
      height: 55,
      width: 140,
      child: budgetFuture.maybeWhen(
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
