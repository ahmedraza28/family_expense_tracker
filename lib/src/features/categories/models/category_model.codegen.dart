// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';

part 'category_model.codegen.freezed.dart';
part 'category_model.codegen.g.dart';

int toCategoryId(CategoryModel category) => category.id!;

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @JsonKey(toJson: AppUtils.toNull, includeIfNull: false) required int? id,
    required String name,
    required String imageUrl,
    @JsonKey(toJson: AppUtils.toColorHex, fromJson: AppUtils.fromColorHex)
        required Color color,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(JSON json) => _$CategoryModelFromJson(json);
}
