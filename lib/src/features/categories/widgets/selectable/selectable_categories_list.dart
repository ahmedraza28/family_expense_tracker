import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../../helpers/constants/constants.dart';

// Providers
import '../../providers/categories_provider.codegen.dart';

// Widgets
import '../../../../global/widgets/widgets.dart';
import 'selectable_category_list_item.dart';

class SelectableCategoriesList extends ConsumerWidget {
  const SelectableCategoriesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesStream = ref.watch(categoriesStreamProvider);
    return categoriesStream.maybeWhen(
      data: (categories) => ListView.separated(
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        separatorBuilder: (_, __) => Insets.gapH10,
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        itemBuilder: (_, i) => SelectableCategoryListItem(
          category: categories[i],
        ),
      ),
      orElse: () => const CustomCircularLoader(),
    );
  }
}