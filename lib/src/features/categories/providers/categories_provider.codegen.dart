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

@Riverpod(keepAlive: true)
Stream<List<CategoryModel>> _categoriesStream(_CategoriesStreamRef ref) {
  final categories = ref.watch(categoriesProvider);
  return categories.getAllCategories();
}

@Riverpod(keepAlive: true)
Future<List<CategoryModel>> categoriesByType(
  CategoriesByTypeRef ref,
  CategoryType type,
) async {
  final categories = await ref.watch(_categoriesStreamProvider.future);
  return categories.where((category) => category.type == type).toList();
}

@Riverpod(keepAlive: true)
Future<Map<int, CategoryModel>> _categoriesMap(_CategoriesMapRef ref) async {
  final categories = await ref.watch(_categoriesStreamProvider.future);
  return {for (var e in categories) e.id!: e};
}

@riverpod
CategoryModel categoryById(CategoryByIdRef ref, int id) {
  return ref.watch(_categoriesMapProvider).asData!.value[id]!;
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

  Stream<List<CategoryModel>> getAllCategories() {
    return _categoriesRepository.fetchAll(bookId: bookId);
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
    _categoriesRepository.create(
      bookId: bookId,
      body: category.toJson(),
    );
  }

  void updateCategory(CategoryModel category) {
    _categoriesRepository.update(
      bookId: bookId,
      categoryId: category.id!,
      changes: category.toJson(),
    );
  }
}
