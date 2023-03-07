import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Models
import '../models/user_model.codegen.dart';

// Features
import '../../books/books.dart';

part 'users_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
UsersRepository usersRepository(UsersRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  final booksRepository = ref.read(booksRepositoryProvider);
  return UsersRepository(
    firestoreService: firestoreService,
    booksRepository: booksRepository,
  );
  // return MockUsersRepository();
}

class UsersRepository {
  final FirestoreService _firestoreService;
  final BooksRepository _booksRepository;

  const UsersRepository({
    required FirestoreService firestoreService,
    required BooksRepository booksRepository,
  })  : _firestoreService = firestoreService,
        _booksRepository = booksRepository;

  Stream<List<UserModel>> getUsers([List<int>? userIds]) {
    return _firestoreService.collectionStream<UserModel>(
      path: 'users',
      queryBuilder: userIds != null
          ? (query) => query.where(FieldPath.documentId, whereIn: userIds)
          : null,
      builder: (json, docId) => UserModel.fromJson(json!),
    );
  }

  Stream<List<BookModel>> getUserBooks(String memberId) async* {
    final bookIdsStream = _firestoreService.collectionStream<int>(
      path: 'book_members',
      queryBuilder: (query) => query.where('memberId', isEqualTo: memberId),
      builder: (json, docId) => json!['bookId'] as int,
    );

    await for (final bookIds in bookIdsStream) {
      yield* _booksRepository.getBooks(bookIds: bookIds);
    }
  }
}
