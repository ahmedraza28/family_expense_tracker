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
  static const String balanceField = 'balance';
  
  const factory WalletModel({
    required String id,
    required String name,
    @JsonKey(toJson: AppUtils.toColorHex, fromJson: AppUtils.fromColorHex)
        required Color color,
    required double balance,
    String? description,
    @Default(true) bool isEnabled,
  }) = _WalletModel;
  const WalletModel._();

  factory WalletModel.fromJson(JSON json) => _$WalletModelFromJson(json);
}
