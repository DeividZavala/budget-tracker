import 'package:budget_tracker/models/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTransactionDialog extends StatefulWidget {
  final Function(TransactionItem) itemToAdd;
  const AddTransactionDialog({required this.itemToAdd, Key? key})
      : super(key: key);

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final TextEditingController itemTitleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool _isExpenseController = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.3,
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Text(
                  "Add expense",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 15),
                TextField(
                    controller: itemTitleController,
                    decoration:
                        const InputDecoration(hintText: "Name of the expense")),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(hintText: "Amount in \$"),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Is Expense?", style: TextStyle(fontSize: 16)),
                    Switch(
                        value: _isExpenseController,
                        onChanged: (bool status) {
                          setState(() {
                            _isExpenseController = status;
                          });
                        })
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () {
                      if (itemTitleController.text.isNotEmpty &&
                          amountController.text.isNotEmpty) {
                        widget.itemToAdd(TransactionItem(
                            title: itemTitleController.text,
                            amount: double.parse(amountController.text),
                            isExpense: _isExpenseController));
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add"))
              ],
            ),
          )),
    );
  }
}
