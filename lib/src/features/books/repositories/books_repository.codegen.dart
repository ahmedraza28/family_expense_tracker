import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Models
import '../../../helpers/typedefs.dart';
import '../../wallets/wallets.dart';
import '../models/book_model.codegen.dart';

// Features
import '../../auth/auth.dart';

part 'books_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
BooksRepository booksRepository(BooksRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  final usersRepository = ref.read(usersRepositoryProvider);
  // return BooksRepository(
  //   firestoreService: firestoreService,
  //   usersRepository: usersRepository,
  // );
  return MockBooksRepository();
}

class BooksRepository {
  final FirestoreService _firestoreService;
  final UsersRepository _usersRepository;

  const BooksRepository({
    required FirestoreService firestoreService,
    required UsersRepository usersRepository,
  })  : _firestoreService = firestoreService,
        _usersRepository = usersRepository;

  Stream<List<BookModel>> getBooks({List<int>? bookIds}) {
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

  Future<void> addBook({
    required JSON body,
  }) {
    return _firestoreService.setData(
      path: 'books',
      data: body,
    );
  }

  Future<void> updateBook({
    required int bookId,
    required JSON changes,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId',
      data: changes,
      merge: true,
    );
  }
}

class MockBooksRepository implements BooksRepository {
  static const _user = UserModel(
    uid: '1',
    displayName: 'Abdur Rafay',
    email: 'a.rafaysaleem@gmail.com',
    profilePictureUrl: '',
  );
  @override
  Stream<List<BookModel>> getBooks({List<int>? bookIds}) {
    return Stream.value(const [
      BookModel(
        id: 1,
        name: 'Book 1',
        description: 'Book 1 description',
        imageUrl: '',
        currency: defaultCurrency,
        createdBy: _user,
        totalIncome: 0,
        totalExpense: 0,
      ),
      BookModel(
        id: 2,
        name: 'Book 2',
        description: 'Book 2 description',
        imageUrl: '',
        currency: defaultCurrency,
        createdBy: _user,
        totalIncome: 0,
        totalExpense: 0,
      ),
    ]);
  }

  @override
  FirestoreService get _firestoreService => throw UnimplementedError();

  @override
  UsersRepository get _usersRepository => throw UnimplementedError();

  @override
  Future<void> addBook({required JSON body}) {
    throw UnimplementedError();
  }

  @override
  Stream<List<UserModel>> getBookMembers(String bookId) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateBook({required int bookId, required JSON changes}) {
    throw UnimplementedError();
  }
}
