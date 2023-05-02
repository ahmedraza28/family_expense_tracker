import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/typedefs.dart';
import '../enums/member_role_enum.dart';

// Models
import '../models/book_member_model.codegen.dart';
import '../models/book_model.codegen.dart';

// Features
import '../../auth/auth.dart';

part 'books_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
BooksRepository booksRepository(BooksRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  return BooksRepository(firestoreService: firestoreService);
  // return MockBooksRepository();
}

class BooksRepository {
  final FirestoreService _firestoreService;

  const BooksRepository({
    required FirestoreService firestoreService,
  }) : _firestoreService = firestoreService;

  Stream<List<BookModel>> getBooks(List<String> bookIds) {
    if (bookIds.isEmpty) return Stream.value(const []);
    return _firestoreService.collectionStream<BookModel>(
      path: 'books',
      queryBuilder: (query) => query
          .where(
            FieldPath.documentId,
            whereIn: bookIds,
          ),
      builder: (json, docId) => BookModel.fromJson(json!),
    );
  }

  Future<void> addBook({
    required String bookId,
    required JSON body,
  }) {
    return _firestoreService.insertData(
      path: 'books',
      id: bookId,
      data: body,
    );
  }

  Future<void> updateBook({
    required String bookId,
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
  );
  static const _user2 = UserModel(
    uid: '2',
    displayName: 'Farah Saleem',
    email: 'farah.saleem@gmail.com',
  );
  static const _user3 = UserModel(
    uid: '3',
    displayName: 'Muhammad Zain',
    email: 'm.zain@gmail.com',
  );

  @override
  Stream<List<BookModel>> getBooks(List<String> bookIds) {
    final list = [
      BookModel.fromJson({
        'id': '1',
        'name': 'Book 1',
        'description': 'Book 1 description',
        'color': 'F9C27B0',
        'currency_name': 'PKR',
        'members': <String, JSON>{
          _user.uid: {'image': _user.imageUrl, 'role': MemberRole.owner.name},
          _user2.uid: {
            'image': _user2.imageUrl,
            'role': MemberRole.editor.name
          },
          _user3.uid: {
            'image': _user3.imageUrl,
            'role': MemberRole.viewer.name
          },
          '4': {'image': _user3.imageUrl, 'role': MemberRole.editor.name},
        },
      }),
      BookModel.fromJson({
        'id': '10',
        'name': 'Book 10',
        'description': 'Book 10 description',
        'color': 'F9B1C10',
        'currency_name': 'PKR',
        'members': <String, JSON>{
          _user.uid: {'image': _user.imageUrl, 'role': MemberRole.owner.name},
          _user2.uid: {
            'image': _user2.imageUrl,
            'role': MemberRole.editor.name
          },
          _user3.uid: {
            'image': _user3.imageUrl,
            'role': MemberRole.viewer.name
          },
          '4': {'image': _user2.imageUrl, 'role': MemberRole.editor.name},
          '5': {'image': _user3.imageUrl, 'role': MemberRole.viewer.name},
          '6': {'image': _user2.imageUrl, 'role': MemberRole.editor.name},
          '7': {'image': _user3.imageUrl, 'role': MemberRole.viewer.name},
        },
      }),
      BookModel(
        id: '2',
        name: 'Book 2',
        description: 'Book 2 description',
        color: Colors.deepOrangeAccent,
        currencyName: 'USD',
        members: {
          _user2.uid: BookMemberModel(
            imageUrl: _user2.imageUrl,
            role: MemberRole.owner,
          ),
          _user.uid: BookMemberModel(
            imageUrl: _user.imageUrl,
            role: MemberRole.viewer,
          ),
          _user3.uid: BookMemberModel(
            imageUrl: _user3.imageUrl,
            role: MemberRole.viewer,
          ),
        },
      ),
      BookModel(
        id: '3',
        name: 'Book 3',
        description: 'Book 3 description',
        color: Colors.teal,
        currencyName: 'AED',
        members: {
          _user3.uid: BookMemberModel(
            imageUrl: _user3.imageUrl,
            role: MemberRole.owner,
          ),
          _user2.uid: BookMemberModel(
            imageUrl: _user2.imageUrl,
            role: MemberRole.editor,
          ),
        },
      ),
    ];
    return Stream.value(
      list.where((book) => bookIds.contains(book.id)).toList(),
    );
  }

  @override
  FirestoreService get _firestoreService => throw UnimplementedError();

  @override
  Future<void> addBook({required JSON body, required String bookId}) {
    throw CustomException.unimplemented();
  }

  @override
  Future<void> updateBook({required String bookId, required JSON changes}) {
    throw CustomException.unimplemented();
  }
}
