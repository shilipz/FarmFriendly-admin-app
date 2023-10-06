import 'package:cucumber_admin/presentation/views/chat_list_screen.dart';
import 'package:cucumber_admin/presentation/views/collection_adding.dart';
import 'package:cucumber_admin/presentation/views/products.dart';
import 'package:cucumber_admin/presentation/views/quality_check.dart';
import 'package:cucumber_admin/presentation/views/settings.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/constants/constants.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
        backgroundColor: homeorange,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // const HomeImg(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.person,
                        color: kwhite,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SettingScreen(),
                        ));
                      },
                      icon:
                          const Icon(Icons.settings, size: 32, color: kwhite)),
                ],
              ),
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                    // Loading indicator while data is being fetched
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text('User not found.'));
                  } else {
                    var userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    var username = userData['username'];

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(55),
                          child: Captions(
                              captionColor: kwhite, captions: 'Hi, $username'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => const TodaysPicks(),
                                )),
                                child: const HomeContainer(
                                    label: "Quality Analysis"),
                              ),
                              lheight,
                              InkWell(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => const Products(),
                                )),
                                child: const HomeContainer(label: "Products"),
                              ),
                              lheight,
                              InkWell(
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => const AddCollection(),
                                )),
                                child: const HomeContainer(
                                    label: "Today's area of collection"),
                              ),
                              lheight,
                              const InkWell(
                                child: HomeContainer(
                                  label: "This week's schedule",
                                ),
                              ),
                              lheight,
                              InkWell(
                                  onTap: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ChatListScreen(),
                                      )),
                                  child: HomeContainer(label: 'Chat Support')),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
