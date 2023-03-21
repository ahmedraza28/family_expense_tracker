// ignore_for_file: no_default_cases

// Helpers
import '../../../helpers/typedefs.dart';

// Models
import 'income_expense_model.codegen.dart';

// Features
import '../../balance_transfer/balance_transfer.dart';

abstract class TransactionModel {
  const TransactionModel();

  bool search(String searchTerm) {
    return description?.toLowerCase().contains(searchTerm) ?? false;
  }

  bool get isBalanceTransfer;
  DateTime get date;
  String? get description;

  factory TransactionModel.fromJson(JSON json) {
    final isBalanceTransfer =
        !json.containsKey(IncomeExpenseModel.categoryIdField);

    return isBalanceTransfer
        ? BalanceTransferModel.fromJson(json)
        : IncomeExpenseModel.fromJson(json);
  }
}
