import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/category_model.codegen.dart';

// Enums
import '../enums/category_type_enum.dart';

// Repositories
import '../repositories/categories_repository.codegen.dart';

// Features
import '../../books/books.dart';

part 'categories_provider.codegen.g.dart';

final editCategoryProvider = StateProvider.autoDispose<CategoryModel?>((ref) {
  return null;
});

@Riverpod(keepAlive: true)
Stream<List<CategoryModel>> categoriesStream(
  CategoriesStreamRef ref,
  CategoryType type,
) {
  final categories = ref.watch(categoriesProvider);
  return categories.getAllCategories(type);
}

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
CategoriesProvider categories(CategoriesRef ref) {
  final categoriesRepository = ref.watch(categoriesRepositoryProvider);
  final bookId = ref.watch(selectedBookProvider)!.id!;
  return CategoriesProvider(categoriesRepository, bookId: bookId);
}

class CategoriesProvider {
  final int bookId;
  final CategoriesRepository _categoriesRepository;

  CategoriesProvider(
    this._categoriesRepository, {
    required this.bookId,
  });

  Stream<List<CategoryModel>> getAllCategories(CategoryType type) {
    return _categoriesRepository.getBookCategories(
      bookId: bookId,
      categoryType: type.name,
    );
  }

  void addCategory({
    required String name,
    required String imageUrl,
    required CategoryType type,
  }) {
    final category = CategoryModel(
      id: null,
      name: name,
      imageUrl: imageUrl,
      type: type,
    );
    _categoriesRepository.addCategory(
      bookId: bookId,
      categoryType: type.name,
      body: category.toJson(),
    );
  }

  void updateCategory(CategoryModel category) {
    _categoriesRepository.updateCategory(
      bookId: bookId,
      categoryId: category.id!,
      categoryType: category.type.name,
      changes: category.toJson(),
    );
  }
}
