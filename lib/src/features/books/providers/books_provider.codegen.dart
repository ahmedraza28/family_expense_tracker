import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
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

final isBookPreLoadedProvider = StateProvider<bool>(
  name: 'isBookPreLoadedProvider',
  (ref) => false,
);

/// A provider used to access instance of this service
@riverpod
class Books extends _$Books {
  @override
  FutureOr<String?> build() => null;

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
      id: AppUtils.generateUuid(),
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
      () async {
        await booksRepository.addBook(
          body: book.toJson(),
          bookId: book.id,
        );
        return 'Book added successfully';
      },
      errorMessage: 'Failed to add book',
    );
  }

  Future<void> updateBook(BookModel book) async {
    state = const AsyncValue.loading();

    final booksRepository = ref.read(booksRepositoryProvider);
    state = await state.makeGuardedRequest(
      () async {
        await booksRepository.updateBook(
          bookId: book.id,
          changes: book.toJson(),
        );
        return 'Book updated successfully';
      },
    );
  }

  Future<void> addMemberToBook({
    required String bookId,
    required MemberRole role,
  }) async {
    state = const AsyncValue.loading();

    final booksRepository = ref.read(booksRepositoryProvider);
    state = await state.makeGuardedRequest(
      () async {
        final currentUser = ref.read(currentUserProvider).value!;

        if (currentUser.ownedBookIds.contains(bookId)) {
          throw Exception('You are already an owner of this book');
        }

        await booksRepository.updateBook(
          bookId: bookId,
          changes: <String, Object?>{
            BookModel.membersKey: {
              currentUser.uid: BookMemberModel(
                imageUrl: currentUser.imageUrl,
                role: role,
              )
            },
          },
        );
        return 'Invite accepted successfully';
      },
    );
  }

  void resetSelectedBook() {
    ref
      ..invalidate(selectedBookProvider)
      ..invalidate(isBookPreLoadedProvider);
  }
}
