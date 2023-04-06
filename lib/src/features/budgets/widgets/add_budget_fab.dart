import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/budget_model.codegen.dart';

// Helpers
import '../../../config/routing/routing.dart';
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
        orElse: () => SpeedDial(
          // onPress: onPressed,
          childMargin: const EdgeInsets.only(right: 10),
          animationCurve: Curves.elasticInOut,
          icon: Icons.add_rounded,
          spacing: 10,
          spaceBetweenChildren: 10,
          elevation: 0,
          overlayOpacity: 0.6,
          overlayColor: AppColors.barrierColorLight,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          label: const Text(
            'Create',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add_rounded),
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryColor,
              label: 'New Template',
              onTap: () => AppRouter.pushNamed(Routes.AddEditBudgetScreenRoute),
            ),
            SpeedDialChild(
              child: const Icon(Icons.copy_rounded),
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryColor,
              label: 'Copy Previous',
              onTap: () async {
                final budgets = await AppRouter.pushNamed(
                  Routes.SelectBudgetsScreenRoute,
                ) as List<BudgetModel>;
                ref.read(budgetsProvider.notifier).copyBudgets(budgets);
              },
            ),
          ],
        ),
      ),
    );
  }
}
