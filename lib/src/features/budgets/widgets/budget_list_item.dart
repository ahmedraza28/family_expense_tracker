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
    final seed = budget.categoryId;
    final color = AppUtils.getRandomColor(seed);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: Corners.rounded9,
      ),
      child: Column(
        children: [
          // Name and edit row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Category name
              Expanded(
                child: CustomText.body(
                  category.name,
                  fontSize: 15,
                ),
              ),

              // Edit button
              InkWell(
                onTap: () => AppRouter.push(
                  AddEditBudgetScreen(budget: budget),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  size: 16,
                  color: AppColors.textGreyColor,
                ),
              ),
            ],
          ),

          Insets.gapH10,

          // Icon and Bar Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: Corners.rounded10,
                  color: color.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.category_rounded,
                  size: 20,
                  color: color,
                ),
              ),

              Insets.gapW15,

              // Budget usage bar
              Expanded(
                child: _BudgetUsageBar(
                  total: budget.amount,
                  used: AppUtils.randomizer()
                      .nextInt(budget.amount.toInt())
                      .toDouble(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BudgetUsageBar extends StatelessWidget {
  final double total;
  final double used;

  const _BudgetUsageBar({
    required this.total,
    required this.used,
  });

  Color get color {
    final fraction = used / total;
    if (fraction > 0.8) {
      return const Color(0xFFed0000);
    } else if (fraction > 0.6) {
      return const Color.fromARGB(255, 255, 149, 0);
    } else if (fraction > 0.45) {
      return const Color.fromARGB(255, 255, 214, 64);
    } else {
      return const Color.fromARGB(255, 49, 205, 57);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final usedWidth = width * (used / total);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Bugdet usage bar
            Container(
              height: 20,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.lightOutlineColor,
                borderRadius: Corners.rounded7,
              ),
              child: Row(
                children: [
                  // Bar with a glow
                  Container(
                    height: 20,
                    width: usedWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: Corners.rounded7,
                      boxShadow: [
                        // Slight glow
                        BoxShadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomText.label(
                        '\$$used',
                        color: AppColors.textWhite80Color,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Insets.gapH10,

            // Total budget
            CustomText.subtitle(
              '\$$total',
              color: AppColors.textGreyColor,
            ),
          ],
        );
      },
    );
  }
}
