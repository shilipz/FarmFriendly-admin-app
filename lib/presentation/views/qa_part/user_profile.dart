import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_admin/presentation/views/qa_part/collected_veg_details.dart';
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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(docId)
                          .collection('contact_details')
                          .get(),
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
                                          Center(
                                            child: Captions(
                                                captionColor: darkgreen,
                                                captions: '$username'),
                                          ),
                                          lheight,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(
                                                'Address: ',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              Text(
                                                '$houseName\n $streetName\n$landmark',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          sheight,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(
                                                'Phone Number: ',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              Text(
                                                '$phoneNumber',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              )
                                            ],
                                          ),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SalesHistory(
                                                                  docId:
                                                                      docId))),
                                              child: const Text(
                                                  'Click here to see sales history',
                                                  style: TextStyle(
                                                      color: darkgreen,
                                                      fontSize: 18))),
                                          const Captions(
                                              captionColor: kdarkgreen,
                                              captions:
                                                  'Add Collection details'),
                                          sheight,
                                          Expanded(
                                              child: ListView.builder(
                                            itemCount: vegetablesList.length,
                                            itemBuilder: (context, index) {
                                              var vegId =
                                                  vegetablesList[index].id;
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
