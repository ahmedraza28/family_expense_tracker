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

  Stream<List<CategoryModel>> getBookCategories({
    required int bookId,
    required String categoryType,
  }) {
    return _firestoreService.collectionStream<CategoryModel>(
      path: 'books/$bookId/categories/$categoryType',
      builder: (json, docId) => CategoryModel.fromJson(json!),
    );
  }

  Future<void> addCategory({
    required int bookId,
    required String categoryType,
    required JSON body,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId/categories/$categoryType',
      data: body,
    );
  }

  Future<void> updateCategory({
    required int bookId,
    required int categoryId,
    required String categoryType,
    required JSON changes,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId/categories/$categoryType/$categoryId',
      data: changes,
      merge: true,
    );
  }
}

class MockCategoriesRepository implements CategoriesRepository {
  @override
  Stream<List<CategoryModel>> getBookCategories({
    required int bookId,
    required String categoryType,
  }) {
    const list = [
      CategoryModel(
        id: 1,
        name: 'Category 1',
        imageUrl: 'https://picsum.photos/200/300',
        type: CategoryType.income,
      ),
      CategoryModel(
        id: 2,
        name: 'Category 2',
        imageUrl: 'https://picsum.photos/200/300',
        type: CategoryType.expense,
      ),
      CategoryModel(
        id: 3,
        name: 'Category 3',
        imageUrl: 'https://picsum.photos/200/300',
        type: CategoryType.expense,
      ),
      CategoryModel(
        id: 4,
        name: 'Category 4',
        imageUrl: 'https://picsum.photos/200/300',
        type: CategoryType.income,
      ),
    ];
    return Stream.value(
      list.where((element) => element.type.name == categoryType).toList(),
    );
  }

  @override
  Future<void> addCategory({
    required int bookId,
    required String categoryType,
    required JSON body,
  }) async {}

  @override
  Future<void> updateCategory({
    required int bookId,
    required int categoryId,
    required String categoryType,
    required JSON changes,
  }) async {}

  @override
  FirestoreService get _firestoreService => throw UnimplementedError();
}
