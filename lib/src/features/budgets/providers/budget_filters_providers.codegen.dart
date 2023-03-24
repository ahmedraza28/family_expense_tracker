import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/budget_filters_model.dart';
import '../models/budget_model.codegen.dart';

// Providers
import 'budgets_provider.codegen.dart';

// Features
import '../../categories/categories.dart';

part 'budget_filters_providers.codegen.g.dart';

final budgetMonthFilterProvider = StateProvider.autoDispose<int?>(
  name: 'budgetMonthFilterProvider',
  (ref) => null,
);
final budgetYearFilterProvider = StateProvider.autoDispose<int?>(
  name: 'budgetYearFilterProvider',
  (ref) => null,
);
final budgetCategoryFilterProvider = StateProvider.autoDispose<CategoryModel?>(
  name: 'budgetCategoryFilterProvider',
  (ref) => null,
);

@riverpod
BudgetFiltersModel? budgetFilters(BudgetFiltersRef ref) {
  final budgetMonthFilter = ref.watch(budgetMonthFilterProvider.notifier).state;
  final budgetYearFilter = ref.watch(budgetYearFilterProvider.notifier).state;
  final budgetCategoryFilter =
      ref.watch(budgetCategoryFilterProvider.notifier).state;

  if (budgetMonthFilter == null &&
      budgetYearFilter == null &&
      budgetCategoryFilter == null) {
    return null;
  }

  final filters = BudgetFiltersModel(
    year: budgetYearFilter,
    month: budgetMonthFilter,
    categoryId: budgetCategoryFilter?.id,
  );

  return filters;
}

@riverpod
Stream<List<BudgetModel>> filteredBudgetsStream(
  FilteredBudgetsStreamRef ref,
) {
  final filters = ref.watch(budgetFiltersProvider);
  return ref.watch(budgetsProvider.notifier).getAllBudgets(filters);
}
