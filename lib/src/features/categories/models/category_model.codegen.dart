// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';

// Features
import '../enums/category_type_enum.dart';

part 'category_model.codegen.freezed.dart';
part 'category_model.codegen.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @JsonKey(toJson: AppUtils.toNull, includeIfNull: false) required int? id,
    required String name,
    required String imageUrl,
    required CategoryType type,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(JSON json) => _$CategoryModelFromJson(json);
}
