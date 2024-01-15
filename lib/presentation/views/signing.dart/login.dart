import 'dart:developer';
import 'package:cucumber_admin/domain/auth.dart';
import 'package:cucumber_admin/main.dart';
import 'package:cucumber_admin/presentation/presentation_logic/bloc/login/login_bloc.dart';
import 'package:cucumber_admin/presentation/views/home/home_screen.dart';
import 'package:cucumber_admin/presentation/views/signing.dart/forgot_pwd.dart';
import 'package:cucumber_admin/presentation/widgets/signin_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'signup_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final _formkey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
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
  void dispose() {
    // Dispose the controllers when they are no longer needed to prevent memory leaks
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.16),
            child: Center(
                child: LoginHeading(
              signingText: 'Cucumber\nAdmin',
            )),
          ),
          lheight,
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.03,
                right: screenWidth * 0.13,
                left: screenWidth * 0.13),
            child: Form(
              key: _formkey,
              child: Column(children: [
                // Forms(
                //     customValidator: validateEmail,
                //     loginText: 'Email',
                //     inputController: emailController),
                SizedBox(
                  // width: 300,
                  height: 55,
                  child: TextFormField(
                    validator: validateEmail,
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: hintcolor),
                      prefix: const SizedBox(
                        width: 25,
                        height: 30,
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  // width: 300,
                  height: 50,
                  child: TextFormField(
                    obscureText: true,
                    validator: validatePassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: hintcolor),
                      prefix: const SizedBox(
                        width: 25,
                        height: 30,
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                // Forms(
                //     customValidator: validatePassword,
                //     loginText: 'Password',
                //     inputController: passwordController),

                SignUpButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      await _signin(context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ));
                    }
                  },
                  buttonText: 'Login',
                ),
                SizedBox(height: screenHeight * 0.015),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const ForgotPwd();
                      }));
                    },
                    child: const Text('forgot your password?')),
                SizedBox(height: screenHeight * 0.13),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SignUp())),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ));
                            },
                            child: const Text('SignUp',
                                style:
                                    TextStyle(fontSize: 24, color: darkgreen))),
                        const Icon(Icons.login, color: darkgreen, size: 45)
                      ]),
                )
              ]),
            ),
          )
        ]),
      )),
    );
  }

  showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const RiveAnimation.asset(
            'assets/511-976-dot-loading-loaders.riv');
      },
    );
  }

  Future<void> _signin(BuildContext context) async {
    showLoading(context);
    String email = emailController.text;
    String password = passwordController.text;
    context.read<LoginBloc>().add(LoginEvent(email: email, password: password));
    User? user = await _auth.signIn(email, password);

    if (user != null) {
      log("User is successfully signed in");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false,
      );
    } else {
      Navigator.pop(context);
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
