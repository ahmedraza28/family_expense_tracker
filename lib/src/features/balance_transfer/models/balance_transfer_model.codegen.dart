// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
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
    required int id,
    required double amount,
    required DateTime date,
    @JsonKey(toJson: toWalletId) required WalletModel srcWallet,
    @JsonKey(toJson: toWalletId) required WalletModel destWallet,
    String? note,
  }) = _BalanceTransferModel;

  const BalanceTransferModel._();

  factory BalanceTransferModel.fromJson(JSON json) =>
      _$BalanceTransferModelFromJson(json);

  @override
  bool search(String searchTerm) {
    return note?.toLowerCase().contains(searchTerm) ?? false;
  }

  @override
  bool get isBalanceTransfer => true;
}