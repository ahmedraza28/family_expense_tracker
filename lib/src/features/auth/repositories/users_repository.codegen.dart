import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Models
import '../models/user_model.codegen.dart';

part 'users_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
UsersRepository usersRepository(UsersRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  // return UsersRepository(
  //   firestoreService: firestoreService,
  //   booksRepository: booksRepository,
  // );
  return MockUsersRepository();
}

class UsersRepository {
  final FirestoreService _firestoreService;

  const UsersRepository({
    required FirestoreService firestoreService,
  })  : _firestoreService = firestoreService;

  Stream<List<UserModel>> getUsers([List<int>? userIds]) {
    return _firestoreService.collectionStream<UserModel>(
      path: 'users',
      queryBuilder: userIds != null
          ? (query) => query.where(FieldPath.documentId, whereIn: userIds)
          : null,
      builder: (json, docId) => UserModel.fromJson(json!),
    );
  }

  Stream<List<UserModel>> getBookMembers(String bookId) async* {
    final memberIdsStream = _firestoreService.collectionStream<int>(
      path: 'book_members',
      queryBuilder: (query) => query.where('bookId', isEqualTo: bookId),
      builder: (json, docId) => json!['memberId'] as int,
    );

    await for (final memberIds in memberIdsStream) {
      yield* getUsers(memberIds);
    }
  }
}

class MockUsersRepository implements UsersRepository {
  @override
  FirestoreService get _firestoreService => throw UnimplementedError();

  @override
  Stream<List<UserModel>> getBookMembers(String bookId) {
    throw UnimplementedError();
  }

  @override
  Stream<List<UserModel>> getUsers([List<int>? userIds]) {
    return Stream.value(const []);
  }
}
