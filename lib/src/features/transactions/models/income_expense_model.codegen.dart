// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';

// Enums
import '../enums/transaction_type_enum.dart';

// Models
import 'transaction_model.dart';

// Features
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
    @JsonKey(toJson: toCategoryId) required CategoryModel category,
    required DateTime date,
    @Default(TransactionType.incomeExpense) TransactionType type,
    String? description,
  }) = _IncomeExpenseModel;

  factory IncomeExpenseModel.fromJson(JSON json) =>
      _$IncomeExpenseModelFromJson(json);
}
