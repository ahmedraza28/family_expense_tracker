// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';

part 'currency_model.codegen.freezed.dart';
part 'currency_model.codegen.g.dart';

String toCurrencyId(CurrencyModel currency) => currency.name;

@freezed
class CurrencyModel with _$CurrencyModel {
  const factory CurrencyModel({
    required String name,
    required String symbol,
  }) = _CurrencyModel;

  factory CurrencyModel.fromJson(JSON json) => _$CurrencyModelFromJson(json);
}
