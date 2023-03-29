import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  late final int bookId;
  late final BudgetsRepository _budgetsRepository;

  static final _currentDate = DateTime.now();

  @override
  FutureOr<void> build() {
    _budgetsRepository = ref.watch(budgetsRepositoryProvider);
    bookId = ref.watch(selectedBookProvider)!.id!;
    return null;
  }

  Stream<List<BudgetModel>> getAllBudgets([BudgetFiltersModel? filters]) {
    return _budgetsRepository.getBookBudgets(
      bookId: bookId,
      year: filters?.year ?? _currentDate.year,
      month: filters?.month ?? _currentDate.month,
      categoryId: filters?.categoryId,
    );
  }

  void addBudget({
    required int year,
    required String name,
    required int month,
    required List<int> categoryIds,
    required double amount,
    String? description,
  }) {
    final budget = BudgetModel(
      id: null,
      year: year,
      name: name,
      month: month,
      categoryIds: categoryIds,
      amount: amount,
      description: description,
    );
    _budgetsRepository.addBudget(
      bookId: bookId,
      body: budget.toJson(),
    );
  }

  void updateBudget(BudgetModel budget) {
    _budgetsRepository.updateBudget(
      bookId: bookId,
      budgetId: budget.id!,
      changes: budget.toJson(),
    );
  }
}
