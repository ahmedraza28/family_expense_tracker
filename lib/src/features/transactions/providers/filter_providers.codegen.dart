import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/filters_model.dart';
import '../models/transaction_model.dart';

// Providers
import 'transactions_provider.codegen.dart';

// Features
import '../../categories/categories.dart';

part 'filter_providers.codegen.g.dart';

final searchFilterProvider = StateProvider.autoDispose<String>((ref) => '');
final expenseMonthFilterProvider = StateProvider<int?>((ref) => null);
final expenseYearFilterProvider = StateProvider<int?>((ref) => null);
final categoryFilterProvider = StateProvider<CategoryModel?>((ref) => null);

@riverpod
FiltersModel filters(FiltersRef ref) {
  final expenseMonthFilter =
      ref.watch(expenseMonthFilterProvider.notifier).state;
  final expenseYearFilter = ref.watch(expenseYearFilterProvider.notifier).state;
  final dateFilter = DateTime(
    expenseYearFilter ?? DateTime.now().year,
    expenseMonthFilter ?? DateTime.now().month,
  );
  final categoryFilter = ref.watch(categoryFilterProvider.notifier).state;

  final filters = FiltersModel(
    date: dateFilter,
    categoryId: categoryFilter?.id,
  );

  return filters;
}

@riverpod
Stream<List<TransactionModel>> filteredTransactionsStream(
  FilteredTransactionsStreamRef ref,
) {
  final filters = ref.watch(filtersProvider);
  return ref.watch(transactionsProvider).getAllTransactions(filters);
}

/// A provider used to access list of searched expenses
@riverpod
Future<List<TransactionModel>> searchedTransactions(
  SearchedTransactionsRef ref,
) async {
  final searchTerm = ref.watch(searchFilterProvider).toLowerCase();
  final filteredTransactions =
      await ref.watch(filteredTransactionsStreamProvider.future);
  if (searchTerm.isEmpty) {
    return filteredTransactions;
  }
  return filteredTransactions
      .where((trans) => trans.search(searchTerm))
      .toList();
}
