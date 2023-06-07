import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Helpers
import '../../../helpers/constants/constants.dart';

// Providers
import '../models/category_model.codegen.dart';

// Widgets
import 'category_list_item.dart';

// Features
import '../../books/books.dart';

class CategoriesList extends ConsumerWidget {
  final List<CategoryModel> categories;

  const CategoriesList({
    required this.categories,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      itemCount: categories.length,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      separatorBuilder: (_, __) => Insets.gapH10,
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 90),
      itemBuilder: (_, i) => CategoryListItem(
        category: categories[i],
        isOwner: ref.watch(isOwnerSelectedBookProvider),
      ),
    );
  }
}
