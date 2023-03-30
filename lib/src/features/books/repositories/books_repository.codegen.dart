import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/typedefs.dart';

// Models
import '../models/book_model.codegen.dart';

// Features
import '../../wallets/wallets.dart';
import '../../auth/auth.dart';

part 'books_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
BooksRepository booksRepository(BooksRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  // return BooksRepository(
  //   firestoreService: firestoreService,
  //   usersRepository: usersRepository,
  // );
  return MockBooksRepository();
}

class BooksRepository {
  final FirestoreService _firestoreService;

  const BooksRepository({
    required FirestoreService firestoreService,
  }) : _firestoreService = firestoreService;

  Stream<List<BookModel>> getBooks({List<int>? bookIds}) {
    return _firestoreService.collectionStream<BookModel>(
      path: 'books',
      queryBuilder: bookIds != null
          ? (query) => query.where(FieldPath.documentId, whereIn: bookIds)
          : null,
      builder: (json, docId) => BookModel.fromJson(json!),
    );
  }

  Stream<List<BookModel>> getUserBooks(String memberId) async* {
    final bookIdsStream = _firestoreService.collectionStream<int>(
      path: 'book_members',
      queryBuilder: (query) => query.where('memberId', isEqualTo: memberId),
      builder: (json, docId) => json!['bookId']! as int,
    );

    await for (final bookIds in bookIdsStream) {
      yield* getBooks(bookIds: bookIds);
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
        color: Colors.purple,
        currency: defaultCurrency,
        createdBy: _user,
      ),
      BookModel(
        id: 2,
        name: 'Book 2',
        description: 'Book 2 description',
        color: Colors.deepOrangeAccent,
        currency: defaultCurrency,
        createdBy: _user,
      ),
    ]);
  }

  @override
  FirestoreService get _firestoreService => throw UnimplementedError();

  @override
  Stream<List<BookModel>> getUserBooks(String memberId) {
    return Stream.value(const [
      BookModel(
        id: 1,
        name: 'Book 1',
        description: 'Book 1 description',
        color: Colors.purple,
        currency: defaultCurrency,
        createdBy: _user,
      ),
      BookModel(
        id: 2,
        name: 'Book 2',
        description: 'Book 2 description',
        color: Colors.deepOrangeAccent,
        currency: defaultCurrency,
        createdBy: _user,
      ),
    ]);
  }

  @override
  Future<void> addBook({required JSON body}) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateBook({required int bookId, required JSON changes}) {
    throw UnimplementedError();
  }
}
