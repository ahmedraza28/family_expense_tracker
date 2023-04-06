import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../../helpers/constants/constants.dart';

// Providers
import '../../providers/budget_filters_providers.codegen.dart';

// Widgets
import 'filters_bottom_sheet.dart';

class FiltersButton extends StatelessWidget {
  const FiltersButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          showModalBottomSheet<dynamic>(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            context: context,
            builder: (context) => const FiltersBottomSheet(),
          );
        },
        child: Consumer(
          builder: (context, ref, child) {
            final hasFilters = ref.watch(
              budgetFiltersProvider.select((value) => value != null),
            );
            return Icon(
              Icons.tune_rounded,
              color: hasFilters
                  ? AppColors.primaryColor
                  : AppColors.textLightGreyColor,
            );
          },
        ),
      ),
    );
  }
}
