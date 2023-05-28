import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
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
  final bookId = ref.watch(selectedBookProvider.select((value) => value?.id));
  return wallets.getAllWallets(bookId);
}

@Riverpod(keepAlive: true)
Future<Map<String, WalletModel>> walletsMap(WalletsMapRef ref) async {
  final wallets = await ref.watch(walletsStreamProvider.future);
  return {for (var e in wallets) e.id: e};
}

@Riverpod(keepAlive: true)
WalletModel? walletById(WalletByIdRef ref, String? id) {
  return ref.watch(walletsMapProvider).value?[id];
}

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
class Wallets extends _$Wallets {
  @override
  FutureOr<String?> build() => null;

  Stream<List<WalletModel>> getAllWallets(String? bookId, [JSON? queryParams]) {
    final walletsRepository = ref.read(walletsRepositoryProvider);
    return bookId == null
        ? Stream.value([])
        : walletsRepository.getBookWallets(bookId: bookId);
  }

  Future<void> addWallet({
    required String name,
    required Color color,
    required double balance,
    String? description,
  }) async {
    state = const AsyncValue.loading();

    final wallet = WalletModel(
      id: AppUtils.generateUuid(),
      name: name,
      color: color,
      balance: balance,
      description: description,
    );

    final walletsRepository = ref.read(walletsRepositoryProvider);
    final bookId = ref.read(selectedBookProvider)!.id;
    state = await state.makeGuardedRequest(
      () async {
        await walletsRepository.addWallet(
          bookId: bookId,
          walletId: wallet.id,
          body: wallet.toJson(),
        );
        return 'Wallet created successfully';
      },
      errorMessage: 'Failed to add wallet',
    );
  }

  Future<void> updateWallet(WalletModel wallet) async {
    state = const AsyncValue.loading();

    final walletsRepository = ref.read(walletsRepositoryProvider);
    final bookId = ref.read(selectedBookProvider)!.id;
    state = await state.makeGuardedRequest(
      () async {
        await walletsRepository.updateWallet(
          bookId: bookId,
          walletId: wallet.id,
          changes: wallet.toJson(),
        );
        return 'Wallet updated successfully';
      },
      errorMessage: 'Failed to update wallet',
    );
  }
}
