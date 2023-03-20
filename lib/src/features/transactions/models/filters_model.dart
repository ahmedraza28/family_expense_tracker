class FiltersModel {
  final DateTime? date;
  final int? categoryId;

  FiltersModel({
    this.date,
    this.categoryId,
  });

  bool get hasFilters => date != null || categoryId != null;
}
