import 'package:flutter/material.dart';
import 'package:flutterappwrite/features/auth/presentation/screens/signup.dart';
import '../../features/auth/presentation/screens/login.dart';
import '../../features/auth/presentation/screens/profile.dart';
import '../../features/general/presentation/screens/home.dart';
import '../../features/settings/presentation/pages/settings.dart';
import '../../features/transactions/data/model/transaction.dart';
import '../../features/transactions/presentations/pages/add_transaction.dart';
import '../../features/transactions/presentations/pages/reports.dart';
import '../../features/transactions/presentations/pages/search_transaction.dart';
import '../../features/transactions/presentations/pages/transaction_details.dart';

class AppRoutes {
  static const String home = '/';
  static const String signup = '/signup';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String transactionDetails = '/transaction-details'; 
  static const String addTransaction = '/add-transaction';  
  static const String editTransaction = '/edit-transaction';  
  static const String search = '/search';  
  static const String reports = '/reports';  
  static const String settings = '/settings';  


  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (context) {
        switch (routeSettings.name) {
          case home:
            return const HomeScreen();
          case signup:
            return const SignupScreen();
          case login:
            return const LoginScreen();
          case profile:
            return const ProfileScreen();
          case transactionDetails:
            return TransactionDetails(transaction: routeSettings.arguments as Transaction);
          case addTransaction:
            return const AddTransactionScreen();
          case editTransaction:
            return AddTransactionScreen(transaction: routeSettings.arguments as Transaction);
          case search:
            return const SearchScreen();
          case reports:
            return const ReportsScreen();
          case settings:
            return const SettingsScreen();
          default:
            return const SignupScreen();
        }
      },
    );
  }
}
