import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/extensions/datetime_extension.dart';
import '../../../helpers/typedefs.dart';

// Models
import '../models/income_expense_model.codegen.dart';
import '../models/transaction_model.dart';

// Features
import '../../balance_transfer/balance_transfer.dart';

part 'transactions_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
TransactionsRepository transactionsRepository(TransactionsRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  // return TransactionsRepository(firestoreService);
  return MockTransactionsRepository();
}

class TransactionsRepository {
  final FirestoreService _firestoreService;

  const TransactionsRepository(this._firestoreService);

  Stream<List<TransactionModel>> getBookTransactions({
    required int bookId,
    int? categoryId,
    DateTime? date,
    bool incomeExpenseOnly = false,
    bool balanceTransferOnly = false,
  }) {
    final hasQuery = categoryId != null || date != null;
    return _firestoreService.collectionStream<TransactionModel>(
      path: 'books/$bookId/transactions',
      queryBuilder: !hasQuery
          ? null
          : (query) {
              if (date != null) {
                // TODO(arafaysaleem): filter based only on month and year
                query = query.where('date', isGreaterThanOrEqualTo: date);
              }
              if (incomeExpenseOnly) {
                query = query.where(
                  IncomeExpenseModel.categoryIdField,
                  isNull: false,
                );
              } else if (balanceTransferOnly) {
                query = query.where(
                  IncomeExpenseModel.categoryIdField,
                  isNull: true,
                );
              }
              if (categoryId != null) {
                query = query.where(
                  IncomeExpenseModel.categoryIdField,
                  isEqualTo: categoryId,
                  isNull: false,
                );
              }
              return query;
            },
      builder: (json, docId) => TransactionModel.fromJson(json!),
    );
  }

  Future<void> addTransaction({
    required int bookId,
    required JSON body,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId/transactions',
      data: body,
    );
  }

  Future<void> updateTransaction({
    required int bookId,
    required int transactionId,
    required JSON changes,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId/transactions/$transactionId',
      data: changes,
      merge: true,
    );
  }
}

class MockTransactionsRepository implements TransactionsRepository {
  @override
  Stream<List<TransactionModel>> getBookTransactions({
    required int bookId,
    int? categoryId,
    DateTime? date,
    bool incomeExpenseOnly = false,
    bool balanceTransferOnly = false,
  }) {
    const walletId = 1;
    final nowDate = DateTime.now();
    final todayDate = nowDate.toDateString('yyyy-MM-dd');
    final yesterDate =
        nowDate.subtract(const Duration(days: 1)).toDateString('yyyy-MM-dd');
    final twoDaysAgoDate =
        nowDate.subtract(const Duration(days: 2)).toDateString('yyyy-MM-dd');
    final lastMonthDate =
        nowDate.subtract(const Duration(days: 30)).toDateString('yyyy-MM-dd');
    final list = <TransactionModel>[
      TransactionModel.fromJson(<String, dynamic>{
        'id': 1,
        'amount': 100,
        'description': 'Gatorades crate',
        'date': todayDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 2,
        'amount': 200,
        'description': "McDonald's",
        'date': todayDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 3,
        'amount': 300,
        'date': todayDate,
        'description': 'Ghar kharcha',
        'src_wallet_id': walletId,
        'dest_wallet_id': walletId,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 4,
        'amount': 400,
        'description': 'Ek wagon fuel',
        'date': yesterDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: 2,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 5,
        'amount': 500,
        'description': 'Civic service',
        'date': yesterDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: 2,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 1,
        'amount': 100,
        'description': '10Pearls',
        'date': yesterDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: 3,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 2,
        'amount': 200,
        'description': 'Food',
        'date': yesterDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 3,
        'amount': 300,
        'date': lastMonthDate,
        'description': 'Ghar kharcha',
        'src_wallet_id': walletId,
        'dest_wallet_id': walletId,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 4,
        'amount': 400,
        'description': 'Shopping',
        'date': yesterDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 5,
        'amount': 500,
        'description': 'Entertainment',
        'date': lastMonthDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 1,
        'amount': 100,
        'description': 'Drinks',
        'date': lastMonthDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 2,
        'amount': 200,
        'description': 'Food',
        'date': lastMonthDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 3,
        'amount': 300,
        'date': twoDaysAgoDate,
        'description': 'Ghar kharcha',
        'src_wallet_id': walletId,
        'dest_wallet_id': walletId,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 4,
        'amount': 400,
        'description': 'Shopping',
        'date': twoDaysAgoDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 5,
        'amount': 500,
        'description': 'Entertainment',
        'date': twoDaysAgoDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: 1,
      }),
    ];
    return Stream.value(
      list.where((e) {
        if (date != null) {
          if (e.date.year != date.year || e.date.month != date.month) {
            return false;
          }
        }
        if (incomeExpenseOnly && e is BalanceTransferModel) {
          return false;
        } else if (balanceTransferOnly && e is IncomeExpenseModel) {
          return false;
        }
        if (categoryId != null && e is IncomeExpenseModel) {
          return e.categoryId == categoryId;
        }
        return true;
      }).toList(),
    );
  }

  @override
  Future<void> addTransaction({
    required int bookId,
    required JSON body,
  }) async {}

  @override
  Future<void> updateTransaction({
    required int bookId,
    required int transactionId,
    required JSON changes,
  }) async {}

  @override
  FirestoreService get _firestoreService => throw UnimplementedError();
}
