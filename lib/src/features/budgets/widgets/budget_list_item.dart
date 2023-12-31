import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../../../helpers/extensions/extensions.dart';
import '../../shared/shared.dart';
import '../models/budget_model.codegen.dart';

// Routing
import '../../../config/routing/routing.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Widgets
import '../../../global/widgets/widgets.dart';

// Screens
import '../screens/add_edit_budget_screen.dart';

// Features
import '../../categories/categories.dart';

class BudgetListItem extends StatelessWidget {
  final BudgetModel budget;
  final bool isOwner;

  const BudgetListItem({
    required this.budget,
    required this.isOwner,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = budget.used / budget.amount;
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: Corners.rounded9,
      ),
      child: Column(
        children: [
          // Name and edit row
          _NameAndEditRow(
            budget: budget,
            isOwner: isOwner,
          ),

          Insets.gapH15,

          // Icon and Budget Usage
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon in a circular progress bar
              Consumer(
                builder: (context, ref, _) {
                  final category = ref.watch(
                    categoryByIdProvider(budget.categoryIds.first),
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
                  used: budget.used,
                  isExpense: budget.isExpense,
                ),
              ),
            ],
          ),

          Insets.gapH15,

          const Divider(height: 0),

          // Categories Usage
          Theme(
            data: context.theme.copyWith(
              dividerColor: Colors.transparent,
              listTileTheme: ListTileTheme.of(context).copyWith(dense: true),
            ),
            child: ExpansionTile(
              title: CustomText.subtitle('Categories Usage'),
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 10),
              children: [
                for (final entry in budget.categoriesUsed.entries) ...[
                  Consumer(
                    builder: (context, ref, _) {
                      final category = ref.watch(
                        categoryByIdProvider(entry.key),
                      )!;
                      return Row(
                        children: [
                          // Category icon
                          ShadedIcon(
                            width: 33,
                            height: 33,
                            iconSize: 16,
                            padding: const EdgeInsets.all(4),
                            iconData: Icons.category_rounded,
                            color: category.color,
                          ),

                          Insets.gapW15,

                          // Category name
                          CustomText.subtitle(category.name),

                          Insets.expand,

                          // Category usage
                          CustomText.subtitle(
                            '\$${entry.value}',
                            color: AppColors.textLightGreyColor,
                          ),
                        ],
                      );
                    },
                  ),

                  // Gap between categories
                  if (entry.key != budget.categoriesUsed.entries.last.key)
                    Insets.gapH10,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NameAndEditRow extends StatelessWidget {
  const _NameAndEditRow({
    required this.budget,
    required this.isOwner,
  });

  final bool isOwner;
  final BudgetModel budget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Budget name
        Expanded(
          child: CustomText.body(
            budget.name,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Edit button
        if (isOwner)
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
    required this.isExpense,
  });

  final double total;
  final double used;
  final bool isExpense;

  double get remaining => total - used;
  double get fraction => used / total;

  Color get color {
    final frac = isExpense ? fraction : remaining / total;
    if (frac > 0.80) {
      return const Color.fromARGB(255, 242, 0, 0);
    } else if (frac > 0.60) {
      return const Color.fromARGB(255, 255, 132, 0);
    } else if (frac > 0.45) {
      return const Color.fromARGB(255, 253, 204, 26);
    } else if (frac > 0.25) {
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
              '${(fraction * 100).toInt()}% ${isExpense ? 'used' : 'claimed'}',
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
            ),

            // Remaining value
            CustomText.subtitle(
              '= \$$remaining',
              color: AppColors.textLightGreyColor,
            )
          ],
        ),
      ],
    );
  }
}
