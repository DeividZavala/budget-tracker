import 'package:hive/hive.dart';
part 'transaction_item.g.dart';

@HiveType(typeId: 1)
class TransactionItem {
  @HiveField(0)
  String title;
  @HiveField(1)
  double amount;
  @HiveField(2)
  bool isExpense;
  TransactionItem(
      {required this.amount, required this.title, this.isExpense = true});
}
