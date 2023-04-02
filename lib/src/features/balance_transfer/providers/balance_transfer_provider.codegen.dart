import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/balance_transfer_model.codegen.dart';

// Features
import '../../transactions/transactions.dart';
import '../../books/books.dart';

part 'balance_transfer_provider.codegen.g.dart';

/// A provider used to access instance of this service
@riverpod
class BalanceTransfer extends _$BalanceTransfer {
  @override
  FutureOr<void> build() => null;

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
    final bookId = ref.watch(selectedBookProvider)!.id!;
    ref.read(transactionsRepositoryProvider).addTransaction(
          bookId: bookId,
          month: transaction.date.month,
          year: transaction.date.year,
          body: transaction.toJson(),
        );
  }

  void updateTransaction(BalanceTransferModel transaction) {
    final bookId = ref.watch(selectedBookProvider)!.id!;
    ref.read(transactionsRepositoryProvider).updateTransaction(
          bookId: bookId,
          month: transaction.date.month,
          year: transaction.date.year,
          transactionId: transaction.id!,
          changes: transaction.toJson(),
        );
  }
}
