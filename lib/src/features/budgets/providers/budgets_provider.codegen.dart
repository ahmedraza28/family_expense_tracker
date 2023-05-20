import 'package:riverpod_annotation/riverpod_annotation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/extensions/extensions.dart';

// Models
import '../models/budget_filters_model.dart';
import '../models/budget_model.codegen.dart';

// Providers
import 'budget_filters_providers.codegen.dart';

// Repositories
import '../repositories/budgets_repository.codegen.dart';

// Features
import '../../books/books.dart';

part 'budgets_provider.codegen.g.dart';

@riverpod
Stream<List<BudgetModel>> filteredBudgetsStream(
  FilteredBudgetsStreamRef ref,
) {
  final filters = ref.read(budgetFiltersProvider);
  return ref.watch(budgetsProvider.notifier).getAllBudgets(filters);
}

/// A provider used to access instance of this service
@Riverpod(keepAlive: true)
class Budgets extends _$Budgets {
  static final _currentDate = DateTime.now();

  @override
  FutureOr<String?> build() => null;

  Stream<List<BudgetModel>> getAllBudgets([BudgetFiltersModel? filters]) {
    final bookId = ref.read(selectedBookProvider)!.id;
    final budgetsRepository = ref.read(budgetsRepositoryProvider);
    return budgetsRepository.getBookBudgets(
      bookId: bookId,
      year: filters?.year ?? _currentDate.year,
      month: filters?.month ?? _currentDate.month,
      categoryId: filters?.categoryId,
    );
  }

  /// Copies the given [List<BudgetModels>] to the current month
  Future<void> copyBudgets(List<BudgetModel> budgets) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(() async {
      final budgetsRepository = ref.read(budgetsRepositoryProvider);
      final bookId = ref.read(selectedBookProvider)!.id;
      await budgetsRepository.addAllBudgets(
        bookId: bookId,
        year: _currentDate.year,
        month: _currentDate.month,
        body: budgets.map((budget) => budget.toJson()).toList(),
      );
      return 'Budgets copied successfully';
    });
  }

  Future<void> addBudget({
    required int year,
    required String name,
    required int month,
    required List<String> categoryIds,
    required double amount,
    String? description,
  }) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(() async {
      final budget = BudgetModel(
        id: AppUtils.generateUuid(),
        year: year,
        name: name,
        month: month,
        categoryIds: categoryIds,
        amount: amount,
        description: description,
      );
      final budgetsRepository = ref.read(budgetsRepositoryProvider);
      final bookId = ref.read(selectedBookProvider)!.id;
      await budgetsRepository.addBudget(
        bookId: bookId,
        year: year,
        month: month,
        budgetId: budget.id,
        body: budget.toJson(),
      );

      return 'Budget created successfully';
    });
  }

  Future<void> updateBudget(BudgetModel budget) async {
    state = const AsyncValue.loading();

    state = await state.makeGuardedRequest(() async {
      final budgetsRepository = ref.read(budgetsRepositoryProvider);
      final bookId = ref.read(selectedBookProvider)!.id;
      await budgetsRepository.updateBudget(
        bookId: bookId,
        year: budget.year,
        month: budget.month,
        budgetId: budget.id,
        changes: budget.toJson(),
      );

      return 'Budget updated successfully';
    });
  }
}
