// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/typedefs.dart';

part 'wallet_model.codegen.freezed.dart';
part 'wallet_model.codegen.g.dart';

@freezed
class WalletModel with _$WalletModel {
  const factory WalletModel({
    required int id,
    required String name,
    required String imageUrl,
    required double balance,
  }) = _WalletModel;

  factory WalletModel.fromJson(JSON json) => _$WalletModelFromJson(json);
}
