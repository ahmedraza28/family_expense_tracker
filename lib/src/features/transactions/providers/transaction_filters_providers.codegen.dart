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
    state = filters.copyWith(month: month);
  }

  void setYear(int? year) {
    state = filters.copyWith(year: year);
  }

  void setCategory(CategoryModel? category) {
    state = filters.copyWith(categoryId: category?.id);
  }

  void setTypes(List<TransactionType> types) {
    state = filters.copyWith(types: types);
  }

  void clear() {
    state = const TransactionFiltersModel();
  }

  TransactionFiltersModel _addType(TransactionType type) {
    final types = filters.types ?? [];
    return filters.copyWith(types: [...types, type]);
  }

  TransactionFiltersModel _removeType(TransactionType type) {
    final types = filters.types ?? [];
    return filters.copyWith(types: types.where((e) => e != type).toList());
  }

  void toggleType(TransactionType type, bool isChecked) {
    if (isChecked) {
      state = _addType(type);
    } else {
      state = _removeType(type);
    }
  }
}
