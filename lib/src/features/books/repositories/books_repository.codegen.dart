import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Models
import '../models/book_model.codegen.dart';

// Features
import '../../auth/auth.dart';

part 'books_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
BooksRepository booksRepository(BooksRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  final usersRepository = ref.read(usersRepositoryProvider);
  return BooksRepository(
    firestoreService: firestoreService,
    usersRepository: usersRepository,
  );
  // return MockBooksRepository();
}

class BooksRepository {
  final FirestoreService _firestoreService;
  final UsersRepository _usersRepository;

  const BooksRepository({
    required FirestoreService firestoreService,
    required UsersRepository usersRepository,
  })  : _firestoreService = firestoreService,
        _usersRepository = usersRepository;

  Stream<List<BookModel>> getBooks([List<int>? bookIds]) {
    return _firestoreService.collectionStream<BookModel>(
      path: 'books',
      queryBuilder: bookIds != null
          ? (query) => query.where(FieldPath.documentId, whereIn: bookIds)
          : null,
      builder: (json, docId) => BookModel.fromJson(json!),
    );
  }

  Stream<List<UserModel>> getBookMembers(String bookId) async* {
    final memberIdsStream = _firestoreService.collectionStream<int>(
      path: 'book_members',
      queryBuilder: (query) => query.where('bookId', isEqualTo: bookId),
      builder: (json, docId) => json!['memberId'] as int,
    );

    await for (final memberIds in memberIdsStream) {
      yield* _usersRepository.getUsers(memberIds);
    }
  }
}
