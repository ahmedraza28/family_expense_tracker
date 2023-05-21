// ignore_for_file: unused_import

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// Helpers
import '../../../helpers/constants/constants.dart';
import '../../../helpers/typedefs.dart';

// Features
import '../../balance_transfer/balance_transfer.dart';
import '../../categories/categories.dart';
import '../../transactions/transactions.dart';
import '../../wallets/wallets.dart';

part 'income_expense_model.codegen.freezed.dart';
part 'income_expense_model.codegen.g.dart';

@freezed
class IncomeExpenseModel extends TransactionModel with _$IncomeExpenseModel {
  static const categoryIdField = 'category_id';

  const factory IncomeExpenseModel({
    required String id,
    required double amount,
    required TransactionType type,
    required String walletId,
    required String categoryId,
    @JsonKey(toJson: AppUtils.dateToJson) required DateTime date,
    String? description,
  }) = _IncomeExpenseModel;

  const IncomeExpenseModel._();

  factory IncomeExpenseModel.fromJson(JSON json) =>
      _$IncomeExpenseModelFromJson(json);
}
