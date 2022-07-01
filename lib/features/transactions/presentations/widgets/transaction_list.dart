import 'package:flutter/material.dart';
import 'package:flutterappwrite/features/transactions/data/model/transaction.dart';
import 'package:flutterappwrite/features/transactions/presentations/widgets/transaction_list_item.dart';
import 'package:provider/provider.dart';
import '../notifiers/transaction_state.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List<Transaction>? transactions =
    //     Provider.of<TransactionState>(context, listen: false).transactions;
    // if (transactions!.isEmpty) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // } else {
    //   return ListView.builder(
    //         itemCount: transactions.length,
    //         itemBuilder: (context,index)  {
    //           Transaction transaction = transactions[index];
    //           return TransactionListItem(transaction: transaction);
    //         },
    //       );
    // }

    return FutureBuilder(
      future: Provider.of<TransactionState>(context).getTransactions(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Transaction> transactions = snapshot.data;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              Transaction transaction = transactions[index];
              return TransactionListItem(transaction: transaction);
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
