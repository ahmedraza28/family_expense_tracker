import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'jsonName')
enum TransactionType {
  balanceTransfer('balance_transfer'),
  incomeExpense('income_expense');

  final String jsonName;

  const TransactionType(this.jsonName);

  String get name => jsonName;
}
