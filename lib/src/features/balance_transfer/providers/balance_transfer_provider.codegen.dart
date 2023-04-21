// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../../../helpers/extensions/extensions.dart';

// Models
import '../models/balance_transfer_model.codegen.dart';

// Features
import '../../wallets/wallets.dart';
import '../../transactions/transactions.dart';
import '../../books/books.dart';

part 'balance_transfer_provider.codegen.g.dart';

/// A provider used to access instance of this service
@riverpod
class BalanceTransfer extends _$BalanceTransfer {
  @override
  FutureOr<void> build() => null;

  Future<void> addTransaction({
    required double amount,
    required int srcWalletId,
    required int destWalletId,
    required DateTime date,
    String? description,
  }) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(
      () {
        final transaction = BalanceTransferModel(
          id: null,
          amount: amount,
          srcWalletId: srcWalletId,
          destWalletId: destWalletId,
          date: date,
          description: description,
        );
        final bookId = ref.watch(selectedBookProvider)!.id!;
        return ref.read(transactionsRepositoryProvider).addTransaction(
              bookId: bookId,
              month: transaction.date.month,
              year: transaction.date.year,
              body: transaction.toJson(),
            );
      },
      errorMessage: 'Failed to transfer balance',
    );
  }

  Future<void> updateTransaction(BalanceTransferModel transaction) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(
      () {
        final bookId = ref.watch(selectedBookProvider)!.id!;
        return ref.read(transactionsRepositoryProvider).updateTransaction(
              bookId: bookId,
              month: transaction.date.month,
              year: transaction.date.year,
              transactionId: transaction.id!,
              changes: transaction.toJson(),
            );
      },
      errorMessage: 'Failed to update balance transfer',
    );
  }

  Future<void> deleteTransaction(BalanceTransferModel transaction) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(
      () {
        final bookId = ref.watch(selectedBookProvider)!.id!;
        final srcWallet = ref.watch(
          walletByIdProvider(transaction.srcWalletId),
        )!;
        final destWallet = ref.watch(
          walletByIdProvider(transaction.destWalletId),
        )!;
        return ref.read(transactionsRepositoryProvider).deleteTransfer(
              bookId: bookId,
              transaction: transaction,
              srcWallet: srcWallet,
              destWallet: destWallet,
            );
      },
      errorMessage: 'Failed to delete balance transfer',
    );
  }
}
