// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';

// Features
import '../../auth/auth.dart';
import '../../wallets/wallets.dart';

part 'book_model.codegen.freezed.dart';
part 'book_model.codegen.g.dart';

@freezed
class BookModel with _$BookModel {
  const factory BookModel({
    @JsonKey(toJson: AppUtils.toNull, includeIfNull: false) required int? id,
    required String name,
    @JsonKey(toJson: AppUtils.toColorHex, fromJson: AppUtils.fromColorHex)
        required Color color,
    required String description,
    @JsonKey(toJson: toCurrencyId) required CurrencyModel currency,
    required UserModel createdBy,
    @Default(0) double totalIncome,
    @Default(0) double totalExpense,
  }) = _BookModel;

  factory BookModel.fromJson(JSON json) => _$BookModelFromJson(json);
}
