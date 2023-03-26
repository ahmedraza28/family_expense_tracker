import '../enums/transaction_type_enum.dart';

class TransactionFiltersModel {
  final int? year;
  final int? month;
  final int? categoryId;
  final List<TransactionType>? types;

  TransactionFiltersModel({
    this.types,
    this.year,
    this.month,
    this.categoryId,
  });

  @override
  String toString() {
    return 'TransactionFiltersModel(year: $year, month: $month, categoryId: $categoryId, type: ${types?.map((e) => e.name).toList()})';
  }
}
