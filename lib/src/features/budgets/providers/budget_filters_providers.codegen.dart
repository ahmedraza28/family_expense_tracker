import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/budget_filters_model.dart';

// Features
import '../../categories/categories.dart';

part 'budget_filters_providers.codegen.g.dart';

@riverpod
class BudgetFilters extends _$BudgetFilters {
  @override
  BudgetFiltersModel? build() => null;

  BudgetFiltersModel get filters => state ?? const BudgetFiltersModel();

  void setMonth(int? month) {
    state = filters.copyWith(month: month);
  }

  void setYear(int? year) {
    state = filters.copyWith(year: year);
  }

  void setCategory(CategoryModel? category) {
    state = filters.copyWith(categoryId: category?.id);
  }

  void clear() {
    state = const BudgetFiltersModel();
  }
}
