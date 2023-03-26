// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';

// Features
import '../../transactions/transactions.dart';
import '../../wallets/wallets.dart';

part 'balance_transfer_model.codegen.freezed.dart';
part 'balance_transfer_model.codegen.g.dart';

@freezed
class BalanceTransferModel extends TransactionModel
    with _$BalanceTransferModel {
  const factory BalanceTransferModel({
    @JsonKey(toJson: AppUtils.toNull, includeIfNull: false) required int? id,
    required double amount,
    required DateTime date,
    required int srcWalletId,
    required int destWalletId,
    @Default(TransactionType.transfer) TransactionType type,
    String? description,
  }) = _BalanceTransferModel;

  const BalanceTransferModel._();

  factory BalanceTransferModel.fromJson(JSON json) =>
      _$BalanceTransferModelFromJson(json);
}
