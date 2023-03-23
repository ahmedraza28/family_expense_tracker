import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/transaction_filters_model.dart';
import '../models/transaction_model.dart';

// Repositories
import '../repositories/transactions_repository.codegen.dart';

// Features
import '../../books/books.dart';

part 'transactions_provider.codegen.g.dart';

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

  Stream<List<TransactionModel>> getAllTransactions([TransactionFiltersModel? filters]) {
    return _ref.watch(transactionsRepositoryProvider).getBookTransactions(
          bookId: bookId,
          categoryId: filters?.categoryId,
          date: DateTime(
            filters?.year ?? _currentDate.year,
            filters?.month ?? _currentDate.month,
          ),
          incomeExpenseOnly: filters?.incomeExpenseOnly ?? false,
          balanceTransferOnly: filters?.balanceTransferOnly ?? false,
        );
  }
}
