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

/// A map of month names and number
const monthNames = {
  'January': 1,
  'February': 2,
  'March': 3,
  'April': 4,
  'May': 5,
  'June': 6,
  'July': 7,
  'August': 8,
  'September': 9,
  'October': 10,
  'November': 11,
  'December': 12,
};

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
