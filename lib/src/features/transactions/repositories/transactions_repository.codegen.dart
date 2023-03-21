import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/extensions/datetime_extension.dart';
import '../../../helpers/typedefs.dart';

// Models
import '../models/income_expense_model.codegen.dart';
import '../models/transaction_model.dart';

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
  }) {
    final hasQuery = categoryId != null || date != null;
    return _firestoreService.collectionStream<TransactionModel>(
      path: 'books/$bookId/transactions',
      queryBuilder: !hasQuery
          ? null
          : (query) {
              if (categoryId != null) {
                query = query.where('category_id', isEqualTo: categoryId);
              }
              if (date != null) {
                // TODO(arafaysaleem): filter based only on month and year
                query = query.where('date', isGreaterThanOrEqualTo: date);
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
  }) {
    final wallet = <String, dynamic>{
      'id': 1,
      'name': 'Wallet',
      'currency': <String, dynamic>{
        'name': 'PKR',
        'symbol': 'Rs',
      },
      'image_url': 'https://i.imgur.com/1J8ZQYt.png',
      'balance': 1000,
    };
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
        'wallet': wallet,
        'category_id': 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 2,
        'amount': 200,
        'description': "McDonald's",
        'date': todayDate,
        'wallet': wallet,
        'category_id': 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 3,
        'amount': 300,
        'date': todayDate,
        'note': 'Ghar kharcha',
        'src_wallet': wallet,
        'dest_wallet': wallet,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 4,
        'amount': 400,
        'description': 'Ek wagon fuel',
        'date': yesterDate,
        'wallet': wallet,
        'category_id': 2,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 5,
        'amount': 500,
        'description': 'Civic service',
        'date': yesterDate,
        'wallet': wallet,
        'category_id': 2,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 1,
        'amount': 100,
        'description': '10Pearls',
        'date': yesterDate,
        'wallet': wallet,
        'category_id': 3,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 2,
        'amount': 200,
        'description': 'Food',
        'date': yesterDate,
        'wallet': wallet,
        'category_id': 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 3,
        'amount': 300,
        'date': lastMonthDate,
        'note': 'Ghar kharcha',
        'src_wallet': wallet,
        'dest_wallet': wallet,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 4,
        'amount': 400,
        'description': 'Shopping',
        'date': yesterDate,
        'wallet': wallet,
        'category_id': 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 5,
        'amount': 500,
        'description': 'Entertainment',
        'date': lastMonthDate,
        'wallet': wallet,
        'category_id': 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 1,
        'amount': 100,
        'description': 'Drinks',
        'date': lastMonthDate,
        'wallet': wallet,
        'category_id': 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 2,
        'amount': 200,
        'description': 'Food',
        'date': lastMonthDate,
        'wallet': wallet,
        'category_id': 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 3,
        'amount': 300,
        'date': twoDaysAgoDate,
        'note': 'Ghar kharcha',
        'src_wallet': wallet,
        'dest_wallet': wallet,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 4,
        'amount': 400,
        'description': 'Shopping',
        'date': twoDaysAgoDate,
        'wallet': wallet,
        'category_id': 1,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 5,
        'amount': 500,
        'description': 'Entertainment',
        'date': twoDaysAgoDate,
        'wallet': wallet,
        'category_id': 1,
      }),
    ];
    return Stream.value(
      list.where((e) {
        if (date != null) {
          return e.date.year == date.year && e.date.month == date.month;
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
