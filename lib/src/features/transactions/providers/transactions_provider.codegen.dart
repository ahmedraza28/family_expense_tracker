import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/daily_transactions_model.dart';
import '../models/grouped_transactions_model.dart';
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
  final bookId = ref.watch(selectedBookProvider.select((value) => value?.id));
  return ref.watch(transactionsProvider).getAllTransactions(bookId, filters);
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
Future<GroupedTransactionsModel> groupedTransactions(
  GroupedTransactionsRef ref,
) async {
  final transactions = await ref.watch(
    _searchedTransactionsProvider.future,
  );

  final groupedTransactions = <int, DailyTransactionsModel>{};
  var totalIncome = 0.0;
  var totalExpenses = 0.0;
  var totalArrears = 0.0;

  for (final transaction in transactions) {
    final day = transaction.date.day;
    groupedTransactions[day] ??= DailyTransactionsModel(
      transactions: [],
      date: transaction.date,
      netTotal: 0,
    );
    groupedTransactions[day]!.addTransaction(transaction);
    if (transaction.isExpense) {
      totalExpenses += transaction.amount;
    } else if (transaction.isIncome) {
      totalIncome += transaction.amount;
    } else if (transaction.isAdjustment) {
      totalArrears += transaction.amount;
    }
  }

  return GroupedTransactionsModel(
    transactions: groupedTransactions,
    totalIncome: totalIncome,
    totalExpenses: totalExpenses,
    totalArrears: totalArrears,
  );
}

/// A provider used to access instance of this service
@riverpod
TransactionsProvider transactions(TransactionsRef ref) {
  return TransactionsProvider(ref);
}

class TransactionsProvider {
  final Ref _ref;

  static final _currentDate = DateTime.now();

  TransactionsProvider(this._ref);

  Stream<List<TransactionModel>> getAllTransactions(
    String? bookId, [
    TransactionFiltersModel? filters,
  ]) {
    return bookId == null
        ? Stream.value([])
        : _ref.read(transactionsRepositoryProvider).getBookTransactions(
              bookId: bookId,
              categoryId: filters?.categoryId,
              year: filters?.year ?? _currentDate.year,
              month: filters?.month ?? _currentDate.month,
              transactionTypes: filters?.types?.map((e) => e.name).toList(),
            );
  }
}
