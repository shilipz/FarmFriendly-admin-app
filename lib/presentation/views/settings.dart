import 'package:cucumber_admin/presentation/views/signing.dart/login.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                showAlertDialog(context);
              },
              child: const Text(
                'Signout',
                style: TextStyle(color: kwhite, fontSize: 20),
              ))
        ],
      ),
    ));
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('cancel'),
          ),
          TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Sign Out'))
        ],
      ),
    );
  }
}
