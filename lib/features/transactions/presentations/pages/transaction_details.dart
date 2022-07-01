import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/routes.dart';
import '../../data/model/transaction.dart';
import '../notifiers/transaction_state.dart';

class TransactionDetails extends StatefulWidget {
  final Transaction? transaction;
  const TransactionDetails({Key? key, this.transaction}) : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {

  @override
  void initState() {
    Provider.of<TransactionState>(context, listen: false).getTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TransactionState>(context, listen: false).getTransactions();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.editTransaction,
                  arguments: widget.transaction);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: const Text(
                            "Are you sure you want to delete this transaction?"),
                        title: const Text("Confirm Delete"),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          TextButton(
                              child: const Text("Delete"),
                              onPressed: () async {
                                Provider.of<TransactionState>(context,
                                        listen: false)
                                    .deleteTransaction(widget.transaction!).then((value) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                              }),
                        ],
                      ));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      widget.transaction!.title!,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(DateFormat.yMMMEd()
                        .format(widget.transaction!.transactionDate!)),
                  ],
                ),
              ),
              Text(
                "${widget.transaction!.amount}",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          if (widget.transaction!.description != null &&
              widget.transaction!.description!.isNotEmpty)
            Text(widget.transaction!.description!),
        ],
      ),
    );
  }
}
