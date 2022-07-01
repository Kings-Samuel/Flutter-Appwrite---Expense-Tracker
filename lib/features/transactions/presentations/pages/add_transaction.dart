import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../data/model/transaction.dart';
import '../notifiers/transaction_state.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transaction;

  const AddTransactionScreen({
    Key? key,
    this.transaction,
  }) : super(key: key);
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime? today;
  DateTime? _tdate;
  TextEditingController? _titleController;
  TextEditingController? _amountController;
  TextEditingController? _descriptionController;
  bool? _isEdit;
  int? _transactionType;

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_null_comparison
    _isEdit = widget.transaction != null;
    _transactionType = _isEdit! ? widget.transaction!.transactionType : 1;
    today = DateTime.now();
    _tdate = _isEdit! ? widget.transaction!.transactionDate : today;
    _titleController = TextEditingController(
        text: _isEdit! ? widget.transaction!.title : null);
    _amountController = TextEditingController(
        text: _isEdit! ? widget.transaction!.amount.toString() : null);
    _descriptionController = TextEditingController(
        text: _isEdit! ? widget.transaction!.description : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit! ? 'Edit' : 'Add new'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: RadioListTile(
                  groupValue: _transactionType,
                  value: 2,
                  title: const Text("Expense"),
                  onChanged: (val) {
                    setState(() {
                      _transactionType = val as int?;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  groupValue: _transactionType,
                  value: 1,
                  title: const Text("Income"),
                  onChanged: (val) {
                    setState(() {
                      _transactionType = val as int?;
                    });
                  },
                ),
              ),
            ],
          ),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(hintText: "title"),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(hintText: "amount"),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: "description"),
          ),
          const SizedBox(height: 10.0),
          CalendarDatePicker(
            firstDate: DateTime(today!.year - 5),
            lastDate: today!,
            initialDate: _tdate!,
            onDateChanged: (date) {
              setState(() {
                _tdate = date;
              });
            },
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              String userId =
                  Provider.of<AuthState>(context, listen: false).user.id!;
              try {
                Transaction _transaction = Transaction(
                  id: _isEdit! ? widget.transaction!.id : null,
                  title: _titleController!.text,
                  amount: int.parse(_amountController!.text),
                  description: _descriptionController!.text,
                  transactionDate: _tdate,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  userId: userId,
                  transactionType: _transactionType,
                );
                TransactionState ts =
                    Provider.of<TransactionState>(context, listen: false);
                if (_isEdit!) {
                  await ts.updateTransaction(_transaction).whenComplete(() {
                    ts.getTransactions();
                    // Navigator.of(context).pop();
                    Navigator.pop(context);
                    Navigator.pop(context);
                    setState(() {
                      ts.getTransactions();
                    });
                    setState(() {
                      
                    });
                  });
                } else {
                  await ts.addTransaction(_transaction);
                  ts.getTransactions();
                  Navigator.pop(context);
                  ts.getTransactions();
                }
                setState(() {});
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
