import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';
import '../../../helpers/typedefs.dart';

// Models
import '../models/user_model.codegen.dart';

part 'users_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
UsersRepository usersRepository(UsersRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  return UsersRepository(
    firestoreService: firestoreService,
  );
  // return MockUsersRepository();
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

  Stream<UserModel?> getUserById(String uid) {
    return _firestoreService.documentStream<UserModel?>(
      path: 'users/$uid',
      builder: (json, docId) => json == null ? null : UserModel.fromJson(json),
    );
  }

  /// Method to check if a user exists
  Future<bool> userExists(String uid) {
    return _firestoreService.existsDocument(path: 'users/$uid');
  }

  /// Method to create a user in the database
  Future<void> addUser({
    required String uid,
    required JSON body,
  }) {
    return _firestoreService.setData(
      path: 'users/$uid',
      data: body,
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

  @override
  Stream<UserModel> getUserById(String uid) {
    return Stream.value(
      const UserModel(
        uid: '1',
        displayName: 'Abdur Rafay',
        email: 'a.rafaysaleem@gmail.com',
        imageUrl: '',
        ownedBookIds: ['1', '10'],
        sharedBookIds: ['2'],
      ),
    );
  }

  @override
  Future<void> addUser({
    required String uid,
    required JSON body,
  }) async =>
      Future.delayed(2.seconds);

  @override
  Future<bool> userExists(String uid) {
    return Future.value(true);
  }
}
