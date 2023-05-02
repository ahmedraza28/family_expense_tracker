import '../enums/transaction_type_enum.dart';

class TransactionFiltersModel {
  final int? year;
  final int? month;
  final String? categoryId;
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
    String? categoryId,
    List<TransactionType>? types,
    bool allowNull = false,
  }) {
    return TransactionFiltersModel(
      year: allowNull ? year : year ?? this.year,
      month: allowNull ? month : month ?? this.month,
      categoryId: allowNull ? categoryId : categoryId ?? this.categoryId,
      types: allowNull ? types : types ?? this.types,
    );
  }

  @override
  String toString() {
    return 'TransactionFiltersModel(year: $year, month: $month, categoryId: $categoryId, type: ${types?.map((e) => e.name).toList()})';
  }
}
