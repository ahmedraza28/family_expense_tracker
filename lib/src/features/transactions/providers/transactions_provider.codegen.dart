import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/typedefs.dart';

// Models
import '../models/transaction_model.codegen.dart';

// Repositories
import '../repositories/transactions_repository.codegen.dart';

// Features
import '../../categories/categories.dart';
import '../../wallets/wallets.dart';
import '../../books/books.dart';

part 'transactions_provider.codegen.g.dart';

final editTransactionProvider =
    StateProvider.autoDispose<TransactionModel?>((_) => null);

final transactionsFutureProvider =
    StreamProvider.autoDispose<List<TransactionModel>>(
  (ref) {
    return ref.watch(transactionsProvider).getAllTransactions();
  },
);

@riverpod
Stream<List<TransactionModel>> transactionsStream(TransactionsStreamRef ref) {
  return ref.watch(transactionsProvider).getAllTransactions();
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

  TransactionsProvider(
    this._ref, {
    required this.bookId,
  });

  Stream<List<TransactionModel>> getAllTransactions([JSON? queryParams]) {
    return _ref.watch(transactionsRepositoryProvider).getBookTransactions(
          bookId: bookId,
          queryParams: queryParams,
        );
  }

  void addTransaction({
    required double amount,
    required WalletModel wallet,
    required DateTime date,
    required CategoryModel category,
    String? description,
  }) {
    final transaction = TransactionModel(
      id: null,
      amount: amount,
      wallet: wallet,
      category: category,
      date: date,
      description: description,
    );
    _ref
        .read(transactionsRepositoryProvider)
        .addTransaction(bookId: bookId, body: transaction.toJson());
  }

  void updateTransaction(TransactionModel transaction) {
    _ref.read(transactionsRepositoryProvider).updateTransaction(
          bookId: bookId,
          transactionId: transaction.id!,
          changes: transaction.toJson(),
        );
  }
}
