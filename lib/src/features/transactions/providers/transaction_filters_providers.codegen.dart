import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/transaction_filters_model.dart';
import '../models/transaction_model.dart';

// Providers
import 'transactions_provider.codegen.dart';

// Features
import '../../categories/categories.dart';

part 'transaction_filters_providers.codegen.g.dart';

final searchFilterProvider = StateProvider.autoDispose<String>(
  name: 'searchFilterProvider',
  (ref) => '',
);
final expenseMonthFilterProvider = StateProvider.autoDispose<int?>(
  name: 'expenseMonthFilterProvider',
  (ref) => null,
);
final expenseYearFilterProvider = StateProvider.autoDispose<int?>(
  name: 'expenseYearFilterProvider',
  (ref) => null,
);
final categoryFilterProvider = StateProvider.autoDispose<CategoryModel?>(
  name: 'categoryFilterProvider',
  (ref) => null,
);
final balanceTransferOnlyFilterProvider = StateProvider.autoDispose<bool>(
  name: 'balanceTransferOnlyFilterProvider',
  (ref) => false,
);
final incomeExpenseOnlyFilterProvider = StateProvider.autoDispose<bool>(
  name: 'incomeExpenseOnlyFilterProvider',
  (ref) => false,
);

/// A map of month names and number
const monthNames = {
  'January': 1,
  'February': 2,
  'March': 3,
  'April': 4,
  'May': 5,
  'June': 6,
  'July': 7,
  'August': 8,
  'September': 9,
  'October': 10,
  'November': 11,
  'December': 12,
};

@riverpod
TransactionFiltersModel? transactionFilters(TransactionFiltersRef ref) {
  final expenseMonthFilter =
      ref.watch(expenseMonthFilterProvider.notifier).state;
  final expenseYearFilter = ref.watch(expenseYearFilterProvider.notifier).state;
  final categoryFilter = ref.watch(categoryFilterProvider.notifier).state;
  final ieOnly = ref.watch(incomeExpenseOnlyFilterProvider.notifier).state;
  final btOnly = ref.watch(balanceTransferOnlyFilterProvider.notifier).state;

  if (expenseMonthFilter == null &&
      expenseYearFilter == null &&
      categoryFilter == null) {
    return null;
  }

  final filters = TransactionFiltersModel(
    incomeExpenseOnly: ieOnly,
    balanceTransferOnly: btOnly,
    year: expenseYearFilter,
    month: expenseMonthFilter,
    categoryId: categoryFilter?.id,
  );

  return filters;
}

@riverpod
Stream<List<TransactionModel>> filteredTransactionsStream(
  FilteredTransactionsStreamRef ref,
) {
  final filters = ref.watch(transactionFiltersProvider);
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
