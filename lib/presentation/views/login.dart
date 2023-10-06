import 'dart:developer';

import 'package:cucumber_admin/domain/auth.dart';
import 'package:cucumber_admin/presentation/views/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../utils/constants/constants.dart';
import '../widgets/signin_widgets.dart';
import 'signup_screen.dart';

class Login extends StatelessWidget {
  Login({super.key});
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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.16),
            child: const Center(child: LoginHeading()),
          ),
          lheight,
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.03,
                right: screenWidth * 0.13,
                left: screenWidth * 0.13),
            child: Column(children: [
              Forms(
                  customValidator: validateEmail,
                  loginText: 'Email',
                  inputController: emailController),
              SizedBox(height: screenHeight * 0.05),
              Forms(
                  customValidator: validatePassword,
                  loginText: 'Password',
                  inputController: passwordController),
              SizedBox(height: screenHeight * 0.05),
              SignUpButton(
                onPressed: () async {
                  // if (_formkey.currentState!.validate()) {
                  await _signin(context);
                  // }
                },
                //  _signin,
                // async {
                //   if (_formkey.currentState!.validate()) {
                //     validation(context);

                buttonText: 'Login',
              ),
              SizedBox(height: screenHeight * 0.015),
              const Text('forgot your password?'),
              SizedBox(height: screenHeight * 0.13),
              InkWell(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => SignUp())),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ));
                      },
                      child: const Text('SignUp',
                          style: TextStyle(fontSize: 24, color: darkgreen))),
                  const Icon(Icons.login, color: darkgreen, size: 45)
                ]),
              )
            ]),
          )
        ]),
      )),
    );
  }

  Future<void> _signin(BuildContext context) async {
    String email = emailController.text;

    String password = passwordController.text;
    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      log("User is successfully signed in");
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    } else {
      log("some error happened");
    }
  }
}
//   void validation(context) async {
//     ValidationResults result = await signIn(
//       usernameController.text,
//       passwordController.text,
//     );
//     if (result == ValidationResults.successfull) {
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => HomeScreen(),
//       ));
//     } else {}
//   }
// }

// enum ValidationResults {
//   successfull,
//   passwordIncorrect,
//   userNotFound,
//   somethingWentwrong
// }
