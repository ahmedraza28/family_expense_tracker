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

  TransactionFiltersModel get filters =>
      state ?? const TransactionFiltersModel();

  void setMonth(int? month) {
    state = filters.copyWith(month: month, allowNull: true);
  }

  void setYear(int? year) {
    state = filters.copyWith(year: year, allowNull: true);
  }

  void setCategory(CategoryModel? category) {
    state = filters.copyWith(categoryId: category?.id, allowNull: true);
  }

  TransactionFiltersModel _addType(TransactionType type) {
    return filters.copyWith(types: [...?filters.types, type]);
  }

  TransactionFiltersModel _removeType(TransactionType type) {
    filters.types?.remove(type);
    return filters.copyWith(types: [...?filters.types]);
  }

  void toggleType(TransactionType type, bool isChecked) {
    if (isChecked) {
      state = _addType(type);
    } else {
      state = _removeType(type);
    }
  }
}
