import 'package:riverpod_annotation/riverpod_annotation.dart';


// Helpers
import '../../../helpers/typedefs.dart';

// Models
import '../models/book_model.codegen.dart';

// Repositories
import '../repositories/books_repository.codegen.dart';

// Features
import '../../auth/auth.dart';

part 'books_provider.codegen.g.dart';

final selectedBookProvider = Provider<BookModel?>((ref) {
  return null;
});

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
  Stream<List<UserModel>> getBookMembers(String bookId) {
    return _booksRepository.getBookMembers(bookId);
  }

  void addBook({
    required String name,
    required String imageUrl,
    required double totalIncome,
    required double totalExpense,
    required UserModel createdBy,
    String? description,
  }) {
    final book = BookModel(
      id: null,
      name: name,
      imageUrl: imageUrl,
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
