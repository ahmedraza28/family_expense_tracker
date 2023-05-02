class BudgetFiltersModel {
  final int? year;
  final int? month;
  final String? categoryId;

  const BudgetFiltersModel({
    this.year,
    this.month,
    this.categoryId,
  });

  BudgetFiltersModel copyWith({
    int? year,
    int? month,
    String? categoryId,
    bool allowNull = false,
  }) {
    return BudgetFiltersModel(
      year: allowNull ? year : year ?? this.year,
      month: allowNull ? month : month ?? this.month,
      categoryId: allowNull ? categoryId : categoryId ?? this.categoryId,
    );
  }

  @override
  String toString() {
    return 'BudgetFiltersModel(year: $year, month: $month, categoryId: $categoryId)';
  }
}
