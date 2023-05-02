import 'package:riverpod_annotation/riverpod_annotation.dart';

// Core
import '../../../core/core.dart';

// Helpers
import '../../../helpers/extensions/extensions.dart';
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
    required String bookId,
    required int year,
    required int month,
    String? categoryId,
  }) {
    return _firestoreService.collectionStream<BudgetModel>(
      path: 'books/$bookId/budgets/$month-$year',
      queryBuilder: (query) {
        if (categoryId != null) {
          query = query.where(
            BudgetModel.categoryIdsField,
            arrayContains: categoryId,
          );
        }
        return query;
      },
      builder: (json, docId) => BudgetModel.fromJson(json!),
      sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
    );
  }

  Future<void> addBudget({
    required String bookId,
    required String budgetId,
    required int year,
    required int month,
    required JSON body,
  }) {
    return _firestoreService.insertData(
      path: 'books/$bookId/budgets/$month-$year',
      id: budgetId,
      data: body,
    );
  }

  Future<void> addAllBudgets({
    required String bookId,
    required int year,
    required int month,
    required List<JSON> body,
  }) {
    return _firestoreService.batchAdd(
      path: 'books/$bookId/budgets/$month-$year',
      docIdFinder: (body) => body['id']! as String,
      data: body,
    );
  }

  Future<void> updateBudget({
    required String bookId,
    required int year,
    required int month,
    required String budgetId,
    required JSON changes,
  }) {
    return _firestoreService.setData(
      path: 'books/$bookId/budgets/$month-$year/$budgetId',
      data: changes,
      merge: true,
    );
  }
}

class MockBudgetsRepository implements BudgetsRepository {
  @override
  Stream<List<BudgetModel>> getBookBudgets({
    required String bookId,
    required int year,
    required int month,
    String? categoryId,
  }) {
    final date = DateTime.now();
    final lastMonth = DateTime(date.year, date.month - 1);
    final list = [
      BudgetModel(
        id: '1',
        name: 'Food and snacks',
        categoryIds: ['1', '2'],
        amount: 20000,
        used: 11204,
        year: date.year,
        month: date.month,
      ),
      BudgetModel(
        id: '2',
        name: 'Vehicle and transport',
        categoryIds: ['2'],
        amount: 55000,
        used: 44897,
        year: date.year,
        month: date.month,
      ),
      BudgetModel(
        id: '3',
        name: 'Salary',
        categoryIds: ['3'],
        amount: 100000,
        used: 100000,
        year: date.year,
        isExpense: false,
        month: date.month,
      ),
      BudgetModel(
        id: '4',
        name: 'Food and snacks',
        categoryIds: ['1'],
        amount: 10000,
        used: 3000,
        year: lastMonth.year,
        month: lastMonth.month,
      ),
      BudgetModel(
        id: '5',
        name: 'Vehicle and transport',
        categoryIds: ['2'],
        amount: 39000,
        used: 55000,
        year: lastMonth.year,
        month: lastMonth.month,
      ),
      BudgetModel(
        id: '6',
        name: 'Salary',
        categoryIds: ['3'],
        amount: 90000,
        isExpense: false,
        used: 90000,
        year: lastMonth.year,
        month: lastMonth.month,
      ),
    ];
    return Stream.value(
      list.where((element) {
        if (element.year != year) {
          return false;
        }
        if (element.month != month) {
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
    required String bookId,
    required String budgetId,
    required int year,
    required int month,
    required JSON body,
  }) async =>
      Future.delayed(2.seconds, () => throw CustomException.unimplemented());

  @override
  Future<void> updateBudget({
    required String bookId,
    required int year,
    required int month,
    required String budgetId,
    required JSON changes,
  }) async =>
      Future.delayed(2.seconds, () => throw CustomException.unimplemented());

  @override
  FirestoreService get _firestoreService => throw UnimplementedError();

  @override
  Future<void> addAllBudgets({
    required String bookId,
    required int year,
    required int month,
    required List<JSON> body,
  }) async =>
      Future.delayed(2.seconds, () => throw CustomException.unimplemented());
}
