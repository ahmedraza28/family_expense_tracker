class TransactionFiltersModel {
  final int? year;
  final int? month;
  final int? categoryId;
  final bool incomeExpenseOnly;
  final bool balanceTransferOnly;

  TransactionFiltersModel({
    required this.incomeExpenseOnly,
    required this.balanceTransferOnly,
    this.year,
    this.month,
    this.categoryId,
  });

  @override
  String toString() {
    return 'TransactionFiltersModel(year: $year, month: $month, categoryId: $categoryId, incomeExpenseOnly: $incomeExpenseOnly, balanceTransferOnly: $balanceTransferOnly)';
  }
}
