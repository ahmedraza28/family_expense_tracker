// ignore_for_file: no_default_cases

// Helpers
import '../../../helpers/typedefs.dart';
import '../../balance_adjustment/balance_adjustment.dart';
import '../enums/transaction_type_enum.dart';

// Models
import 'income_expense_model.codegen.dart';

// Features
import '../../balance_transfer/balance_transfer.dart';

abstract class TransactionModel {
  const TransactionModel();

  bool search(String searchTerm) {
    return description?.toLowerCase().contains(searchTerm) ?? false;
  }

  bool get isBalanceTransfer => type == TransactionType.transfer;
  bool get isExpense => type == TransactionType.expense;
  bool get isIncome => type == TransactionType.income;
  bool get isAdjustment => type == TransactionType.adjustment;
  TransactionType get type;
  DateTime get date;
  double get amount;
  String? get description;

  factory TransactionModel.fromJson(JSON json) {
    final type = TransactionType.values.byName(json['type']! as String);
    if (type == TransactionType.transfer) {
      return BalanceTransferModel.fromJson(json);
    } else if (type == TransactionType.adjustment) {
      return BalanceAdjustmentModel.fromJson(json);
    } else {
      return IncomeExpenseModel.fromJson(json);
    }
  }
}
