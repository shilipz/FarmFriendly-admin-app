import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesHistory extends StatelessWidget {
  final String docId;
  const SalesHistory({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Row(
              children: [
                Arrowback(backcolor: homeorange),
                Captions(captionColor: homeorange, captions: 'Sales History')
              ],
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(docId)
                    .collection('collected_vegetables')
                    .orderBy('collection_date', descending: true)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  } else {
                    var vegetablesList = snapshot.data!.docs;
                    vegetablesList.sort((a, b) {
                      var dateA = (a['collection_date']).toDate();
                      var dateB = (b['collection_date']).toDate();
                      return dateB.compareTo(dateA);
                    });

                    return Expanded(
                      child: ListView.builder(
                        itemCount: vegetablesList.length,
                        itemBuilder: (context, index) {
                          var vegetableName =
                              vegetablesList[index]['vegetable_name'];
                          // ignore: unused_local_variable
                          var vegQuantity =
                              vegetablesList[index]['quantity'].toString();
                          var timestamp = vegetablesList[index]
                              ['collection_date'] as Timestamp;
                          var vegCollectedDate = timestamp.toDate();

                          var formattedDateDDMonth =
                              DateFormat('dd MMMM').format(vegCollectedDate);

                          return Column(
                            children: [
                              Text(formattedDateDDMonth),
                              Card(
                                child: InkWell(
                                  onTap: () {},
                                  child: ListTile(
                                    leading: Container(
                                      decoration:
                                          const BoxDecoration(color: kwhite),
                                      width: 70,
                                      height: 70,
                                      child: Image.asset('assets/images.jpeg'),
                                    ),
                                    title: Text(vegetableName),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
