import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/budget_filters_model.dart';
import '../models/budget_model.codegen.dart';

// Repositories
import '../repositories/budgets_repository.codegen.dart';

// Features
import '../../books/books.dart';

part 'budgets_provider.codegen.g.dart';

@Riverpod(keepAlive: true)
Stream<List<BudgetModel>> _budgetsStream(_BudgetsStreamRef ref) {
  final budgets = ref.watch(budgetsProvider.notifier);
  return budgets.getAllBudgets();
}

@Riverpod(keepAlive: true)
Future<Map<int, BudgetModel>> budgetsMap(BudgetsMapRef ref) async {
  final budgets = await ref.watch(_budgetsStreamProvider.future);
  return {for (var e in budgets) e.id!: e};
}

@Riverpod(keepAlive: true)
BudgetModel? budgetById(BudgetByIdRef ref, int? id) {
  return ref.watch(budgetsMapProvider).asData!.value[id];
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
    required int month,
    required int categoryId,
    required double amount,
    String? description,
  }) {
    final budget = BudgetModel(
      id: null,
      year: year,
      month: month,
      categoryId: categoryId,
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
