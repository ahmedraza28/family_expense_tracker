import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/typedefs.dart';

// Models
import '../models/wallet_model.codegen.dart';

part 'wallets_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
WalletsRepository walletsRepository(WalletsRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  // return WalletsRepository(firestoreService);
  return MockWalletsRepository();
}

class WalletsRepository {
  final FirestoreService _firestoreService;

  const WalletsRepository(this._firestoreService);

  Stream<List<WalletModel>> getBookWallets({required int bookId}) {
    return _firestoreService.collectionStream<WalletModel>(
      path: 'books/$bookId/wallets',
      builder: (json, docId) => WalletModel.fromJson(json!),
    );
  }

  Future<void> addWallet({
    required int bookId,
    required JSON body,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId/wallets',
      data: body,
    );
  }

  Future<void> updateWallet({
    required int bookId,
    required int walletId,
    required JSON changes,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId/wallets/$walletId',
      data: changes,
      merge: true,
    );
  }
}

class MockWalletsRepository implements WalletsRepository {
  @override
  Stream<List<WalletModel>> getBookWallets({required int bookId}) {
    return Stream.value(const [
      WalletModel(
        id: 1,
        name: 'Wallet 1',
        imageUrl: 'https://picsum.photos/200/300',
        balance: 200000,
      ),
      WalletModel(
        id: 2,
        name: 'Wallet 2',
        imageUrl: 'https://picsum.photos/200/300',
        balance: 200000,
      ),
      WalletModel(
        id: 3,
        name: 'Wallet 3',
        imageUrl: 'https://picsum.photos/200/300',
        balance: 200000,
      ),
      WalletModel(
        id: 4,
        name: 'Wallet 4',
        imageUrl: 'https://picsum.photos/200/300',
        balance: 200000,
      ),
    ]);
  }

  @override
  Future<void> addWallet({
    required int bookId,
    required JSON body,
  }) async {}

  @override
  Future<void> updateWallet({
    required int bookId,
    required int walletId,
    required JSON changes,
  }) async {}
  
  @override
  FirestoreService get _firestoreService => throw UnimplementedError();
}
