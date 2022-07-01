import 'package:flutter/material.dart';
import 'package:flutterappwrite/core/presentation/routes.dart';
import '../../../transactions/presentations/widgets/transaction_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // refresh() {
  //   Provider.of<TransactionState>(context, listen: false).getTransactions();
  //   setState(() {});
  // }

  // @override
  // void initState() {
  //   Timer.periodic(const Duration(seconds: 2), (timer) {
  //     refresh();
  //     print('refreshing');
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.addTransaction);
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.reports);
                  },
                  icon: const Icon(Icons.receipt_long, color: Colors.red,),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.settings);
                  },
                  icon: const Icon(Icons.settings, color: Colors.red,),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Budgeter',
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.search);
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.profile);
              },
              icon: const Icon(Icons.person),
            )
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.all(15.0),
          child: TransactionList(),
        ));
  }
}
