// ignore_for_file: no_default_cases

// Helpers
import '../../../helpers/typedefs.dart';

// Models
import 'income_expense_model.codegen.dart';

// Features
import '../../balance_transfer/balance_transfer.dart';

abstract class TransactionModel {
  const TransactionModel();

  bool search(String searchTerm);

  bool get isBalanceTransfer;
  DateTime get date;

  factory TransactionModel.fromJson(JSON json) {
    final isBalanceTransfer = !json.containsKey('category_id');

    return isBalanceTransfer
        ? BalanceTransferModel.fromJson(json)
        : IncomeExpenseModel.fromJson(json);
  }
}
