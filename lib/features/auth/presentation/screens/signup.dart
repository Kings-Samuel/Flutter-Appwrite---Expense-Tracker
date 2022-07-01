import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterappwrite/core/presentation/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../notifiers/auth_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
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
              Text('Sign Up', style: Theme.of(context).textTheme.headline3,),
              const SizedBox(height: 10.0),
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: GoogleFonts.mcLaren(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: ' Login',
                      style: GoogleFonts.mcLaren(
                        color: Colors.red,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                            ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              buildtextField(
                'name', 
                _nameController, 
                Icons.person_outline_outlined
                // obscureText : false,
              ),
              const SizedBox(height: 10.0),
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
                  AuthState state = Provider.of<AuthState>(context, listen: false);
                  state.create(_nameController.text, _emailController.text, _passwordController.text);
                },
                child: const Text('Sign Up'),
              )
            ],
          ),
        ),
      )
    );
  }

  Widget buildtextField(String hintText, TextEditingController controller, IconData icon,)  {
    bool obscureText = hintText == 'password' ? true :  false;

    return TextField(
      controller: controller,
      obscureText: obscureText,
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