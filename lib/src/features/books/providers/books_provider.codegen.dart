import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';
import '../../../helpers/typedefs.dart';

// Models
import '../models/book_model.codegen.dart';

// Repositories
import '../repositories/books_repository.codegen.dart';

// Features
import '../../auth/auth.dart';

part 'books_provider.codegen.g.dart';

final selectedBookProvider = StateProvider<BookModel?>((ref) {
  return null;
});

@riverpod
Stream<List<BookModel>> booksStream(BooksStreamRef ref) {
  final currentUser = ref.watch(currentUserProvider).value;
  if (currentUser == null) {
    return const Stream.empty();
  }
  return ref.watch(booksProvider.notifier).getUserBooks(currentUser.uid);
}

/// A provider used to access instance of this service
@riverpod
class Books extends _$Books {
  late final BooksRepository _booksRepository;

  @override
  FutureOr<void> build() {
    _booksRepository = ref.watch(booksRepositoryProvider);
    return null;
  }

  Stream<List<BookModel>> getAllBooks([JSON? queryParams]) {
    return _booksRepository.getBooks();
  }

  /// Retrive book members
  Stream<List<BookModel>> getUserBooks(String memberId) {
    return _booksRepository.getUserBooks(memberId);
  }

  Future<void> addBook({
    required String name,
    required Color color,
    required UserModel createdBy,
    required String currencyName,
    String? description,
  }) async {
    state = const AsyncValue.loading();
    final book = BookModel(
      id: null,
      name: name,
      color: color,
      currencyName: currencyName,
      description: description ?? '',
      createdBy: createdBy,
    );

    state = await state.makeGuardedRequest(
      () => _booksRepository.addBook(body: book.toJson()),
    );
  }

  Future<void> updateBook(BookModel book) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(
      () => _booksRepository.updateBook(
        bookId: book.id!,
        changes: book.toJson(),
      ),
    );
  }
}
