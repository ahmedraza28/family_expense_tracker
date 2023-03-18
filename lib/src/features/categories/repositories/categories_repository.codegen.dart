import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/typedefs.dart';

// Enums
import '../enums/category_type_enum.dart';

// Models
import '../models/category_model.codegen.dart';

part 'categories_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
CategoriesRepository categoriesRepository(CategoriesRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  // return CategoriesRepository(firestoreService);
  return MockCategoriesRepository();
}

class CategoriesRepository {
  final FirestoreService _firestoreService;

  const CategoriesRepository(this._firestoreService);

  Stream<List<CategoryModel>> fetchAll({required int bookId}) {
    return _firestoreService.collectionStream<CategoryModel>(
      path: 'books/$bookId/categories',
      builder: (json, docId) => CategoryModel.fromJson(json!),
    );
  }

  Future<void> create({required int bookId, required JSON body}) {
    return _firestoreService.setData(
      path: 'books/$bookId/categories',
      data: body,
    );
  }

  Future<void> update({
    required int bookId,
    required int categoryId,
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
      'id': 3,
      'name': 'Salary',
      'image_url': 'https://i.imgur.com/1J8ZQYt.png',
      'type': 'income',
    };
  @override
  Stream<List<CategoryModel>> fetchAll({required int bookId}) {
    const list = [
      CategoryModel(
        id: 1,
        name: 'Food',
        imageUrl: 'https://picsum.photos/200/300',
        type: CategoryType.expense,
      ),
      CategoryModel(
        id: 2,
        name: 'Petrol And Maintainance',
        imageUrl: 'https://picsum.photos/200/300',
        type: CategoryType.expense,
      ),
      CategoryModel(
        id: 3,
        name: 'Salary',
        imageUrl: 'https://picsum.photos/200/300',
        type: CategoryType.income,
      ),
    ];
    return Stream.value(list);
  }

  @override
  Future<void> create({required int bookId, required JSON body}) async {}

  @override
  Future<void> update({
    required int bookId,
    required int categoryId,
    required JSON changes,
  }) async {}

  @override
  FirestoreService get _firestoreService => throw UnimplementedError();
}
