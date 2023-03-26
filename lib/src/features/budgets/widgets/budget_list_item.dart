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

class BudgetListItem extends StatelessWidget {
  final BudgetModel budget;

  const BudgetListItem({
    required this.budget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final seed = budget.categoryId;
    final used =
        AppUtils.randomizer(seed).nextInt(budget.amount.toInt()).toDouble();
    final fraction = used / budget.amount;
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: Corners.rounded9,
      ),
      child: Column(
        children: [
          // Name and edit row
          _NameAndEditRow(
            budget: budget,
          ),

          Insets.gapH10,

          // Icon and Budget Usage
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon in a circular progress bar
              Consumer(
                builder: (context, ref, _) {
                  final category = ref.watch(
                    categoryByIdProvider(budget.categoryId),
                  )!;
                  return _CircularProgressIcon(
                    fraction: fraction,
                    iconColor: category.color,
                  );
                },
              ),

              Insets.gapW15,

              // Details column
              Expanded(
                child: _DetailsColumn(
                  total: budget.amount,
                  used: used,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NameAndEditRow extends StatelessWidget {
  const _NameAndEditRow({required this.budget});

  final BudgetModel budget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Category name
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final category = ref.watch(
                categoryByIdProvider(budget.categoryId),
              )!;
              return CustomText.body(
                category.name,
              );
            },
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
    );
  }
}

class _CircularProgressIcon extends StatelessWidget {
  const _CircularProgressIcon({
    required this.fraction,
    required this.iconColor,
  });

  final double fraction;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return RadialProgress(
      progressValue: fraction,
      height: 80,
      showThumb: false,
      width: 80,
      style: PainterStyle(
        strokeWidth: 6,
        startClr: iconColor.withOpacity(0.8),
        endClr: iconColor,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.category_rounded,
          size: 19,
          color: iconColor,
        ),
      ),
    );
  }
}

class _DetailsColumn extends StatelessWidget {
  const _DetailsColumn({
    required this.total,
    required this.used,
  });

  final double total;
  final double used;

  double get fraction => used / total;

  Color get color {
    if (fraction > 0.80) {
      return const Color.fromARGB(255, 242, 0, 0);
    } else if (fraction > 0.60) {
      return const Color.fromARGB(255, 255, 132, 0);
    } else if (fraction > 0.45) {
      return const Color.fromARGB(255, 253, 204, 26);
    } else if (fraction > 0.25) {
      return const Color.fromARGB(255, 11, 161, 19);
    } else {
      return const Color.fromARGB(255, 49, 205, 57);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Total budget
            CustomText.subtitle(
              '\$$total',
              fontWeight: FontWeight.bold,
            ),

            // Percent used
            CustomText.subtitle(
              '${(fraction * 100).toInt()}% budget used',
              color: color,
            ),
          ],
        ),

        Insets.gapH10,

        // Used budget
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Used Label
            CustomText.subtitle(
              'Used',
              color: AppColors.textBlackColor,
            ),

            // Used value
            CustomText.subtitle(
              '- \$$used',
              color: AppColors.textLightGreyColor,
            ),
          ],
        ),

        Insets.gapH10,

        // Remaining budget
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Remaining Label
            CustomText.subtitle(
              'Remaining',
              color: AppColors.textBlackColor,
            ),

            // Remaining value
            CustomText.subtitle(
              '= \$${total - used}',
              color: AppColors.textLightGreyColor,
            )
          ],
        ),
      ],
    );
  }
}
