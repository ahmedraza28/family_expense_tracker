import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';
import '../../../helpers/typedefs.dart';

// Models
import '../models/category_model.codegen.dart';

part 'categories_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
CategoriesRepository categoriesRepository(CategoriesRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  return CategoriesRepository(firestoreService);
  // return MockCategoriesRepository();
}

class CategoriesRepository {
  final FirestoreService _firestoreService;

  const CategoriesRepository(this._firestoreService);

  Stream<List<CategoryModel>> fetchAll({required String bookId}) {
    return _firestoreService.collectionStream<CategoryModel>(
      path: 'books/$bookId/categories',
      builder: (json, docId) => CategoryModel.fromJson(json!),
    );
  }

  Future<void> create({
    required String bookId,
    required String categoryId,
    required JSON body,
  }) {
    return _firestoreService.insertData(
      path: 'books/$bookId/categories',
      id: categoryId,
      data: body,
    );
  }

  Future<void> update({
    required String bookId,
    required String categoryId,
    required JSON changes,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId/categories/$categoryId',
      data: changes,
      merge: true,
    );
  }
}

class MockCategoriesRepository implements CategoriesRepository {
  final category3 = <String, dynamic>{
    'id': '3',
    'name': 'Salary',
    'color': '#FF000000',
  };
  @override
  Stream<List<CategoryModel>> fetchAll({required String bookId}) {
    const list = [
      CategoryModel(
        id: '3748e610-d6e9-4f02-a500-15bbecf724b0',
        name: 'Groceries',
        color: Colors.amber,
      ),
      CategoryModel(
        id: '041b2bd9-d783-43bb-99ff-c2dd8078d8f9',
        name: 'Petrol And Maintainance',
        color: Colors.blue,
      ),
      CategoryModel(
        id: '3',
        name: 'Salary',
        color: Colors.green,
      ),
    ];
    return Stream.value(list);
  }

  @override
  Future<void> create({
    required String bookId,
    required String categoryId,
    required JSON body,
  }) async =>
      Future.delayed(2.seconds, () => throw CustomException.unimplemented());

  @override
  Future<void> update({
    required String bookId,
    required String categoryId,
    required JSON changes,
  }) async =>
      Future.delayed(2.seconds, () => throw CustomException.unimplemented());

  @override
  FirestoreService get _firestoreService => throw UnimplementedError();
}
