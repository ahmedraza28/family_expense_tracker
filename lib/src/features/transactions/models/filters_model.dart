class FiltersModel {
  final int? year;
  final int? month;
  final int? categoryId;

  FiltersModel({
    this.year,
    this.month,
    this.categoryId,
  });

  @override
  String toString() {
    return '{year: $year, month: $month, categoryId: $categoryId}';
  }
}
