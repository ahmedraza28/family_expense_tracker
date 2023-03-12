import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/typedefs.dart';

// Models
import '../models/book_model.codegen.dart';

// Repositories
import '../repositories/books_repository.codegen.dart';

// Features
import '../../wallets/wallets.dart';
import '../../auth/auth.dart';

part 'books_provider.codegen.g.dart';

final selectedBookProvider = StateProvider<BookModel?>((ref) {
  return null;
});

final editBookProvider = StateProvider.autoDispose<BookModel?>((ref) {
  return null;
});

@riverpod
Stream<List<BookModel>> booksStream(BooksStreamRef ref) {
  final currentUser = ref.watch(currentUserProvider).valueOrNull!;
  return ref.watch(booksProvider).getUserBooks(currentUser.uid);
}

/// A provider used to access instance of this service
@riverpod
BooksProvider books(BooksRef ref) {
  final booksRepository = ref.watch(booksRepositoryProvider);
  return BooksProvider(booksRepository);
}

class BooksProvider {
  final BooksRepository _booksRepository;

  BooksProvider(this._booksRepository);

  Stream<List<BookModel>> getAllBooks([JSON? queryParams]) {
    return _booksRepository.getBooks();
  }

  /// Retrive book members
  Stream<List<BookModel>> getUserBooks(String memberId) {
    return _booksRepository.getUserBooks(memberId);
  }

  void addBook({
    required String name,
    required String imageUrl,
    required double totalIncome,
    required double totalExpense,
    required UserModel createdBy,
    required CurrencyModel currency,
    String? description,
  }) {
    final book = BookModel(
      id: null,
      name: name,
      imageUrl: imageUrl,
      currency: currency,
      description: description ?? '',
      createdBy: createdBy,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
    );
    _booksRepository.addBook(body: book.toJson());
  }

  void updateBook(BookModel book) {
    _booksRepository.updateBook(
      bookId: book.id!,
      changes: book.toJson(),
    );
  }
}
