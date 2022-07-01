
import 'package:flutterappwrite/features/auth/presentation/notifiers/auth_state.dart';
import 'package:flutterappwrite/features/transactions/presentations/notifiers/transaction_state.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(
    create: (context) => AuthState(),
  ),
  ChangeNotifierProvider(
    create: (context) => TransactionState(),
  )
];