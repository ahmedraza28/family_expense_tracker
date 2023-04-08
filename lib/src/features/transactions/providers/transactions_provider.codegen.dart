import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/daily_transactions_model.dart';
import '../models/transaction_filters_model.dart';
import '../models/transaction_model.dart';

// Providers
import 'transaction_filters_providers.codegen.dart';

// Repositories
import '../repositories/transactions_repository.codegen.dart';

// Features
import '../../books/books.dart';

part 'transactions_provider.codegen.g.dart';

/// A provider used to access stream of filtered transactions
@riverpod
Stream<List<TransactionModel>> filteredTransactionsStream(
  FilteredTransactionsStreamRef ref,
) {
  final filters = ref.read(transactionFiltersProvider);
  return ref.watch(transactionsProvider).getAllTransactions(filters);
}

/// A provider used to access list of searched transactions
@riverpod
Future<List<TransactionModel>> _searchedTransactions(
  _SearchedTransactionsRef ref,
) async {
  final searchTerm = ref.watch(searchFilterProvider).toLowerCase();
  final transactions = await ref.watch(
    filteredTransactionsStreamProvider.future,
  );

  if (searchTerm.isEmpty) {
    return transactions;
  }

  return transactions
      .where((transaction) => transaction.search(searchTerm))
      .toList();
}

/// A provider used to access group transactions by day
@riverpod
Future<Map<int, DailyTransactionsModel>> groupedTransactions(
  GroupedTransactionsRef ref,
) async {
  final transactions = await ref.watch(
    _searchedTransactionsProvider.future,
  );

  final groupedTransactions = <int, List<TransactionModel>>{};

  for (final transaction in transactions) {
    final day = transaction.date.day;
    groupedTransactions[day] ??= [];
    groupedTransactions[day]!.add(transaction);
  }

  return {
    for (final entry in groupedTransactions.entries)
      entry.key: DailyTransactionsModel.fromList(entry.value),
  };
}

/// A provider used to access instance of this service
@riverpod
TransactionsProvider transactions(TransactionsRef ref) {
  final bookId = ref.watch(selectedBookProvider)!.id!;
  return TransactionsProvider(ref, bookId: bookId);
}

class TransactionsProvider {
  final Ref _ref;
  final String bookId;

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
