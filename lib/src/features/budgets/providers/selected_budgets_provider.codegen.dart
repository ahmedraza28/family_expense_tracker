// ignore_for_file: avoid_positional_boolean_parameters

import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../models/budget_model.codegen.dart';

part 'selected_budgets_provider.codegen.g.dart';

@Riverpod(keepAlive: true)
class SelectedBudgets extends _$SelectedBudgets {
  @override
  List<BudgetModel> build() {
    return const [];
  }

  void addAll(List<BudgetModel> budgets) {
    state = [...state, ...budgets];
  }

  List<BudgetModel> _add(BudgetModel budget) {
    return [...state, budget];
  }

  List<BudgetModel> _remove(BudgetModel budget) {
    return state.where((e) => e != budget).toList();
  }

  void toggle(BudgetModel budget, bool isChecked) {
    if (isChecked) {
      state = _add(budget);
    } else {
      state = _remove(budget);
    }
  }
}
