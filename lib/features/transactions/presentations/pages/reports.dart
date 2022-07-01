import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/model/transaction.dart';
import '../notifiers/transaction_state.dart';
import '../widgets/transaction_list_item.dart';
import 'package:in_date_utils/in_date_utils.dart' as date_utils;

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime? startDate;
  DateTime? endDate;
  DateTime? today;
  DateTime? last30days;
  int totalIncome = 0;
  int totalExpense = 0;
  bool loading = false;
  List<Transaction>? transactions;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    today = DateTime(today!.year, today!.month, today!.day); 

    last30days = DateTime.now();
    last30days = DateTime(today!.year, today!.month, today!.day - 30); 

    startDate = date_utils.DateUtils.firstDayOfWeek(last30days!);
    endDate = today;

    _getTransactions();
  }

  startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 0, 0, 0);
  endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59);

  _getTransactions() async {
    if (loading) return;
    setState(() {
      totalIncome = 0;
      totalExpense = 0;
      loading = true;
    });

    transactions = await Provider.of<TransactionState>(context, listen: false)
        .queryTransactions(from: startOfDay(startDate!), to: endOfDay(endDate!));
    if (transactions != null) {
      // ignore: avoid_function_literals_in_foreach_calls
      transactions!.forEach((transaction) {
        if (transaction.transactionType == 2) {
          totalExpense += transaction.amount!;
        } else if (transaction.transactionType == 1) {
          totalIncome += transaction.amount!;
        }
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              DateFormat.yMMMd().format(startDate!) +
                  " - " +
                  DateFormat.yMMMd().format(endDate!),
            ),
            onTap: () async {
              showDateRangePicker(context: context, firstDate: DateTime(today!.year - 5), lastDate: DateTime(today!.year + 5),)
                  .then((value) {
                if (value != null) {
                  setState(() {
                    startDate = value.start;
                    endDate = value.end;
                  });
                  _getTransactions();
                }
              });
            },
          ),
          const SizedBox(height: 10.0),
          if (loading) const Center(child: CircularProgressIndicator()),
          if (!loading) ...[
            Row(
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          const Text("Expense"),
                          Text("$totalExpense"),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          const Text("Income"),
                          Text("$totalIncome"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (transactions != null)
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: transactions!.length,
                itemBuilder: (BuildContext context, int index) {
                  return TransactionListItem(
                    transaction: transactions![index],
                  );
                },
              ),
          ],
        ],
      ),
    );
  }
}