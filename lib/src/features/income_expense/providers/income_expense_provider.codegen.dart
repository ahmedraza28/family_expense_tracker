import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/extensions.dart';

// Models
import '../models/income_expense_model.codegen.dart';

// Features
import '../../transactions/transactions.dart';
import '../../books/books.dart';

part 'income_expense_provider.codegen.g.dart';

@riverpod
class IncomeExpense extends _$IncomeExpense {
  @override
  FutureOr<String?> build() => null;

  Future<void> addTransaction({
    required double amount,
    required String walletId,
    required DateTime date,
    required String categoryId,
    required TransactionType type,
    String? description,
  }) async {
    state = const AsyncValue.loading();

    final transaction = IncomeExpenseModel(
      id: AppUtils.generateUuid(),
      amount: amount,
      walletId: walletId,
      categoryId: categoryId,
      date: date,
      type: type,
      description: description,
    );

    final bookId = ref.read(selectedBookProvider)!.id;
    state = await state.makeGuardedRequest(
      () async {
        await ref.read(transactionsRepositoryProvider).addTransaction(
              bookId: bookId,
              month: transaction.date.month,
              transactionId: transaction.id,
              year: transaction.date.year,
              body: transaction.toJson(),
            );
        return 'Transaction added successfully';
      },
      errorMessage: 'Failed to add transaction',
    );
  }

  Future<void> updateTransaction(IncomeExpenseModel transaction) async {
    state = const AsyncValue.loading();

    final bookId = ref.read(selectedBookProvider)!.id;
    state = await state.makeGuardedRequest(
      () async {
        await ref.read(transactionsRepositoryProvider).updateTransaction(
              bookId: bookId,
              month: transaction.date.month,
              year: transaction.date.year,
              transactionId: transaction.id,
              changes: transaction.toJson(),
            );

        return 'Transaction updated successfully';
      },
      errorMessage: 'Failed to update transaction',
    );
  }

  Future<void> deleteTransaction(IncomeExpenseModel transaction) async {
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

        return 'Transaction deleted successfully';
      },
      errorMessage: 'Failed to delete transaction',
    );
  }
}
