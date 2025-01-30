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
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF28a9e0)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/tweeter_logo.png"),
                    width: 200,
                  ),
                  SizedBox(height: 20),
                  const Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Receive an email to reset your password",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
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
                  SizedBox(height: 20),
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                        color: Color(0xFF28a9e0),
                        borderRadius: BorderRadius.circular(30)),
                    child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await verifyEmail();
                          }
                        },
                        child: const Text("Reset Password",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Back to Login",
                          style: TextStyle(
                              color: Color(0xFF28a9e0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold))),
                ])));
  }

  Future<void> verifyEmail() async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      if (!mounted) return;
      Navigator.of(context).pop(); // Remove loading dialog
      Utils.showSnackBar("Password reset email was sent");
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Remove loading dialog

      switch (e.code) {
        case 'user-not-found':
          Utils.showSnackBar('No user found with this email address');
          break;
        case 'invalid-email':
          Utils.showSnackBar('Invalid email address');
          break;
        default:
          Utils.showSnackBar(e.message ?? "An error occurred");
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Remove loading dialog
      Utils.showSnackBar("An error occurred. Please try again.");
    }
  }
}
