// ignore_for_file: avoid_positional_boolean_parameters

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Models
import '../enums/transaction_type_enum.dart';
import '../models/transaction_filters_model.dart';

// Features
import '../../categories/categories.dart';

part 'transaction_filters_providers.codegen.g.dart';

final searchFilterProvider = StateProvider.autoDispose<String>(
  name: 'searchFilterProvider',
  (ref) => '',
);

@riverpod
class TransactionFilters extends _$TransactionFilters {
  @override
  TransactionFiltersModel? build() => null;

  TransactionFiltersModel get _filters =>
      state ?? const TransactionFiltersModel();

  void setMonth(int? month) {
    state = _filters.copyWith(month: month, allowNull: true);
  }

  void setYear(int? year) {
    state = _filters.copyWith(year: year, allowNull: true);
  }

  void setCategory(CategoryModel? category) {
    state = _filters.copyWith(categoryId: category?.id, allowNull: true);
  }

  TransactionFiltersModel _addType(TransactionType type) {
    return _filters.copyWith(types: [...?_filters.types, type]);
  }

  TransactionFiltersModel _removeType(TransactionType type) {
    _filters.types?.remove(type);
    return _filters.copyWith(types: [...?_filters.types]);
  }

  void toggleType(TransactionType type, bool isChecked) {
    if (isChecked) {
      state = _addType(type);
    } else {
      state = _removeType(type);
    }
  }
}
