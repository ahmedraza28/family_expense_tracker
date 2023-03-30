// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';

// Models
import 'currency_model.codegen.dart';

part 'wallet_model.codegen.freezed.dart';
part 'wallet_model.codegen.g.dart';

@freezed
class WalletModel with _$WalletModel {
  const factory WalletModel({
    @JsonKey(toJson: AppUtils.toNull, includeIfNull: false) required int? id,
    required String name,
    @JsonKey(toJson: AppUtils.toColorHex, fromJson: AppUtils.fromColorHex)
        required Color color,
    required double balance,
    String? description,
  }) = _WalletModel;

  factory WalletModel.fromJson(JSON json) => _$WalletModelFromJson(json);
}
