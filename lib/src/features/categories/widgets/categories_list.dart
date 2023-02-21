import 'package:flutter/material.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Models
import '../models/category_model.codegen.dart';

// Widgets
import 'category_list_item.dart';

class CategoriesList extends StatelessWidget {
  final List<CategoryModel> categories;

  const CategoriesList({
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
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      itemBuilder: (_, i) {
        return CategoryListItem(
          category: categories[i],
          onTap: () {},
        );
      },
    );
  }
}
