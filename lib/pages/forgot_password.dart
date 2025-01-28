import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../globals.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Reset Password"),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Receive an email to\nrest your password.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                            controller: emailController,
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
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            verifyEmail();
                            Navigator.of(context).pop();
                          },
                          child: Text("Reset password",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))),
                    ]))),
      );

  Future verifyEmail() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar("Password reset email was sent");
    } on Exception catch (e) {
      Utils.showSnackBar(e.toString());
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
