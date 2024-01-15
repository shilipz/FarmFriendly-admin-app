import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_admin/domain/models/in_sale.dart';
import 'package:cucumber_admin/main.dart';
import 'package:cucumber_admin/presentation/views/qa_part/location.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:intl/intl.dart';

class TodaysCollection extends StatelessWidget {
  const TodaysCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Row(
                  children: [
                    Arrowback(backcolor: darkgreen),
                    Captions(
                      captions: "Daily Schedule",
                      captionColor: darkgreen,
                    ),
                  ],
                ),
                Container(
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
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('insales')
                        .orderBy('collection_date')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No data available.'));
                      } else {
                        var inSales = snapshot.data!.docs.map((doc) {
                          return InSaleItem.fromFirestore(
                              doc.data() as Map<String, dynamic>);
                        }).toList();

                        return ListView.builder(
                          itemCount: inSales.length,
                          itemBuilder: (context, index) {
                            var saleItem = inSales[index];
                            var formattedDate = DateFormat('dd MMMM')
                                .format(saleItem.collectionDate);

                            return ListTile(
                                title:
                                    Text('Collection Date: ${formattedDate}'),
                                subtitle: Text('Farmer: ${saleItem.username}'),
                                trailing: TextButton(
                                    onPressed: () async {
                                      DocumentSnapshot userSnapshot =
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc()
                                              .get();

                                      if (userSnapshot.exists &&
                                          userSnapshot.data() != null) {
                                        Map<String, dynamic>? userData =
                                            userSnapshot.data()
                                                as Map<String, dynamic>?;

                                        if (userData != null &&
                                            userData.containsKey('latitude') &&
                                            userData.containsKey('longitude')) {
                                          var latitude = userData['latitude'];
                                          var longitude = userData['longitude'];

                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => Location(
                                              latitude: latitude,
                                              longitude: longitude,
                                            ),
                                          ));
                                        }
                                      }
                                    },
                                    child: Text('See location')));
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
      ),
    );
  }
}
