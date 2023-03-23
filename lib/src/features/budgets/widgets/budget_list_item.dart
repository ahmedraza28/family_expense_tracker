import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/budget_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import '../screens/add_edit_budget_screen.dart';

// Features
import '../../categories/categories.dart';

class BudgetListItem extends ConsumerWidget {
  final BudgetModel budget;

  const BudgetListItem({
    required this.budget,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(
      categoryByIdProvider(budget.categoryId),
    )!;
    return ListTile(
      dense: true,
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      tileColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: Corners.rounded15,
      ),
      leading: Icon(
        Icons.category_rounded,
        size: 27,
        color: AppUtils.getRandomColor(),
      ),
      trailing: InkWell(
        onTap: () => AppRouter.push(
          AddEditBudgetScreen(budget: budget),
        ),
        child: const Icon(
          Icons.edit_rounded,
          size: 20,
          color: AppColors.textGreyColor,
        ),
      ),
      subtitle: CustomText.subtitle(
        '${budget.amount}',
        color: AppColors.textLightGreyColor,
      ),
      title: CustomText.body(category.name),
    );
  }
}
