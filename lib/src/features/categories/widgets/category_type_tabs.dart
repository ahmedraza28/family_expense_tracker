import 'package:flutter/material.dart';

// Enums
import '../enums/category_type_enum.dart';

// Models
import '../models/category_model.codegen.dart';

// Widgets
import 'categories_list.dart';

class CategoryTypesTabs extends StatelessWidget {
  const CategoryTypesTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        // Income Categories
        CategoriesList(
          categories: List.generate(
            10,
            (index) => CategoryModel(
              id: index,
              name: 'Category $index',
              imageUrl: 'assets/icons/food.svg',
              type: CategoryType.income,
            ),
          ),
        ),

        // Expense Categories
        CategoriesList(
          categories: List.generate(
            10,
            (index) => CategoryModel(
              id: index,
              name: 'Category $index',
              imageUrl: 'assets/icons/food.svg',
              type: CategoryType.expense,
            ),
          ),
        ),
      ],
    );
  }
}
