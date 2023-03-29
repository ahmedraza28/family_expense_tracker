// ignore_for_file: avoid_positional_boolean_parameters

import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/category_model.codegen.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';

part 'selected_categories_provider.codegen.g.dart';

@riverpod
class SelectedCategories extends _$SelectedCategories {
  @override
  List<CategoryModel> build() {
    ref.delayDispose();
    return const [];
  }

  void addAll(List<CategoryModel> categories) {
    state = [...state, ...categories];
  }

  List<CategoryModel> _add(CategoryModel category) {
    return [...state, category];
  }

  List<CategoryModel> _remove(CategoryModel category) {
    return state.where((e) => e != category).toList();
  }

  void toggle(CategoryModel category, bool isChecked) {
    if (isChecked) {
      state = _add(category);
    } else {
      state = _remove(category);
    }
  }
}
