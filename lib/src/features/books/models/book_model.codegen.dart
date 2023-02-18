// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/typedefs.dart';

// Features
import '../../auth/auth.dart';

part 'book_model.codegen.freezed.dart';
part 'book_model.codegen.g.dart';

@freezed
class BookModel with _$BookModel {
  const factory BookModel({
    required int id,
    required String name,
    required String description,
    required UserModel createdBy,
  }) = _BookModel;

  factory BookModel.fromJson(JSON json) => _$BookModelFromJson(json);
}
