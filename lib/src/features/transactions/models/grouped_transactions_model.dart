import 'daily_transactions_model.dart';

class GroupedTransactionsModel {
  final Map<int, DailyTransactionsModel> transactions;
  final double totalIncome;
  final double totalExpenses;
  final double totalArrears;

  const GroupedTransactionsModel({
    required this.transactions,
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalArrears,
  });
}
