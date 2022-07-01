import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/transaction.dart';
import '../notifiers/transaction_state.dart';
import '../widgets/transaction_list_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  Timer? _debounce;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      Provider.of<TransactionState>(context, listen: false).query = query;
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    _debounce?.cancel();
    setState(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Transaction>? transactions =
        Provider.of<TransactionState>(context).searchResults;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: _queryController,
          decoration: const InputDecoration(
            hintText: "Search transaction",
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      body: ListView.builder(
          itemCount: transactions!.length,
          itemBuilder: (context, index) {
            Transaction transaction = transactions[index];

            return TransactionListItem(
              transaction: transaction,
            );
          }),
    );
  }
}
