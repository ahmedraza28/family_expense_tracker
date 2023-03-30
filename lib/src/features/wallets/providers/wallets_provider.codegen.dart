import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';
import '../../../helpers/typedefs.dart';

// Models
import '../models/wallet_model.codegen.dart';

// Repositories
import '../repositories/wallets_repository.codegen.dart';

// Features
import '../../books/books.dart';

part 'wallets_provider.codegen.g.dart';

@Riverpod(keepAlive: true)
Stream<List<WalletModel>> walletsStream(WalletsStreamRef ref) {
  final wallets = ref.watch(walletsProvider.notifier);
  return wallets.getAllWallets();
}

@Riverpod(keepAlive: true)
Future<Map<int, WalletModel>> walletsMap(WalletsMapRef ref) async {
  final wallets = await ref.watch(walletsStreamProvider.future);
  return {for (var e in wallets) e.id!: e};
}

@Riverpod(keepAlive: true)
WalletModel? walletById(WalletByIdRef ref, int? id) {
  return ref.watch(walletsMapProvider).value?[id];
}

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
class Wallets extends _$Wallets {
  late final int bookId;
  late final WalletsRepository _walletsRepository;

  @override
  FutureOr<void> build() {
    _walletsRepository = ref.watch(walletsRepositoryProvider);
    bookId = ref.watch(selectedBookProvider)!.id!;
    return null;
  }

  Stream<List<WalletModel>> getAllWallets([JSON? queryParams]) {
    return _walletsRepository.getBookWallets(bookId: bookId);
  }

  Future<void> addWallet({
    required String name,
    required Color color,
    required double balance,
    String? description,
  }) async {
    state = const AsyncValue.loading();

    final wallet = WalletModel(
      id: null,
      name: name,
      color: color,
      balance: balance,
      description: description,
    );

    state = await state.makeGuardedRequest(
      () => _walletsRepository.addWallet(
        bookId: bookId,
        body: wallet.toJson(),
      ),
      errorMessage: 'Failed to add wallet',
    );
  }

  Future<void> updateWallet(WalletModel wallet) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(
      () => _walletsRepository.updateWallet(
        bookId: bookId,
        walletId: wallet.id!,
        changes: wallet.toJson(),
      ),
      errorMessage: 'Failed to update wallet',
    );
  }
}
