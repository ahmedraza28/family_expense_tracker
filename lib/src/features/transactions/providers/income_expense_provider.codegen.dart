import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';
import '../enums/transaction_type_enum.dart';

// Models
import '../models/income_expense_model.codegen.dart';

// Repositories
import '../repositories/transactions_repository.codegen.dart';

// Features
import '../../categories/categories.dart';
import '../../wallets/wallets.dart';
import '../../books/books.dart';

part 'income_expense_provider.codegen.g.dart';

@riverpod
class IncomeExpense extends _$IncomeExpense {
  @override
  FutureOr<void> build() => null;

  Future<void> addTransaction({
    required double amount,
    required WalletModel wallet,
    required DateTime date,
    required CategoryModel category,
    required TransactionType type,
    String? description,
  }) async {
    state = const AsyncValue.loading();

    final transaction = IncomeExpenseModel(
      id: null,
      amount: amount,
      walletId: wallet.id!,
      categoryId: category.id!,
      date: date,
      type: type,
      description: description,
    );

    final bookId = ref.watch(selectedBookProvider)!.id!;
    state = await state.makeGuardedRequest(
      () => ref
          .read(transactionsRepositoryProvider)
          .addTransaction(bookId: bookId, body: transaction.toJson()),
      errorMessage: 'Failed to add transaction',
    );
  }

  Future<void> updateTransaction(IncomeExpenseModel transaction) async {
    state = const AsyncValue.loading();

    final bookId = ref.watch(selectedBookProvider)!.id!;
    state = await state.makeGuardedRequest(
      () => ref.read(transactionsRepositoryProvider).updateTransaction(
            bookId: bookId,
            transactionId: transaction.id!,
            changes: transaction.toJson(),
          ),
      errorMessage: 'Failed to update transaction',
    );
  }
}
