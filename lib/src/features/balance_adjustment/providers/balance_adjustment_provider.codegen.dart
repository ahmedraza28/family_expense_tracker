import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';

// Models
import '../models/balance_adjustment_model.codegen.dart';

// Features
import '../../transactions/transactions.dart';
import '../../books/books.dart';

part 'balance_adjustment_provider.codegen.g.dart';

/// A provider used to access instance of this service
@riverpod
class BalanceAdjustment extends _$BalanceAdjustment {
  @override
  FutureOr<void> build() => null;

  Future<void> addTransaction({
    required double amount,
    required double prevAmount,
    required int walletId,
    required DateTime date,
  }) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(() {
      final transaction = BalanceAdjustmentModel(
        id: null,
        amount: amount,
        previousAmount: prevAmount,
        walletId: walletId,
        date: date,
      );
      final bookId = ref.read(selectedBookProvider)!.id!;
      return ref.read(transactionsRepositoryProvider).addTransaction(
            bookId: bookId,
            month: date.month,
            year: date.year,
            body: transaction.toJson(),
          );
    });
  }

  Future<void> deleteTransaction(BalanceAdjustmentModel transaction) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(() {
      final bookId = ref.read(selectedBookProvider)!.id!;
      return ref.read(transactionsRepositoryProvider).deleteTransaction(
            bookId: bookId,
            month: transaction.date.month,
            year: transaction.date.year,
            transactionId: transaction.id!,
          );
    });
  }
}
