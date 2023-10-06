import 'package:cucumber_admin/presentation/views/add_products.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApprovedProducts extends StatelessWidget {
  const ApprovedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sheight,
        TextButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddVegetableScreen(),
                )),
            child: const Text('Click here to add new Products',
                style: TextStyle(color: kwhite, fontSize: 18))),
        sheight,
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('vegetables').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No vegetables available.'));
              } else {
                var vegetables = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: vegetables.length,
                  itemBuilder: (context, index) {
                    var vegetable = vegetables[index];
                    var name = vegetable['name'];
                    var price = vegetable['price'];

                    return Card(
                      child: ListTile(
                        leading: Container(
                          decoration: const BoxDecoration(color: kwhite),
                          width: 70,
                          height: 70,
                          child: Image.asset('assets/images.jpeg'),
                        ),
                        title: Text(name),
                        subtitle: Text('$price per Kg'),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
