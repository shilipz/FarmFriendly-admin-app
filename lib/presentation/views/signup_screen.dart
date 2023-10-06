import 'dart:developer';

import 'package:cucumber_admin/domain/auth.dart';
import 'package:cucumber_admin/presentation/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../utils/constants/constants.dart';
import '../widgets/common_widgets.dart';
import '../widgets/signin_widgets.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final _formkey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    return null;
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 80, right: 80),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Row(
                  children: [
                    const Arrowback(backcolor: kblack),
                    Captions(captionColor: transOrange, captions: 'Sign Up'),
                  ],
                ),
                lheight,
                Forms(
                  customValidator: validateUsername,
                  loginText: 'Username',
                  inputController: usernameController,
                ),
                lheight,
                Forms(
                  customValidator: validateEmail,
                  loginText: 'Email',
                  inputController: emailController,
                ),
                SizedBox(height: screenHeight * 0.05),
                Forms(
                  customValidator: validatePassword,
                  loginText: 'Password',
                  inputController: passwordController,
                ),
                SizedBox(height: screenHeight * 0.05),
                Forms(
                    customValidator: validatePassword,
                    loginText: 'Confirm Password'),
                SizedBox(height: screenHeight * 0.05),
                SignUpButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      await _signup(context);
                    }
                  },
                  buttonText: 'Sign Up',
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<void> _signup(BuildContext context) async {
    String email = emailController.text;
    String username = usernameController.text;
    String password = passwordController.text;
    User? user =
        await _auth.signUpWithEmailAndPassword(email, password, username);

    if (user != null) {
      log("User is successfully created");
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Login(),
      ));
    } else {
      log("some error happened");
    }
  }
}
