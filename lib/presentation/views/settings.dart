import 'package:cucumber_admin/presentation/views/login.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../utils/constants/constants.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: homeorange,
      body: Column(
        children: [
          const Arrowback(backcolor: kblack),
          TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Login(),
                ));
              },
              child: const Text(
                'Signout',
                style: TextStyle(color: kwhite, fontSize: 20),
              ))
        ],
      ),
    ));
  }
}
