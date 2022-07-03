import 'package:budget_tracker/models/transaction_item.dart';
import 'package:budget_tracker/services/budget_service.dart';
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
                        final budgetService =
                            Provider.of<BudgetService>(context, listen: false);
                        budgetService.addItem(transactionItem);
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
                  child: Consumer<BudgetService>(
                      builder: ((context, value, child) =>
                          CircularPercentIndicator(
                            radius: screenSize.width / 2,
                            percent: value.balance / value.budget,
                            lineWidth: 2,
                            center: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "\$${value.balance.toString().split(".")[0]}",
                                  style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text("Balance",
                                    style: TextStyle(fontSize: 18)),
                                Text(
                                  "Budget: \$${value.budget.toString()}",
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                            progressColor:
                                Theme.of(context).colorScheme.primary,
                          ))),
                ),
                const SizedBox(height: 35),
                const Text(
                  "Items",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Consumer<BudgetService>(builder: ((context, value, child) {
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
    return Padding(
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
    );
  }
}
