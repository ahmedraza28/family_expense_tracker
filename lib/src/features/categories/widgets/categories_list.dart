import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Enums
import '../enums/category_type_enum.dart';

// Providers
import '../providers/categories_provider.codegen.dart';

// Widgets
import '../../../global/widgets/widgets.dart';
import 'category_list_item.dart';

class CategoriesList extends ConsumerWidget {
  final CategoryType categoryType;

  const CategoriesList({
    required this.categoryType,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesStream = ref.watch(categoriesByTypeProvider(categoryType));
    return categoriesStream.maybeWhen(
      data: (categories) => ListView.separated(
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        separatorBuilder: (_, __) => Insets.gapH10,
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        itemBuilder: (_, i) => CategoryListItem(
          category: categories[i],
        ),
      ),
      orElse: () => const CustomCircularLoader(),
    );
  }
}
