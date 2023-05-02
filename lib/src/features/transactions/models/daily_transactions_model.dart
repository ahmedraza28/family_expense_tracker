// Features
import 'transaction_model.dart';

class DailyTransactionsModel {
  final List<TransactionModel> transactions;
  final DateTime date;
  double netTotal;

  DailyTransactionsModel({
    required this.transactions,
    required this.date,
    required this.netTotal,
  });

  void addTransaction(TransactionModel transaction) {
    transactions.add(transaction);
    netTotal = transaction.isExpense
        ? netTotal - transaction.amount
        : netTotal + transaction.amount;
  }

  factory DailyTransactionsModel.fromList(
    List<TransactionModel> transactions,
  ) {
    final date = transactions.first.date;
    final netTotal = transactions.fold<double>(0, (sum, t) {
      return t.isExpense ? sum - t.amount : sum + t.amount;
    });
    return DailyTransactionsModel(
      transactions: transactions,
      date: date,
      netTotal: netTotal,
    );
  }
}
