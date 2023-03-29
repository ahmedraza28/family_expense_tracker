class BudgetFiltersModel {
  final int? year;
  final int? month;
  final int? categoryId;

  const BudgetFiltersModel({
    this.year,
    this.month,
    this.categoryId,
  });

  BudgetFiltersModel copyWith({
    int? year,
    int? month,
    int? categoryId,
  }) {
    return BudgetFiltersModel(
      year: year ?? this.year,
      month: month ?? this.month,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  String toString() {
    return 'BudgetFiltersModel(year: $year, month: $month, categoryId: $categoryId)';
  }
}
