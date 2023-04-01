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
  }) : _firestoreService = firestoreService;

  Stream<List<UserModel>> getUsers(List<String> userIds) {
    return _firestoreService.collectionStream<UserModel>(
      path: 'users',
      queryBuilder: (query) =>
          query.where(FieldPath.documentId, whereIn: userIds),
      builder: (json, docId) => UserModel.fromJson(json!),
    );
  }
}

class MockUsersRepository implements UsersRepository {
  @override
  FirestoreService get _firestoreService => throw UnimplementedError();

  @override
  Stream<List<UserModel>> getUsers(List<String> userIds) {
    return Stream.value(
      const <UserModel>[]
          .where(
            (element) => userIds.contains(element.uid),
          )
          .toList(),
    );
  }
}
