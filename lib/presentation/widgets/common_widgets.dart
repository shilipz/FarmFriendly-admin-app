import 'package:flutter/material.dart';

class Arrowback extends StatelessWidget {
  final Color backcolor;
  const Arrowback({required this.backcolor, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(17),
      child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 25, color: backcolor)),
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
    return Text(
      captions,
      style: TextStyle(
          color: captionColor, fontSize: 30, fontWeight: FontWeight.w600),
    );
  }
}
