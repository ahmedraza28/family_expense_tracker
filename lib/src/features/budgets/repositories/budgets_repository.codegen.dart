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
          query = query.where(BudgetModel.categoryIdsField, arrayContains: categoryId);
        }
        return query;
      },
      builder: (json, docId) => BudgetModel.fromJson(json!),
      sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
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
    final date = DateTime.now();
    final lastMonth = DateTime(date.year, date.month - 1);
    final list = [
      BudgetModel(
        id: 1,
        name: 'Food and snacks',
        categoryIds: [1],
        amount: 20000,
        year: date.year,
        month: date.month,
      ),
      BudgetModel(
        id: 2,
        name: 'Vehicle and transport',
        categoryIds: [2],
        amount: 55000,
        year: date.year,
        month: date.month,
      ),
      BudgetModel(
        id: 3,
        name: 'Salary',
        categoryIds: [3],
        amount: 100000,
        year: date.year,
        month: date.month,
      ),
      BudgetModel(
        id: 4,
        name: 'Food and snacks',
        categoryIds: [1],
        amount: 10000,
        year: lastMonth.year,
        month: lastMonth.month,
      ),
      BudgetModel(
        id: 5,
        name: 'Vehicle and transport',
        categoryIds: [2],
        amount: 39000,
        year: lastMonth.year,
        month: lastMonth.month,
      ),
      BudgetModel(
        id: 6,
        name: 'Salary',
        categoryIds: [3],
        amount: 90000,
        year: lastMonth.year,
        month: lastMonth.month,
      ),
    ];
    return Stream.value(
      list.where((element) {
        if (year != null && element.year != year) {
          return false;
        }
        if (month != null && element.month != month) {
          return false;
        }
        if (categoryId != null && element.categoryIds.contains(categoryId)) {
          return false;
        }
        return true;
      }).toList(),
    );
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
