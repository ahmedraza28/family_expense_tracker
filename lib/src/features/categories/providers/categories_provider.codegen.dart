import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/typedefs.dart';

// Models
import '../models/category_model.codegen.dart';

// Enums
import '../enums/category_type_enum.dart';

// Repositories
import '../repositories/categories_repository.codegen.dart';

// Features
import '../../books/books.dart';

part 'categories_provider.codegen.g.dart';

final selectedCategoryProvider = Provider<CategoryModel?>((ref) {
  return null;
});

final categoriesStreamProvider = StreamProvider<List<CategoryModel>>(
  (ref) {
    final categories = ref.watch(categoriesProvider);
    return categories.getAllCategories();
  },
);

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

  Stream<List<CategoryModel>> getAllCategories([JSON? queryParams]) {
    return _categoriesRepository.getBookCategories(bookId: bookId);
  }

  void addCategory({
    required String name,
    required String imageUrl,
    required CategoryType type,
    String? description,
  }) {
    final category = CategoryModel(
      id: null,
      name: name,
      imageUrl: imageUrl,
      type: type,
    );
    _categoriesRepository.addCategory(
      bookId: bookId,
      body: category.toJson(),
    );
  }

  void updateCategory(CategoryModel category) {
    _categoriesRepository.updateCategory(
      bookId: bookId,
      categoryId: category.id!,
      changes: category.toJson(),
    );
  }
}
