import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/transaction_filters_model.dart';
import '../models/transaction_model.dart';

// Providers
import 'transaction_filters_providers.codegen.dart';

// Repositories
import '../repositories/transactions_repository.codegen.dart';

// Features
import '../../books/books.dart';

part 'transactions_provider.codegen.g.dart';

@riverpod
Stream<List<TransactionModel>> filteredTransactionsStream(
  FilteredTransactionsStreamRef ref,
) {
  final filters = ref.read(transactionFiltersProvider);
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

/// A provider used to access instance of this service
@riverpod
TransactionsProvider transactions(TransactionsRef ref) {
  final bookId = ref.watch(selectedBookProvider)!.id!;
  return TransactionsProvider(ref, bookId: bookId);
}

class TransactionsProvider {
  final Ref _ref;
  final int bookId;

  static final _currentDate = DateTime.now();

  TransactionsProvider(
    this._ref, {
    required this.bookId,
  });

  Stream<List<TransactionModel>> getAllTransactions([
    TransactionFiltersModel? filters,
  ]) {
    return _ref.watch(transactionsRepositoryProvider).getBookTransactions(
          bookId: bookId,
          categoryId: filters?.categoryId,
          year: filters?.year ?? _currentDate.year,
          month: filters?.month ?? _currentDate.month,
          transactionTypes: filters?.types?.map((e) => e.name).toList(),
        );
  }
}
