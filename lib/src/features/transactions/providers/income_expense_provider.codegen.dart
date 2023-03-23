import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/income_expense_model.codegen.dart';

// Repositories
import '../repositories/transactions_repository.codegen.dart';

// Features
import '../../categories/categories.dart';
import '../../wallets/wallets.dart';
import '../../books/books.dart';

part 'income_expense_provider.codegen.g.dart';

/// A provider used to access instance of this service
@riverpod
IncomeExpenseProvider incomeExpense(IncomeExpenseRef ref) {
  final bookId = ref.watch(selectedBookProvider)!.id!;
  return IncomeExpenseProvider(ref, bookId: bookId);
}

class IncomeExpenseProvider {
  final Ref _ref;
  final int bookId;

  IncomeExpenseProvider(
    this._ref, {
    required this.bookId,
  });

  void addTransaction({
    required double amount,
    required WalletModel wallet,
    required DateTime date,
    required CategoryModel category,
    String? description,
  }) {
    final transaction = IncomeExpenseModel(
      id: null,
      amount: amount,
      walletId: wallet.id!,
      categoryId: category.id!,
      date: date,
      description: description,
    );
    _ref
        .read(transactionsRepositoryProvider)
        .addTransaction(bookId: bookId, body: transaction.toJson());
  }

  void updateTransaction(IncomeExpenseModel transaction) {
    _ref.read(transactionsRepositoryProvider).updateTransaction(
          bookId: bookId,
          transactionId: transaction.id!,
          changes: transaction.toJson(),
        );
  }
}
