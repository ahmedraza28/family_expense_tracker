import 'package:flutter/material.dart';

// Enums
import '../enums/category_type_enum.dart';

// Widgets
import 'categories_list.dart';

class CategoryTypesTabViews extends StatelessWidget {
  const CategoryTypesTabViews({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: [
        // Income Categories
        CategoriesList(
          categoryType: CategoryType.income,
        ),

        // Expense Categories
        CategoriesList(
          categoryType: CategoryType.expense,
        ),
      ],
    );
  }
}
