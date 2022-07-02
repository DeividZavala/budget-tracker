class TransactionItem {
  String title;
  double amount;
  bool isExpense;

  TransactionItem(
      {required this.title, required this.amount, this.isExpense = true});
}
