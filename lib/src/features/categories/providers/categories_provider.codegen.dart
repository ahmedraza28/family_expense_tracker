import 'package:hooks_riverpod/hooks_riverpod.dart';

// Models
import '../models/category_model.codegen.dart';

// Repositories
import '../repositories/categories_repository.codegen.dart';

// Features
import '../../books/books.dart';

// part 'categories_provider.codegen.g.dart';

/// Fetches a stream of [CategoryModel]s
final bookCategoriesProvider = StreamProvider<List<CategoryModel>>(
  (ref) {
    final bookId = ref.watch(selectedBookProvider)!.id;
    return ref
        .watch(categoriesRepositoryProvider)
        .getBookCategories(bookId: bookId);
  },
);
