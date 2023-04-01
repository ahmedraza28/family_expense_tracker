import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';

// Models
import '../models/category_model.codegen.dart';

// Repositories
import '../repositories/categories_repository.codegen.dart';

// Features
import '../../books/books.dart';

part 'categories_provider.codegen.g.dart';

@Riverpod(keepAlive: true)
Stream<List<CategoryModel>> categoriesStream(CategoriesStreamRef ref) {
  final categoriesProv = ref.watch(categoriesProvider.notifier);
  return categoriesProv.getAllCategories();
}

@Riverpod(keepAlive: true)
Future<Map<int, CategoryModel>> categoriesMap(CategoriesMapRef ref) async {
  final categories = await ref.watch(categoriesStreamProvider.future);
  return {for (var e in categories) e.id!: e};
}

@Riverpod(keepAlive: true)
CategoryModel? categoryById(CategoryByIdRef ref, int? id) {
  return ref.watch(categoriesMapProvider).asData!.value[id];
}

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
class Categories extends _$Categories {
  @override
  FutureOr<void> build() => null;

  Stream<List<CategoryModel>> getAllCategories() {
    final categoriesRepository = ref.watch(categoriesRepositoryProvider);
    final bookId = ref.watch(selectedBookProvider)!.id!;
    return categoriesRepository.fetchAll(bookId: bookId);
  }

  Future<void> addCategory({
    required String name,
    required String imageUrl,
    required Color color,
  }) async {
    state = const AsyncValue.loading();

    final category = CategoryModel(
      id: null,
      name: name,
      imageUrl: imageUrl,
      color: color,
    );

    final categoriesRepository = ref.watch(categoriesRepositoryProvider);
    final bookId = ref.watch(selectedBookProvider)!.id!;
    state = await state.makeGuardedRequest(
      () => categoriesRepository.create(
        bookId: bookId,
        body: category.toJson(),
      ),
      errorMessage: 'Failed to add category',
    );
  }

  Future<void> updateCategory(CategoryModel category) async {
    state = const AsyncValue.loading();

    final categoriesRepository = ref.watch(categoriesRepositoryProvider);
    final bookId = ref.watch(selectedBookProvider)!.id!;
    state = await state.makeGuardedRequest(
      () => categoriesRepository.update(
        bookId: bookId,
        categoryId: category.id!,
        changes: category.toJson(),
      ),
      errorMessage: 'Failed to update category',
    );
  }
}
