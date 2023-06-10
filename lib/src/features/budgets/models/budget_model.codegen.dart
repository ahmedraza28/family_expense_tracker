// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';

part 'budget_model.codegen.freezed.dart';
part 'budget_model.codegen.g.dart';

Object? _categoriesUsedFromJson(Map<dynamic, dynamic> json, String key) {
  return <String, double>{
    for (final categoryId
        in json[BudgetModel.categoryIdsField]!)
      categoryId.toString(): 0.0,
  };
}

@freezed
class BudgetModel with _$BudgetModel {
  static const categoryIdsField = 'category_ids';

  const factory BudgetModel({
    required String id,
    required List<String> categoryIds,
    required String name,
    required double amount,
    required int year,
    required int month,
    @Default({})
    @JsonKey(
      includeToJson: null,
      readValue: _categoriesUsedFromJson,
    )
    Map<String, double> categoriesUsed,
    @Default(0.0) @JsonKey(includeToJson: false) double used,
    @Default(true) bool isExpense,
    String? description,
  }) = _BudgetModel;

  factory BudgetModel.fromJson(JSON json) => _$BudgetModelFromJson(json);
}
