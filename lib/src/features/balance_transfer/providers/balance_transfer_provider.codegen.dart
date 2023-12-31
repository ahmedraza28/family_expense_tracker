import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/extensions.dart';

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
  FutureOr<String?> build() => null;

  Future<void> addTransaction({
    required double amount,
    required String srcWalletId,
    required String destWalletId,
    required DateTime date,
    String? description,
  }) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(
      () async {
        final transaction = BalanceTransferModel(
          id: AppUtils.generateUuid(),
          amount: amount,
          srcWalletId: srcWalletId,
          destWalletId: destWalletId,
          date: date,
          description: description,
        );
        final bookId = ref.read(selectedBookProvider)!.id;
        await ref.read(transactionsRepositoryProvider).addTransaction(
              bookId: bookId,
              month: date.month,
              year: date.year,
              transactionId: transaction.id,
              body: transaction.toJson(),
            );
            return 'Balance transferred successfully';
      },
      errorMessage: 'Failed to transfer balance',
    );
  }

  Future<void> updateTransaction(BalanceTransferModel transaction) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(
      () async {
        final bookId = ref.read(selectedBookProvider)!.id;
        await ref.read(transactionsRepositoryProvider).updateTransaction(
              bookId: bookId,
              month: transaction.date.month,
              year: transaction.date.year,
              transactionId: transaction.id,
              changes: transaction.toJson(),
            );

            return 'Balance updated successfully';
      },
      errorMessage: 'Failed to update balance transfer',
    );
  }

  Future<void> deleteTransaction(BalanceTransferModel transaction) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(
      () async {
        final bookId = ref.read(selectedBookProvider)!.id;
        await ref.read(transactionsRepositoryProvider).deleteTransaction(
              bookId: bookId,
              month: transaction.date.month,
              year: transaction.date.year,
              transactionId: transaction.id,
            );

            return 'Balance deleted successfully';
      },
      errorMessage: 'Failed to delete balance transfer',
    );
  }
}
