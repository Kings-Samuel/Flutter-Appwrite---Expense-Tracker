import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterappwrite/core/presentation/notifiers/providers.dart';
import 'package:flutterappwrite/core/presentation/routes.dart';
import 'package:flutterappwrite/features/auth/presentation/notifiers/auth_state.dart';
import 'package:flutterappwrite/features/auth/presentation/screens/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'features/general/presentation/screens/home.dart';
import 'package:url_strategy/url_strategy.dart';
import 'features/transactions/presentations/notifiers/transaction_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  if (kDebugMode && !kIsWeb) {
    Wakelock.enable();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlutterAppwrite',
          theme: ThemeData(
            primarySwatch: Colors.red,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.mcLarenTextTheme(
              Theme.of(context).textTheme,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              fixedSize: MaterialStateProperty.all<Size>(const Size(400, 50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Colors.red))),
            )),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          home:  const MainScreen(),
        //   Consumer<AuthState>(builder: ((context, state, child) {
        //     return state.isLoggedIn ? const HomeScreen() : const SignupScreen();
        //   })
        // ),
        onGenerateRoute: AppRoutes.generateRoute
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    Provider.of<AuthState>(context, listen: false).getUser();
    Provider.of<TransactionState>(context, listen: false).transactions;
    Provider.of<TransactionState>(context, listen: false).getTransactions();
    setState(() { });    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AuthState>(context, listen: false).getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); 
        } else {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const SignupScreen();
          }
        }
      },
    );
  }
}
