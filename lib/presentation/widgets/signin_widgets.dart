import 'dart:developer';

import 'package:cucumber_admin/domain/auth.dart';
import 'package:cucumber_admin/presentation/views/home_screen.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../utils/constants/constants.dart';

class SignupStackImg extends StatelessWidget {
  const SignupStackImg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/signin.png'), fit: BoxFit.cover)));
  }
}

class LoginImage extends StatelessWidget {
  const LoginImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(65), bottomRight: Radius.circular(65)),
      child: Image.asset(
        'assets/signup_img.jpg',
        width: screenWidth,
        height: screenHeight * 0.33,
        fit: BoxFit.cover,
      ),
    );
  }
}

class LoginHeading extends StatelessWidget {
  const LoginHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Cucumber \n  Admin',
        style: TextStyle(
            color: lightgreen, fontSize: 36, fontWeight: FontWeight.bold));
  }
}

// ignore: must_be_immutable
class Forms extends StatelessWidget {
  final String loginText;
  final TextEditingController? inputController;
  final String? Function(String?)? customValidator;
  FocusNode? focusNode;
  Forms(
      {required this.customValidator,
      required this.loginText,
      this.inputController,
      Key? key,
      this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 300,
      height: 50,
      child: TextFormField(
        validator: (value) {
          if (customValidator != null) {
            final customError = customValidator!(value);
            if (customError != null) {
              return customError;
            }
          }
          return null;
        },
        controller: inputController,
        decoration: InputDecoration(
          hintText: loginText,
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
    );
  }
}

class LoginButton extends StatelessWidget {
  final String buttonText;
  final String email;
  final String password;
  const LoginButton(
      {required this.buttonText,
      super.key,
      required this.email,
      required this.password});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) {
          //     return HomeScreen();
          //   },
          // ));

          // await signInWithEmailAndPassword(email, password);
          log("hello");
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return HomeScreen();
            },
          ));

          log("helloooii");
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(lightgreen),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ))),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  final String buttonText;
  final Color? buttonColor;
  final Function()? onPressed;
  const SignUpButton(
      {required this.buttonText, super.key, required this.onPressed, this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(lightgreen),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ))),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class SignInCard extends StatelessWidget {
  final String cardtext;
  const SignInCard({required this.cardtext, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: screenWidth * 0.9,
        height: screenHeight * 0.20,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(cardtext, style: TextStyle(fontSize: 20, color: darkgreen)),
            TextButton(
                onPressed: () {},
                child: Text(cardtext,
                    style: const TextStyle(fontSize: 20, color: darkgreen))),
          ],
        ),
      ),
    );
  }
}
