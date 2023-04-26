import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';

// Models
import '../models/balance_adjustment_model.codegen.dart';

// Features
import '../../wallets/wallets.dart';

part 'balance_adjustment_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
BalanceAdjustmentRepository balanceAdjustmentRepository(
  BalanceAdjustmentRepositoryRef ref,
) {
  final firestoreService = ref.read(firestoreServiceProvider);
  return BalanceAdjustmentRepository(firestoreService);
  // return MockBalanceAdjustmentRepository();
}

class BalanceAdjustmentRepository {
  final FirestoreService _firestoreService;

  BalanceAdjustmentRepository(this._firestoreService);

  Future<void> deleteAdjustment({
    required String bookId,
    required BalanceAdjustmentModel transaction,
  }) {
    // TODO(arafaysaleem): Convert to cloud functions
    return _firestoreService.batchBuilder((batch, db) {
      final transactionId = transaction.id!;
      final month = transaction.date.month;
      final year = transaction.date.year;
      final transactionPath =
          'books/$bookId/transactions-$month-$year/$transactionId';
      final walletPath = 'books/$bookId/wallets/${transaction.walletId}';
      batch
        ..delete(db.doc(transactionPath))
        ..update(db.doc(walletPath), <String, Object?>{
          WalletModel.balanceField: transaction.previousAmount,
        });
    });
  }
}

class MockBalanceAdjustmentRepository implements BalanceAdjustmentRepository {
  @override
  Future<void> deleteAdjustment({
    required String bookId,
    required BalanceAdjustmentModel transaction,
  }) async =>
      Future.delayed(2.seconds, throw CustomException.unimplemented());

  @override
  FirestoreService get _firestoreService => throw UnimplementedError();
}
