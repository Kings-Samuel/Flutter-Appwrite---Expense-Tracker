import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/routes.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../data/model/transaction.dart';

class TransactionListItem extends StatefulWidget {
  final Transaction transaction;
  const TransactionListItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  State<TransactionListItem> createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  String? currency;

  Future<Preferences> _getCurrency(BuildContext context) async {
    return await context.read<AuthState>().getAccount.getPrefs().then((value) {
      currency = value.data['currency']['symbol'].toString();
      // if (kDebugMode) {
      //   print('currency: $currency');
      // }
      return value;
    });
  }

  @override
  void initState() {
    _getCurrency(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return ListTile(
            leading: Icon(
                widget.transaction.transactionType == 1 ? Icons.money : Icons.payment),
            title: Text(widget.transaction.title!),
            subtitle:
                Text(DateFormat.yMMMEd().format(widget.transaction.transactionDate!)),
            trailing: Text("$currency ${widget.transaction.amount}"),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.transactionDetails,
                  arguments: widget.transaction);
            },
          );
        });
  }
}
