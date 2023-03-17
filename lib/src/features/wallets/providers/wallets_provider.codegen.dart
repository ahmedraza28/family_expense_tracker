import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/typedefs.dart';

// Models
import '../models/currency_model.codegen.dart';
import '../models/wallet_model.codegen.dart';

// Repositories
import '../repositories/currencies_repository.codegen.dart';
import '../repositories/wallets_repository.codegen.dart';

// Features
import '../../books/books.dart';

part 'wallets_provider.codegen.g.dart';

final selectedWalletProvider = Provider<WalletModel?>((ref) {
  return null;
});

final walletsStreamProvider = StreamProvider<List<WalletModel>>(
  (ref) {
    final wallets = ref.watch(walletsProvider);
    return wallets.getAllWallets();
  },
);

@Riverpod(keepAlive: true)
Stream<List<CurrencyModel>> currenciesStream(CurrenciesStreamRef ref) {
  return ref.watch(currenciesRepositoryProvider).getAllCurrencies();
}

const defaultCurrency = CurrencyModel(name: 'PKR', symbol: 'Rs');

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
WalletsProvider wallets(WalletsRef ref) {
  final walletsRepository = ref.watch(walletsRepositoryProvider);
  final bookId = ref.watch(selectedBookProvider)!.id!;
  return WalletsProvider(walletsRepository, bookId: bookId);
}

class WalletsProvider {
  final int bookId;
  final WalletsRepository _walletsRepository;

  WalletsProvider(
    this._walletsRepository, {
    required this.bookId,
  });

  Stream<List<WalletModel>> getAllWallets([JSON? queryParams]) {
    return _walletsRepository.getBookWallets(bookId: bookId);
  }

  void addWallet({
    required String name,
    required String imageUrl,
    required double balance,
    required CurrencyModel currency,
    String? description,
  }) {
    final wallet = WalletModel(
      id: null,
      name: name,
      currency: currency,
      imageUrl: imageUrl,
      balance: balance,
      description: description,
    );
    _walletsRepository.addWallet(
      bookId: bookId,
      body: wallet.toJson(),
    );
  }

  void updateWallet(WalletModel wallet) {
    _walletsRepository.updateWallet(
      bookId: bookId,
      walletId: wallet.id!,
      changes: wallet.toJson(),
    );
  }
}
