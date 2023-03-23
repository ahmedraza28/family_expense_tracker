import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/balance_transfer_model.codegen.dart';

// Features
import '../../transactions/transactions.dart';
import '../../books/books.dart';

part 'balance_transfer_provider.codegen.g.dart';

/// A provider used to access instance of this service
@riverpod
BalanceTransferProvider balanceTransfer(BalanceTransferRef ref) {
  final bookId = ref.watch(selectedBookProvider)!.id!;
  return BalanceTransferProvider(ref, bookId: bookId);
}

class BalanceTransferProvider {
  final Ref _ref;
  final int bookId;

  BalanceTransferProvider(
    this._ref, {
    required this.bookId,
  });

  void addTransaction({
    required double amount,
    required int srcWalletId,
    required int destWalletId,
    required DateTime date,
    String? description,
  }) {
    final transaction = BalanceTransferModel(
      id: null,
      amount: amount,
      srcWalletId: srcWalletId,
      destWalletId: destWalletId,
      date: date,
      description: description,
    );
    _ref
        .read(transactionsRepositoryProvider)
        .addTransaction(bookId: bookId, body: transaction.toJson());
  }

  void updateTransaction(BalanceTransferModel transaction) {
    _ref.read(transactionsRepositoryProvider).updateTransaction(
          bookId: bookId,
          transactionId: transaction.id!,
          changes: transaction.toJson(),
        );
  }
}
