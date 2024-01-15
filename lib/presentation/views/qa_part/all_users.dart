import 'dart:math';

import 'package:cucumber_admin/presentation/views/qa_part/user_profile.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../main.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: Alignment.bottomCenter,
                colors: [kwhite, lightgreen]),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  Arrowback(backcolor: darkgreen),
                  Captions(captionColor: darkgreen, captions: "All Users"),
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
                          var docId = users[index].id;
                          var random = Random();
                          var color = Color.fromRGBO(
                            random.nextInt(255),
                            random.nextInt(255),
                            random.nextInt(255),
                            1,
                          );

                          return InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserProfile(docId: docId))),
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
                              title: Text(username, style: commonText),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
