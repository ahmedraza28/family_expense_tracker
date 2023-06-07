import 'package:flutter/material.dart';

// Helpers
import '../../../../helpers/constants/constants.dart';

// Providers
import '../../models/category_model.codegen.dart';

// Widgets
import 'selectable_category_list_item.dart';

class SelectableCategoriesList extends StatelessWidget {
  final List<CategoryModel> categories;

  const SelectableCategoriesList({
    required this.categories,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: categories.length,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      separatorBuilder: (_, __) => Insets.gapH10,
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 90),
      itemBuilder: (_, i) => SelectableCategoryListItem(
        category: categories[i],
      ),
    );
  }
}
