import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';

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
  final categoriesProv = ref.watch(categoriesProvider.notifier);
  return categoriesProv.getAllCategories();
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
Future<Map<int, CategoryModel>> categoriesMap(CategoriesMapRef ref) async {
  final categories = await ref.watch(_categoriesStreamProvider.future);
  return {for (var e in categories) e.id!: e};
}

@Riverpod(keepAlive: true)
CategoryModel? categoryById(CategoryByIdRef ref, int? id) {
  return ref.watch(categoriesMapProvider).asData!.value[id];
}

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
class Categories extends _$Categories {
  late final int bookId;
  late final CategoriesRepository _categoriesRepository;

  @override
  FutureOr<void> build() {
    _categoriesRepository = ref.watch(categoriesRepositoryProvider);
    bookId = ref.watch(selectedBookProvider)!.id!;
    return null;
  }

  Stream<List<CategoryModel>> getAllCategories() {
    return _categoriesRepository.fetchAll(bookId: bookId);
  }

  Future<void> addCategory({
    required String name,
    required String imageUrl,
    required CategoryType type,
  }) async {
    state = const AsyncValue.loading();

    final category = CategoryModel(
      id: null,
      name: name,
      imageUrl: imageUrl,
      type: type,
    );

    state = await state.makeGuardedRequest(
      () {
        return _categoriesRepository.create(
          bookId: bookId,
          body: category.toJson(),
        );
      },
      errorMessage: 'Failed to add category',
    );
  }

  Future<void> updateCategory(CategoryModel category) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(
      () {
        return _categoriesRepository.update(
          bookId: bookId,
          categoryId: category.id!,
          changes: category.toJson(),
        );
      },
      errorMessage: 'Failed to update category',
    );
  }
}
