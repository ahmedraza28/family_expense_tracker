import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

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

  Stream<List<CategoryModel>> getBookCategories({required int bookId}) {
    return _firestoreService.collectionStream<CategoryModel>(
      path: 'books/$bookId/categories',
      builder: (json, docId) => CategoryModel.fromJson(json!),
    );
  }

  Future<void> addCategory({
    required int bookId,
    required CategoryModel category,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId/categories',
      data: category.toJson(),
    );
  }

  Future<void> updateCategory({
    required int bookId,
    required CategoryModel category,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId/categories/${category.id}',
      data: category.toJson(),
      merge: true,
    );
  }
}
