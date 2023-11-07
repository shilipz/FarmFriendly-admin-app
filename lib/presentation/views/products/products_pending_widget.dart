import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class PendingApprovalWidget extends StatelessWidget {
  const PendingApprovalWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: FutureBuilder(
          future: fetchPendingVegetables(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No pending requests.'));
            } else {
              List<DocumentSnapshot> pendingVegetables = snapshot.data!;
              return ListView.builder(
                itemCount: pendingVegetables.length,
                itemBuilder: (context, index) {
                  var vegetable = pendingVegetables[index];
                  var name = vegetable['name'];
                  var price = vegetable['price'];
                  var id = vegetable['id'];
                  return Card(
                    elevation: 10,
                    child: ListTile(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Product details'),
                            content: Text(name),
                            actions: <Widget>[
                              const Text(
                                  'After image a description about the vegetable'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Under review'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      approveVeggies(name, price);
                                      FirebaseFirestore.instance
                                          .collection('pending_approval')
                                          .doc(id)
                                          .delete();

                                      Navigator.pop(context);
                                    },
                                    child: const Text('Approve'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      tileColor: kwhite,
                      title: Text(name),
                      subtitle: Text('Price: $price'),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void approveVeggies(String name, var price) {
    FirebaseFirestore.instance
        .collection('vegetables')
        .add({'name': name, 'price': price});
  }
}

Future<List<DocumentSnapshot<Object?>>> fetchPendingVegetables() async {
  // Fetch pending vegetables from Firestore and return as a list of DocumentSnapshots
  QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance
      .collection('pending_approval')
      .where('status', isEqualTo: 'pending')
      .get();

  return querySnapshot.docs.cast<DocumentSnapshot<Object?>>().toList();
}
