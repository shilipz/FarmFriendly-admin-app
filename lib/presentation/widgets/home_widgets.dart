import 'package:cucumber_admin/presentation/views/settings.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../utils/constants/constants.dart';
import 'common_widgets.dart';

class HomeImg extends StatelessWidget {
  const HomeImg({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Image.asset('assets/home.jpg', fit: BoxFit.cover));
  }
}

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Arrowback(backcolor: kwhite),
        IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingScreen(),
              ));
            },
            icon: const Icon(Icons.settings, size: 32, color: kwhite)),
      ],
    );
  }
}

class HomeContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? notificatn;
  const HomeContainer(
      {this.notificatn, super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.1,
          decoration: const BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 23,
                      color: darkgreen,
                      fontWeight: FontWeight.w400)),
              Text(subtitle ?? "")
            ],
          ),
        ),
      ],
    );
  }
}
