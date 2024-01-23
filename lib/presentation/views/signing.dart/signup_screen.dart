import 'package:cucumber_admin/main.dart';
import 'package:cucumber_admin/presentation/presentation_logic/bloc/signup/signup_bloc.dart';
import 'package:cucumber_admin/presentation/views/signing.dart/login.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cucumber_admin/presentation/widgets/signin_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
  void dispose() {
    // Dispose the controllers when they are no longer needed to prevent memory leaks
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Arrowback(backcolor: kblack),
            Padding(
              padding: const EdgeInsets.only(left: 80, right: 80),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.0005),
                      child:
                          LoginHeading(signingText: 'Join FarmFriendly family'),
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
                      obscureText: true,
                      inputController: passwordController,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Forms(
                        customValidator: validatePassword,
                        obscureText: true,
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
          ],
        ),
      )),
    );
  }

  Future<void> _signup(BuildContext context) async {
    String email = emailController.text;
    String username = _capitalizeFirstLetter(usernameController.text);
    String password = passwordController.text;

    context
        .read<SignupBloc>()
        .add(SignupEvent(username: username, email: email, password: password));
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Login(),
    ));
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }
}
