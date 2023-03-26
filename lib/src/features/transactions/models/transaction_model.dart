// ignore_for_file: no_default_cases

// Helpers
import '../../../helpers/typedefs.dart';
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
  TransactionType get type;
  DateTime get date;
  String? get description;

  factory TransactionModel.fromJson(JSON json) {
    final isBalanceTransfer = json['type'] == TransactionType.transfer.name;

    return isBalanceTransfer
        ? BalanceTransferModel.fromJson(json)
        : IncomeExpenseModel.fromJson(json);
  }
}
