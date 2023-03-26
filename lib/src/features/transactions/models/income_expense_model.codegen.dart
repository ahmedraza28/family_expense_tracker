// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';
import '../enums/transaction_type_enum.dart';

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
  static const categoryIdField = 'category_id';

  const factory IncomeExpenseModel({
    @JsonKey(toJson: AppUtils.toNull, includeIfNull: false) required int? id,
    required double amount,
    required TransactionType type,
    required int walletId,
    required int categoryId,
    @JsonKey(toJson: AppUtils.dateToJson) required DateTime date,
    String? description,
  }) = _IncomeExpenseModel;

  const IncomeExpenseModel._();

  factory IncomeExpenseModel.fromJson(JSON json) =>
      _$IncomeExpenseModelFromJson(json);
}
