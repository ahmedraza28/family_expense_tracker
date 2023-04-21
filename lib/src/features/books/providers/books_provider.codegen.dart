import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';
import '../enums/member_role_enum.dart';

// Models
import '../models/book_member_model.codegen.dart';
import '../models/book_model.codegen.dart';

// Repositories
import '../repositories/books_repository.codegen.dart';

// Features
import '../../auth/auth.dart';

part 'books_provider.codegen.g.dart';

final selectedBookProvider = StateProvider<BookModel?>(
  name: 'selectedBookProvider',
  (ref) => null,
);

final isOwnerSelectedBookProvider = Provider<bool>(
  name: 'isOwnerSelectedBookProvider',
  (ref) {
    final myId = ref.watch(currentUserProvider).value!.uid;
    final selectedBook = ref.watch(selectedBookProvider);
    return selectedBook!.members[myId]!.isOwner;
  },
);

@riverpod
Stream<List<BookModel>> booksStream(
  BooksStreamRef ref, {
  required List<String> bookIds,
}) {
  final currentUser = ref.watch(currentUserProvider).value;
  if (currentUser == null) {
    return const Stream.empty();
  }
  return ref.watch(booksProvider.notifier).getUserBooks(bookIds);
}

/// A provider used to access instance of this service
@riverpod
class Books extends _$Books {
  @override
  FutureOr<void> build() => null;

  Stream<List<BookModel>> getUserBooks(List<String> bookIds) {
    final booksRepository = ref.read(booksRepositoryProvider);
    return booksRepository.getBooks(bookIds);
  }

  Future<void> addBook({
    required String name,
    required Color color,
    required String currencyName,
    String? description,
  }) async {
    state = const AsyncValue.loading();
    final currentUser = ref.read(currentUserProvider).value!;
    final book = BookModel(
      id: null,
      name: name,
      color: color,
      currencyName: currencyName,
      description: description ?? '',
      members: {
        currentUser.uid: BookMemberModel(
          imageUrl: currentUser.imageUrl,
          role: MemberRole.owner,
        )
      },
    );

    final booksRepository = ref.read(booksRepositoryProvider);
    state = await state.makeGuardedRequest(
      () => booksRepository.addBook(body: book.toJson()),
      errorMessage: 'Failed to add book',
    );
  }

  Future<void> updateBook(BookModel book) async {
    state = const AsyncValue.loading();

    final booksRepository = ref.read(booksRepositoryProvider);
    state = await state.makeGuardedRequest(
      () => booksRepository.updateBook(
        bookId: book.id!,
        changes: book.toJson(),
      ),
    );
  }
}
