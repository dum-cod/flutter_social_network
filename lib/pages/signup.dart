import 'package:demo/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../globals.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key, required this.title});

  final String title;

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();

  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _signUpKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/tweeter_logo.png"),
                    width: 200,
                  ),
                  SizedBox(height: 20),
                  const Text("Sign up to Social Media",
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
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: "Confirm your Password",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your Password";
                          } else if (value != _passwordController.text) {
                            return "Passwords do not match";
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
                          if (_signUpKey.currentState!.validate()) {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Center(
                                      child: CircularProgressIndicator(),
                                    ));
                            try {
                              await _auth.createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                              await ref
                                  .read(userProvider.notifier)
                                  .signUp(_emailController.text);
                              if (!mounted) return;
                            } catch (e) {
                              Utils.showSnackBar(e.toString());
                            }
                            navigatorKey.currentState!
                                .popUntil((route) => route.isFirst);
                          }
                        },
                        child: const Text("Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Already have an account? Sign in",
                          style: TextStyle(
                              color: Color(0xFF28a9e0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold))),
                ])));
  }
}
