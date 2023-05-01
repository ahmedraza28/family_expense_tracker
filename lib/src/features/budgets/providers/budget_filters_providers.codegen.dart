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

  BudgetFiltersModel get _filters => state ?? const BudgetFiltersModel();

  void setMonth(int? month) {
    state = _filters.copyWith(month: month, allowNull: true);
  }

  void setYear(int? year) {
    state = _filters.copyWith(year: year, allowNull: true);
  }

  void setCategory(CategoryModel? category) {
    state = _filters.copyWith(categoryId: category?.id, allowNull: true);
  }
}
