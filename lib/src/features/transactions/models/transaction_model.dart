// ignore_for_file: no_default_cases

// Helpers
import '../../../helpers/typedefs.dart';

// Enums
import '../enums/transaction_type_enum.dart';

// Models
import 'income_expense_model.codegen.dart';

// Features
import '../../balance_transfer/balance_transfer.dart';

abstract class TransactionModel {
  const TransactionModel();

  factory TransactionModel.fromJson(JSON json) {
    final type = TransactionType.values.firstWhere(
      (e) => e.name == json['transaction_type'] as String,
    );
    switch (type) {
      case TransactionType.balanceTransfer:
        return BalanceTransferModel.fromJson(json);
      case TransactionType.incomeExpense:
        return IncomeExpenseModel.fromJson(json);
      default:
        throw Exception('Invalid type');
    }
  }
}
