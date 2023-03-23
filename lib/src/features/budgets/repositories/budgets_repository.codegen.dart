import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/typedefs.dart';

// Models
import '../models/budget_model.codegen.dart';

part 'budgets_repository.codegen.g.dart';

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
BudgetsRepository budgetsRepository(BudgetsRepositoryRef ref) {
  final firestoreService = ref.read(firestoreServiceProvider);
  // return BudgetsRepository(firestoreService);
  return MockBudgetsRepository();
}

class BudgetsRepository {
  final FirestoreService _firestoreService;

  const BudgetsRepository(this._firestoreService);

  Stream<List<BudgetModel>> getBookBudgets({
    required int bookId,
    int? year,
    int? month,
    int? categoryId,
  }) {
    return _firestoreService.collectionStream<BudgetModel>(
      path: 'books/$bookId/budgets',
      queryBuilder: (query) {
        if (year != null) {
          query = query.where('year', isEqualTo: year);
        }
        if (month != null) {
          query = query.where('month', isEqualTo: month);
        }
        if (categoryId != null) {
          query = query.where('categoryId', isEqualTo: categoryId);
        }
        return query;
      },
      builder: (json, docId) => BudgetModel.fromJson(json!),
    );
  }

  Future<void> addBudget({
    required int bookId,
    required JSON body,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId/budgets',
      data: body,
    );
  }

  Future<void> updateBudget({
    required int bookId,
    required int budgetId,
    required JSON changes,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId/budgets/$budgetId',
      data: changes,
      merge: true,
    );
  }
}

class MockBudgetsRepository implements BudgetsRepository {
  @override
  Stream<List<BudgetModel>> getBookBudgets({
    required int bookId,
    int? year,
    int? month,
    int? categoryId,
  }) {
    return Stream.value([]);
  }

  @override
  Future<void> addBudget({
    required int bookId,
    required JSON body,
  }) async {}

  @override
  Future<void> updateBudget({
    required int bookId,
    required int budgetId,
    required JSON changes,
  }) async {}

  @override
  FirestoreService get _firestoreService => throw UnimplementedError();
}
