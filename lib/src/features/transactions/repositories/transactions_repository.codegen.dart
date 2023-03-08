import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/typedefs.dart';

// Models
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
    JSON? queryParams,
  }) {
    return _firestoreService.collectionStream<TransactionModel>(
      path: 'books/$bookId/transactions',
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
  Stream<List<TransactionModel>> getBookTransactions({required int bookId, JSON? queryParams}) {
    final wallet = <String, dynamic>{
      'id': 1,
      'name': 'Wallet',
      'image_url': 'https://i.imgur.com/1J8ZQYt.png',
      'balance': 1000,
    };
    final category = <String, dynamic>{
      'id': 1,
      'name': 'Food',
      'image_url': 'https://i.imgur.com/1J8ZQYt.png',
      'type': 'expense',
    };
    final date = DateTime.now();
    return Stream.value(<TransactionModel>[
      TransactionModel.fromJson(<String, dynamic>{
        'id': 1,
        'amount': 100,
        'description': 'Drinks',
        'date': '${date.year}-${date.month}-${date.day}',
        'wallet': wallet,
        'category': category,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 2,
        'amount': 200,
        'description': 'Food',
        'date': '${date.year}-${date.month}-${date.day}',
        'wallet': wallet,
        'category': category,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 3,
        'amount': 300,
        'description': 'Transport',
        'date': '${date.year}-${date.month}-${date.day}',
        'wallet': wallet,
        'category': category,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 4,
        'amount': 400,
        'description': 'Shopping',
        'date': '${date.year}-${date.month}-${date.day}',
        'wallet': wallet,
        'category': category,
      }),
      TransactionModel.fromJson(<String, dynamic>{
        'id': 5,
        'amount': 500,
        'description': 'Entertainment',
        'date': '${date.year}-${date.month}-${date.day}',
        'wallet': wallet,
        'category': category,
      }),
    ]);
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
