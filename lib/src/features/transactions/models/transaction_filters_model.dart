import '../enums/transaction_type_enum.dart';

class TransactionFiltersModel {
  final int? year;
  final int? month;
  final int? categoryId;
  final List<TransactionType>? types;

  bool get hasTransfer => types?.contains(TransactionType.transfer) ?? false;
  bool get hasIncome => types?.contains(TransactionType.income) ?? false;
  bool get hasExpense => types?.contains(TransactionType.expense) ?? false;

  const TransactionFiltersModel({
    this.types,
    this.year,
    this.month,
    this.categoryId,
  });

  TransactionFiltersModel copyWith({
    int? year,
    int? month,
    int? categoryId,
    List<TransactionType>? types,
  }) {
    return TransactionFiltersModel(
      year: year ?? this.year,
      month: month ?? this.month,
      categoryId: categoryId ?? this.categoryId,
      types: types ?? this.types,
    );
  }

  @override
  String toString() {
    return 'TransactionFiltersModel(year: $year, month: $month, categoryId: $categoryId, type: ${types?.map((e) => e.name).toList()})';
  }
}
