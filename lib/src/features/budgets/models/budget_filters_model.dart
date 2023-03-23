class BudgetFiltersModel {
  final int? year;
  final int? month;
  final int? categoryId;

  BudgetFiltersModel({
    this.year,
    this.month,
    this.categoryId,
  });

  @override
  String toString() {
    return 'BudgetFiltersModel(year: $year, month: $month, categoryId: $categoryId)';
  }
}
