import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_admin/main.dart';
import 'package:cucumber_admin/presentation/views/chat/chat.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // appBar: AppBar(
      //   backgroundColor: kwhite,
      //   title: const Text('All Chats',style: TextStyle(color: kdarkgreen),),
      // ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 206, 245, 210),
              Color.fromARGB(255, 111, 210, 115)
            ])),
        child: Column(
          children: [
            const Row(
              children: [
                Arrowback(backcolor: darkgreen),
                Captions(captionColor: darkgreen, captions: 'All Chats'),
              ],
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('users').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      var users = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          var username = users[index]['username'] ?? 'N/A';
                          var farmerId = users[index].id;
                          var random = Random();
                          var color = Color.fromRGBO(
                            random.nextInt(255),
                            random.nextInt(255),
                            random.nextInt(255),
                            1,
                          );
                          final user = FirebaseAuth.instance.currentUser;

                          return InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  farmerId: farmerId,
                                  receiverName: username,
                                  senderId: user!.uid,
                                  senderName: user.displayName ?? ''),
                            )),
                            child: ListTile(
                              leading: Container(
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color,
                                ),
                                child: Center(
                                  child: Text(
                                    username[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                username,
                                style: commonText,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    ));
  }
}
