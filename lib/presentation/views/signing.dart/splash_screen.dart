import 'package:cucumber_admin/presentation/views/home/home_screen.dart';
import 'package:cucumber_admin/presentation/views/signing.dart/login.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      FirebaseAuth auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Login(),
        ));
      }
    });
    return Scaffold(
      backgroundColor: kwhite,
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return const HomeScreen();
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something Went Wrong"),
              );
            }
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Center(
                    //  child:
                    Text('Cucumber',
                        style: GoogleFonts.playfairDisplay(
                            textStyle: const TextStyle(
                                color: homeorange,
                                letterSpacing: 5,
                                fontSize: 46,
                                fontWeight: FontWeight.bold))),
                    // ),
                  ],
                ));
          }),
    );
  }
}
