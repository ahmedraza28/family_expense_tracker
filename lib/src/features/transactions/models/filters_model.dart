class FiltersModel {
  final int? year;
  final int? month;
  final int? categoryId;
  final bool incomeExpenseOnly;
  final bool balanceTransferOnly;

  FiltersModel({
    required this.incomeExpenseOnly,
    required this.balanceTransferOnly,
    this.year,
    this.month,
    this.categoryId,
  });

  @override
  String toString() {
    return '{year: $year, month: $month, categoryId: $categoryId}';
  }
}
