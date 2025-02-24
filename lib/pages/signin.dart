import 'package:demo/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../globals.dart';
import 'forgot_password.dart';
import 'signup.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _signInKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _signInKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/tweeter_logo.png"),
                    width: 200,
                  ),
                  SizedBox(height: 20),
                  const Text("Log in to Social Media",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: "Enter your Email",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your Email";
                          } else if (!emailValid.hasMatch(value)) {
                            return "Please enter a valid Email";
                          }
                          return null;
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: "Enter your Password",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your Password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        }),
                  ),
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                        color: Color(0xFF28a9e0),
                        borderRadius: BorderRadius.circular(30)),
                    child: TextButton(
                        onPressed: () async {
                          if (_signInKey.currentState!.validate()) {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Center(
                                      child: CircularProgressIndicator(),
                                    ));
                            try {
                              await _auth.signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                              ref
                                  .read(userProvider.notifier)
                                  .login(_emailController.text);
                            } catch (e) {
                              Utils.showSnackBar(e.toString());
                            }
                            navigatorKey.currentState!
                                .popUntil((route) => route.isFirst);
                          }
                        },
                        child: const Text("Log In",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                            color: Color(0xFF28a9e0),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgotPassword()));
                      }),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Signup(
                                  title: 'Signup',
                                )));
                      },
                      child: Text("Don't have an account? Sign up",
                          style: TextStyle(
                              color: Color(0xFF28a9e0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold))),
                ])));
  }
}
