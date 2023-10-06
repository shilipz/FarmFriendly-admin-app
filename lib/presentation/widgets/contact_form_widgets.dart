import 'package:flutter/material.dart';

import '../../main.dart';
import '../../utils/constants/constants.dart';

class ContactForm extends StatelessWidget {
  final String? formHints;

  const ContactForm({this.formHints, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: formHints,
          hintStyle: const TextStyle(color: Colors.white),
          prefix: const SizedBox(width: 25, height: 30),
          filled: true,
          fillColor: transOrange,
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

class Next extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  const Next({required this.buttonText, required this.buttonColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 90,
        height: 40,
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ))),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 18, color: kwhite),
          ),
        ),
      ),
    );
  }
}

class Captions extends StatelessWidget {
  final String captions;
  final Color captionColor;
  const Captions(
      {required this.captionColor, required this.captions, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Text(
        captions,
        style: TextStyle(color: captionColor, fontSize: screenWidth * 0.065),
      ),
    );
  }
}
