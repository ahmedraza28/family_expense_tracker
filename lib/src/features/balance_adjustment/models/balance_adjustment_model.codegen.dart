// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';

// Features
import '../../transactions/transactions.dart';
import '../../wallets/wallets.dart';

part 'balance_adjustment_model.codegen.freezed.dart';
part 'balance_adjustment_model.codegen.g.dart';

@freezed
class BalanceAdjustmentModel extends TransactionModel
    with _$BalanceAdjustmentModel {
  const factory BalanceAdjustmentModel({
    @JsonKey(toJson: AppUtils.toNull, includeIfNull: false) required int? id,
    required double amount,
    required double previousAmount,
    required DateTime date,
    required int walletId,
    @Default(TransactionType.adjustment) TransactionType type,
  }) = _BalanceAdjustmentModel;

  const BalanceAdjustmentModel._();

  factory BalanceAdjustmentModel.fromJson(JSON json) =>
      _$BalanceAdjustmentModelFromJson(json);

  bool get isDecrement => previousAmount > amount;

  @override
  String? get description => null;
}
