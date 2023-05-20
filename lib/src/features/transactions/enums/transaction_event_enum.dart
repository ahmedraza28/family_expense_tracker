enum TransactionEvent {
  added('Transaction added successfully'),
  updated('Transaction updated successfully'),
  deleted('Transaction deleted successfully');

  const TransactionEvent(this.message);

  final String message;
}
