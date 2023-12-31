import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';
import '../../../helpers/typedefs.dart';

import '../enums/transaction_type_enum.dart';

// Models
import '../models/transaction_model.dart';

// Features
import '../../income_expense/income_expense.dart';

part 'transactions_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
TransactionsRepository transactionsRepository(TransactionsRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  return TransactionsRepository(firestoreService);
  // return MockTransactionsRepository();
}

class TransactionsRepository {
  final FirestoreService _firestoreService;

  const TransactionsRepository(this._firestoreService);

  Stream<List<TransactionModel>> getBookTransactions({
    required String bookId,
    required int month,
    required int year,
    String? categoryId,
    int? day,
    List<String>? transactionTypes,
  }) async* {
    final path = 'books/$bookId/transactions-$month-$year';
    if (!(await _firestoreService.existsCollection(path: path))) {
      yield const [];
      return;
    }

    final hasQuery =
        categoryId != null || transactionTypes != null || day != null;
    yield* _firestoreService.collectionStream<TransactionModel>(
      path: path,
      queryBuilder: !hasQuery
          ? null
          : (query) {
              if (day != null) {
                query = query.where('day', isEqualTo: day);
              }
              if (transactionTypes != null) {
                query = query.where('type', whereIn: transactionTypes);
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
      sort: (lhs, rhs) => rhs.date.compareTo(lhs.date),
    );
  }

  Future<void> addTransaction({
    required String bookId,
    required String transactionId,
    required int month,
    required int year,
    required JSON body,
  }) {
    return _firestoreService.insertData(
      path: 'books/$bookId/transactions-$month-$year',
      id: transactionId,
      data: body,
    );
  }

  Future<void> updateTransaction({
    required String bookId,
    required int month,
    required int year,
    required String transactionId,
    required JSON changes,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId/transactions-$month-$year/$transactionId',
      data: changes,
      merge: true,
    );
  }

  Future<void> deleteTransaction({
    required String bookId,
    required int month,
    required int year,
    required String transactionId,
  }) {
    return _firestoreService.deleteData(
      path: 'books/$bookId/transactions-$month-$year/$transactionId',
    );
  }
}

class MockTransactionsRepository implements TransactionsRepository {
  @override
  Stream<List<TransactionModel>> getBookTransactions({
    required String bookId,
    required int month,
    required int year,
    String? categoryId,
    int? day,
    List<String>? transactionTypes,
  }) {
    const walletId = '1';
    final nowDate = DateTime.now();
    final todayDate = nowDate.toDateString('yyyy-MM-dd');
    final yesterDate =
        nowDate.subtract(const Duration(days: 1)).toDateString('yyyy-MM-dd');
    final twoDaysAgoDate =
        nowDate.subtract(const Duration(days: 2)).toDateString('yyyy-MM-dd');
    final lastMonthDate =
        nowDate.subtract(const Duration(days: 30)).toDateString('yyyy-MM-dd');
    final list = <TransactionModel>[
      IncomeExpenseModel(
        id: '1',
        amount: 100,
        type: TransactionType.income,
        walletId: walletId,
        categoryId: '1',
        date: nowDate,
      ),
      TransactionModel.fromJson(<String, dynamic>{
        'id': '3',
        'amount': 300,
        'date': todayDate,
        'type': TransactionType.transfer.name,
        'description': 'Ghar kharcha',
        'src_wallet_id': walletId,
        'dest_wallet_id': walletId,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': '4',
        'amount': 400,
        'type': TransactionType.expense.name,
        'description': 'Ek wagon fuel',
        'date': yesterDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: '2',
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': '5',
        'amount': 500,
        'description': 'Civic service',
        'type': TransactionType.expense.name,
        'date': yesterDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: '2',
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': '1',
        'amount': 100,
        'description': '10Pearls',
        'type': TransactionType.income.name,
        'date': yesterDate,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: '3',
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': '2',
        'amount': 200,
        'description': 'Food',
        'date': yesterDate,
        'type': TransactionType.expense.name,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: '1',
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': '3',
        'amount': 300,
        'date': lastMonthDate,
        'type': TransactionType.transfer.name,
        'description': 'Ghar kharcha',
        'src_wallet_id': walletId,
        'dest_wallet_id': walletId,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': '4',
        'amount': 400,
        'description': 'Shopping',
        'date': yesterDate,
        'type': TransactionType.expense.name,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: '1',
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': '5',
        'amount': 500,
        'description': 'Entertainment',
        'date': lastMonthDate,
        'type': TransactionType.expense.name,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: '1',
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': '1',
        'amount': 100,
        'description': 'Drinks',
        'date': lastMonthDate,
        'type': TransactionType.expense.name,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: '1',
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': '2',
        'amount': 200,
        'description': 'Food',
        'date': lastMonthDate,
        'type': TransactionType.expense.name,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: '1',
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': '3',
        'amount': 300,
        'date': twoDaysAgoDate,
        'description': 'Ghar kharcha',
        'type': TransactionType.transfer.name,
        'src_wallet_id': walletId,
        'dest_wallet_id': walletId,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': '4',
        'amount': 400,
        'description': 'Shopping',
        'date': twoDaysAgoDate,
        'type': TransactionType.expense.name,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: '1',
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': '5',
        'amount': 500,
        'description': 'Entertainment',
        'date': twoDaysAgoDate,
        'type': TransactionType.expense.name,
        'wallet_id': walletId,
        IncomeExpenseModel.categoryIdField: '1',
      }),
    ];
    return Stream.value(
      list.where((e) {
        if (e.date.year != year) {
          return false;
        }
        if (e.date.month != month) {
          return false;
        }
        if (day != null && e.date.day != day) {
          return false;
        }
        if (transactionTypes != null &&
            !transactionTypes.contains(e.type.name)) {
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
    required String bookId,
    required String transactionId,
    required int month,
    required int year,
    required JSON body,
  }) async =>
      Future.delayed(2.seconds, () => throw CustomException.unimplemented());

  @override
  Future<void> updateTransaction({
    required String bookId,
    required int month,
    required int year,
    required String transactionId,
    required JSON changes,
  }) async =>
      Future.delayed(2.seconds, () => throw CustomException.unimplemented());

  @override
  FirestoreService get _firestoreService => throw UnimplementedError();

  @override
  Future<void> deleteTransaction({
    required String bookId,
    required int month,
    required int year,
    required String transactionId,
  }) async =>
      Future.delayed(2.seconds, () => throw CustomException.unimplemented());
}
