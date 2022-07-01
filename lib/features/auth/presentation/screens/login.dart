import 'package:flutter/material.dart';
import 'package:flutterappwrite/features/auth/presentation/notifiers/auth_state.dart';
import 'package:flutterappwrite/main.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); 
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: ((context, value, child) {
        return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Flutter Appwrite',),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Login', style: Theme.of(context).textTheme.headline3,),
                const SizedBox(height: 30.0),
                buildtextField(
                  'email', 
                  _emailController, 
                  Icons.email_outlined,
                  // obscureText : false,
                ),
                const SizedBox(height: 10.0),
                buildtextField(
                  'password', 
                  _passwordController, 
                  Icons.lock_outline,
                  // obscureText : true,
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {
                    // state.account.create(userId: userId, email: email, password: password).then((value) => null);
                    setState(() {
                      _isLoading = true;
                    });
                    AuthState state = Provider.of<AuthState>(context, listen: false);
                    state.login(_emailController.text, _passwordController.text).then((user) => {
                      if (state.isLoggedIn) {
                         setState(() {
                      _isLoading = false;
                    }),
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MyApp() ), (route) => false)
                      } else {
                         setState(() {
                      _isLoading = false;
                    }),
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login failed'),
                          ),
                        ),
                      }
                    });
                    // setState(() {
                    //   Future.delayed(const Duration(seconds: 10), () {
                    //     setState(() {
                          
                    //      });
                    //     if (value.account.) {
                    //       _isLoading = false;
                    //       Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (Route<dynamic> route) => false);                        
                    //     } else {
                    //       setState(() {
                    //         _isLoading = false;
                    //       });
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(
                    //           content: Text('Login failed'),
                    //         ),
                    //       );
                    //     }
                    //   });
                    // });
                    // // Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (Route<dynamic> route) => false);
                  },
                  child: _isLoading == false ? const Text('Login') : 
                    Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: 35,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: const CircularProgressIndicator(color: Colors.white,),
                  ),
                )
              ],
            ),
          ),
        )
      );
      }),
    );
  }

  Widget buildtextField(String hintText, TextEditingController controller, IconData icon,)  {
    bool obscureText = hintText == 'password' ? true :  false;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: obscureText == true ? IconButton(
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          }, 
          icon: Icon(icon),
        ) : Icon(icon),
      ),
    );
  }
}