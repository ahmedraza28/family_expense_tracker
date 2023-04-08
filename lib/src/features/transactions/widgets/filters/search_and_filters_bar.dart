import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Providers
import '../../providers/transaction_filters_providers.codegen.dart';

// Helpers
import '../../../../helpers/constants/constants.dart';

// Widgets
import '../../../../global/widgets/widgets.dart';
import 'filters_bottom_sheet.dart';

class SearchAndFiltersBar extends ConsumerWidget {
  const SearchAndFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field
          Expanded(
            child: CustomTextField(
              contentPadding: const EdgeInsets.fromLTRB(12, 13, 1, 22),
              onChanged: (searchTerm) => ref
                  .read(searchFilterProvider.notifier)
                  .update((_) => searchTerm ?? ''),
              hintText: 'Search by name',
              hintStyle: const TextStyle(
                color: AppColors.textLightGreyColor,
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.search,
              prefix: const Icon(Icons.search_rounded, size: 22),
            ),
          ),

          Insets.gapW10,

          // Filters Button
          InkWell(
            onTap: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                context: context,
                builder: (context) {
                  return const FiltersBottomSheet();
                },
              );
            },
            child: Container(
              height: 54,
              width: 54,
              decoration: const BoxDecoration(
                color: AppColors.lightBackgroundColor,
                borderRadius: Corners.rounded7,
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  final hasFilters = ref.watch(
                    transactionFiltersProvider.select((value) => value != null),
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
          ),
        ],
      ),
    );
  }
}
