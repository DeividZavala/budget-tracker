import 'package:budget_tracker/models/transaction_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const String transactionsBoxKey = "transactionsBox";
  static const String balanceBoxKey = "balanceBox";
  static const String budgetBoxKey = "budgetBoxKey";

  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() {
    return _instance;
  }

  Future<void> initializeHive() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      // Just to make sure it doesn't initialize twice, it was causing some minor issues without this check
      Hive.registerAdapter(TransactionItemAdapter());
    }

    await Hive.openBox<double>(budgetBoxKey);
    await Hive.openBox<double>(balanceBoxKey);
    await Hive.openBox<TransactionItem>(transactionsBoxKey);
  }

  void saveTransactionItem(TransactionItem transaction) {
    Hive.box(transactionsBoxKey).add(transaction);
    saveBalance(transaction);
  }

  List<TransactionItem> getAllTransactionItems() {
    return Hive.box<TransactionItem>(transactionsBoxKey).values.toList();
  }

  Future<void> saveBalance(TransactionItem transaction) async {
    final balanceBox = Hive.box<double>(balanceBoxKey);
    final currentBalance = balanceBox.get("balance") ?? 0.0;
    if (transaction.isExpense) {
      balanceBox.put("balance", currentBalance + transaction.amount);
    } else {
      balanceBox.put("balance", currentBalance - transaction.amount);
    }
  }

  double getBalance() {
    return Hive.box<double>(balanceBoxKey).get("balance") ?? 0.0;
  }

  Future<void> saveBudget(double budget) {
    return Hive.box<double>(budgetBoxKey).put("budget", budget);
  }

  double getBudget() {
    return Hive.box<double>(budgetBoxKey).get("budget") ?? 10000.0;
  }

  LocalStorageService._internal();
}
