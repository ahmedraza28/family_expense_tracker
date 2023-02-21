// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/typedefs.dart';

// Features
import '../enums/category_type_enum.dart';

part 'category_model.codegen.freezed.dart';
part 'category_model.codegen.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required int id,
    required String name,
    required String imageUrl,
    required CategoryType categoryType,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(JSON json) => _$CategoryModelFromJson(json);
}
