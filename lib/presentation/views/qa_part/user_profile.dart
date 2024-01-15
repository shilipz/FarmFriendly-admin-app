import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_admin/main.dart';
import 'package:cucumber_admin/presentation/views/qa_part/collected_veg_details.dart';
import 'package:cucumber_admin/presentation/views/qa_part/invoice/invoice.dart';
import 'package:cucumber_admin/presentation/views/qa_part/location.dart';
import 'package:cucumber_admin/presentation/views/qa_part/sales_history.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String docId;

  const UserProfile({
    super.key,
    required this.docId,
  });

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
              Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                      future:
                          FirebaseFirestore.instance.collection('users').get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return const Center(
                            child: Text("Contact Details haven't submitted"),
                          );
                        } else {
                          var contactDetails = snapshot.data!.docs;
                          var houseName = contactDetails[0]['houseName'];
                          var streetName = contactDetails[0]['streetName'];
                          var phoneNumber = contactDetails[0]['phoneNumber'];
                          var landmark = contactDetails.isNotEmpty
                              ? contactDetails[0]['landmark'] ?? 'N/A'
                              : 'N/A';
                          var latitude = contactDetails[0]['latitude'];
                          var longitude = contactDetails[0]['longitude'];
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(docId)
                                .get(),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (userSnapshot.hasError ||
                                  !userSnapshot.hasData) {
                                return const Center(
                                  child: Text('User data not available'),
                                );
                              } else {
                                var username =
                                    userSnapshot.data!['username'] ?? 'N/A';

                                return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(docId)
                                      .collection('selling_vegetables')
                                      .get(),
                                  builder: (context, vegsnapshot) {
                                    if (vegsnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (vegsnapshot.hasError) {
                                      return const Text('something went wrong');
                                    } else {
                                      var vegetablesList =
                                          vegsnapshot.data!.docs;
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Arrowback(
                                                  backcolor: darkgreen),
                                              Center(
                                                child: Captions(
                                                    captionColor: darkgreen,
                                                    captions: '$username'),
                                              ),
                                            ],
                                          ),
                                          lheight,
                                          Padding(
                                            padding: const EdgeInsets.all(24),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.home,
                                                        size: 32),
                                                    const SizedBox(width: 32),
                                                    Text(
                                                      '$houseName\n $streetName\n$landmark',
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    )
                                                  ],
                                                ),
                                                sheight,
                                                Row(
                                                  children: [
                                                    const Icon(Icons.phone,
                                                        size: 32),
                                                    const SizedBox(width: 32),
                                                    Text(
                                                      '$phoneNumber',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                sheight,
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.location_city,
                                                        size: 32),
                                                    const SizedBox(width: 32),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Location(
                                                              latitude:
                                                                  latitude,
                                                              longitude:
                                                                  longitude,
                                                            ),
                                                          ));
                                                        },
                                                        child: const Text(
                                                            'Show user location in map')),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () => Navigator
                                                      .of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          CompleteInvoice(
                                                              docId: docId))),
                                              child: const Text(
                                                  'Show complete invoice',
                                                  style: TextStyle(
                                                      color: kblack,
                                                      fontSize: 18,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      textBaseline: TextBaseline
                                                          .alphabetic))),
                                          sheight,
                                          const Center(
                                            child: Text(
                                                'Vegetables pending for collection will be listed below'),
                                          ),
                                          Expanded(
                                              child: ListView.builder(
                                            itemCount: vegetablesList.length,
                                            itemBuilder: (context, index) {
                                              var vegId =
                                                  vegetablesList[index].id;
                                              var vegPrice =
                                                  vegetablesList[index]
                                                      ['vegPrice'];
                                              var vegetableName =
                                                  vegetablesList[index]
                                                      ['vegetable_name'];
                                              var vegQuantity =
                                                  vegetablesList[index]
                                                          ['quantity']
                                                      .toString();
                                              // var collectionDayTimestamp =
                                              (vegetablesList[index]
                                                          ['collection_date']
                                                      as Timestamp)
                                                  .toDate();
                                              //var formattedCollectionDay =
                                              //DateFormat('dd-MM-yy').format(
                                              //  collectionDayTimestamp);

                                              return Card(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetails(
                                                        vegQuantity: vegQuantity
                                                            .toString(),
                                                        vegPrice: vegPrice,
                                                        vegId: vegId,
                                                        docId: docId,
                                                        vegetableName:
                                                            vegetableName,
                                                        //collectionDate: DateFormat(
                                                        //    'dd-MM-yy')
                                                        //  .parse(
                                                        //     formattedCollectionDay),
                                                      ),
                                                    ));
                                                  },
                                                  child: ListTile(
                                                    leading: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              color: kwhite),
                                                      width: 70,
                                                      height: 70,
                                                      child: Image.asset(
                                                          'assets/images.jpeg'),
                                                    ),
                                                    title: Text(vegetableName),
                                                    subtitle: Text(vegQuantity),
                                                    trailing:
                                                        const Icon(Icons.edit),
                                                    // trailing: Text(
                                                    //     formattedCollectionDay)
                                                  ),
                                                ),
                                              );
                                            },
                                          )),
                                        ],
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          );
                        }
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
