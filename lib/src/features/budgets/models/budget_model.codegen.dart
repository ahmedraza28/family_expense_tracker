// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';

part 'budget_model.codegen.freezed.dart';
part 'budget_model.codegen.g.dart';

@freezed
class BudgetModel with _$BudgetModel {
  static const categoryIdsField = 'category_ids';

  const factory BudgetModel({
    @JsonKey(toJson: AppUtils.toNull, includeIfNull: false) required int? id,
    required List<int> categoryIds,
    required String name,
    required double amount,
    required int year,
    required int month,
    String? description,
  }) = _BudgetModel;

  factory BudgetModel.fromJson(JSON json) => _$BudgetModelFromJson(json);
}
