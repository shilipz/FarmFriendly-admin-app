import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_admin/presentation/views/home/main_screens_nav.dart';
import 'package:cucumber_admin/presentation/views/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../../utils/constants/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int hour = now.hour;

    String greeting;
    if (hour >= 6 && hour < 12) {
      greeting = 'Good Morning';
    } else if (hour >= 12 && hour < 18) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }
    final User? user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
        backgroundColor: darkgreen,
        body: Stack(
          children: [
            Positioned.fill(
                child: Image.asset('assets/signin.png', fit: BoxFit.fill)),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SettingScreen()));
                        },
                        icon:
                            const Icon(Icons.settings, size: 32, color: kwhite))
                  ],
                ),
                FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('admin')
                        .doc(user?.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(child: Text('User not found.'));
                      } else {
                        var userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        var username = userData['username'];

                        return MainScreensNav(
                            greeting: greeting,
                            username: username,
                            context: context);
                      }
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}

showLoadingWidgets(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const RiveAnimation.asset('assets/196-360-loading.riv');
    },
  );
}
