import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';

// Models
import '../models/balance_transfer_model.codegen.dart';

// Features
import '../../wallets/wallets.dart';

part 'balance_transfer_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
BalanceTransferRepository balanceTransferRepository(
  BalanceTransferRepositoryRef ref,
) {
  final firestoreService = ref.read(firestoreServiceProvider);
  return BalanceTransferRepository(firestoreService);
  // return MockBalanceTransferRepository();
}

class BalanceTransferRepository {
  final FirestoreService _firestoreService;

  BalanceTransferRepository(this._firestoreService);

  Future<void> updateBalanceTransferAmount({
    required String bookId,
    required BalanceTransferModel transaction,
    required WalletModel srcWallet,
    required WalletModel destWallet,
    bool isIncreased = true,
  }) {
    // TODO(arafaysaleem): Convert to cloud functions
    return _firestoreService.batchBuilder((batch, db) {
      final transactionId = transaction.id!;
      final month = transaction.date.month;
      final year = transaction.date.year;
      final transactionPath =
          'books/$bookId/transactions-$month-$year/$transactionId';
      final walletPath = 'books/$bookId/wallets';
      batch
        ..update(db.doc(transactionPath), transaction.toJson())
        ..update(
          db.doc('$walletPath/${transaction.srcWalletId}'),
          <String, Object?>{
            WalletModel.balanceField: isIncreased
                ? srcWallet.balance - transaction.amount
                : srcWallet.balance + transaction.amount,
          },
        )
        ..update(
          db.doc('$walletPath/${transaction.destWalletId}'),
          <String, Object?>{
            WalletModel.balanceField: isIncreased
                ? destWallet.balance + transaction.amount
                : destWallet.balance - transaction.amount,
          },
        );
    });
  }

  Future<void> deleteTransfer({
    required String bookId,
    required BalanceTransferModel transaction,
    required WalletModel srcWallet,
    required WalletModel destWallet,
  }) {
    // TODO(arafaysaleem): Convert to cloud functions
    return _firestoreService.batchBuilder((batch, db) {
      final transactionId = transaction.id!;
      final month = transaction.date.month;
      final year = transaction.date.year;
      final transactionPath =
          'books/$bookId/transactions-$month-$year/$transactionId';
      final walletsPath = 'books/$bookId/wallets';
      batch
        ..delete(db.doc(transactionPath))
        ..update(db.doc('$walletsPath/${srcWallet.id}'), <String, Object?>{
          WalletModel.balanceField: srcWallet.balance + transaction.amount,
        })
        ..update(db.doc('$walletsPath/${destWallet.id}'), <String, Object?>{
          WalletModel.balanceField: destWallet.balance - transaction.amount,
        });
    });
  }
}

class MockBalanceTransferRepository implements BalanceTransferRepository {
  @override
  Future<void> deleteTransfer({
    required String bookId,
    required BalanceTransferModel transaction,
    required WalletModel srcWallet,
    required WalletModel destWallet,
  }) async =>
      Future.delayed(2.seconds, () => throw CustomException.unimplemented());

  @override
  FirestoreService get _firestoreService => throw UnimplementedError();

  @override
  Future<void> updateBalanceTransferAmount({
    required String bookId,
    required BalanceTransferModel transaction,
    required WalletModel srcWallet,
    required WalletModel destWallet,
    bool isIncreased = true,
  }) async =>
      Future.delayed(2.seconds, () => throw CustomException.unimplemented());
}
