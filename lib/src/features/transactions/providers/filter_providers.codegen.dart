import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/typedefs.dart';

// Models
import '../models/income_expense_model.codegen.dart';
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

final filtersProvider = Provider<JSON>(
  (ref) {
    final expenseMonthFilter =
        ref.watch(expenseMonthFilterProvider.notifier).state;
    final expenseYearFilter =
        ref.watch(expenseYearFilterProvider.notifier).state;
    final dateFilter = DateTime(
      expenseYearFilter ?? DateTime.now().year,
      expenseMonthFilter ?? DateTime.now().month,
    );
    final categoryFilter = ref.watch(categoryFilterProvider.notifier).state;

    final filters = <String, dynamic>{
      'date': dateFilter,
      'category': categoryFilter?.id,
    };

    return filters;
  },
);

@riverpod
Stream<List<TransactionModel>> filteredTransactions(
  FilteredTransactionsRef ref,
) {
  final queryParams = ref.watch(filtersProvider);
  return ref.watch(transactionsProvider).getAllTransactions(queryParams);
}

/// A provider used to access list of searched expenses
@riverpod
Stream<List<TransactionModel>> searchedTransactions(
  SearchedTransactionsRef ref, {
  required Stream<List<TransactionModel>> filteredTransactions,
}) {
  final searchTerm = ref.watch(searchFilterProvider).toLowerCase();
  if (searchTerm.isEmpty) {
    return filteredTransactions;
  }
  return filteredTransactions.map(
    (transactionsList) => transactionsList
        .where(
          (trans) => trans.search(searchTerm),
        )
        .toList(),
  );
}
