import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/wallet_model.codegen.dart';

// Repositories
import '../repositories/wallets_repository.codegen.dart';

// Features
import '../../books/books.dart';

// part 'wallets_provider.codegen.g.dart';

/// Fetches a stream of [WalletModel]s
final bookWalletsProvider = StreamProvider<List<WalletModel>>(
  (ref) {
    final bookId = ref.watch(selectedBookProvider)!.id;
    return ref.watch(walletsRepositoryProvider).getBookWallets(bookId: bookId);
  },
);
