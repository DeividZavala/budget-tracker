import 'package:budget_tracker/models/transaction_item.dart';
import 'package:budget_tracker/view_models/budget_view_model.dart';
import 'package:budget_tracker/widgets/add_transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) =>
                      AddTransactionDialog(itemToAdd: (transactionItem) {
                        final budgetViewModel = Provider.of<BudgetViewModel>(
                            context,
                            listen: false);
                        budgetViewModel.addItem(transactionItem);
                      }));
            },
            child: const Icon(Icons.add)),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            width: screenSize.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Consumer<BudgetViewModel>(
                      builder: ((context, value, child) {
                    final balance = value.getBalance(); // <- new
                    final budget = value.getBudget(); // <- new
                    double percentage = balance / budget;
                    // Making sure percentage isnt negative and isnt bigger than 1
                    if (percentage < 0) {
                      percentage = 0;
                    }
                    if (percentage > 1) {
                      percentage = 1;
                    }
                    return CircularPercentIndicator(
                      radius: screenSize.width / 2,
                      percent: percentage,
                      lineWidth: 5,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "\$${balance.toString().split(".")[0]}",
                            style: const TextStyle(
                                fontSize: 48, fontWeight: FontWeight.bold),
                          ),
                          const Text("Balance", style: TextStyle(fontSize: 18)),
                          Text(
                            "Budget: \$${budget.toString()}",
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      progressColor: Theme.of(context).colorScheme.primary,
                    );
                  })),
                ),
                const SizedBox(height: 35),
                const Text(
                  "Items",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Consumer<BudgetViewModel>(builder: ((context, value, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: value.items.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) =>
                        TransactionCard(transaction: value.items[index]),
                  );
                })),
              ],
            ),
          ),
        )));
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionItem transaction;
  const TransactionCard({required this.transaction, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Text("Delete Item"),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          final budgetViewModel = Provider.of<BudgetViewModel>(
                              context,
                              listen: false);
                          budgetViewModel.deleteItem(transaction);
                          Navigator.pop(context);
                        },
                        child: const Text("Delete"),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                    ],
                  )),
            );
          })),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, top: 5),
        child: Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: transaction.isExpense
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 50,
                  offset: const Offset(0, 25))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                (transaction.isExpense ? "- " : "+ ") +
                    transaction.amount.toString(),
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
