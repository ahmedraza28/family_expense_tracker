// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';

// Models
import 'transaction_model.dart';

// Features
import '../../balance_transfer/balance_transfer.dart';
import '../../categories/categories.dart';
import '../../wallets/wallets.dart';

part 'income_expense_model.codegen.freezed.dart';
part 'income_expense_model.codegen.g.dart';

@freezed
class IncomeExpenseModel extends TransactionModel with _$IncomeExpenseModel {
  const factory IncomeExpenseModel({
    @JsonKey(toJson: AppUtils.toNull, includeIfNull: false) required int? id,
    required double amount,
    @JsonKey(toJson: toWalletId) required WalletModel wallet,
    required int categoryId,
    @JsonKey(toJson: AppUtils.dateToJson) required DateTime date,
    String? description,
  }) = _IncomeExpenseModel;

  const IncomeExpenseModel._();

  factory IncomeExpenseModel.fromJson(JSON json) =>
      _$IncomeExpenseModelFromJson(json);

  @override
  bool search(String searchTerm) {
    return description?.toLowerCase().contains(searchTerm) ?? false;
  }

  @override
  bool get isBalanceTransfer => false;

  @override
  DateTime get transDate => date;
}
