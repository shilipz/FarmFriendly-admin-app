import 'package:cucumber_admin/presentation/views/products/add_products.dart';
import 'package:cucumber_admin/presentation/widgets/contact_form_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApprovedProducts extends StatefulWidget {
  const ApprovedProducts({super.key});

  @override
  State<ApprovedProducts> createState() => _ApprovedProductsState();
}

class _ApprovedProductsState extends State<ApprovedProducts> {
  TextEditingController searchController = TextEditingController();
  late QuerySnapshot snapshot;
  List<DocumentSnapshot> filteredVegetables = [];
  bool showAllItems = false;
  void filterVegetables(String query) {
    setState(() {
      filteredVegetables.clear();
      filteredVegetables.addAll(snapshot.docs
          .where((vegetable) {
            var vegetableName = vegetable['name'].toString().toLowerCase();
            return vegetableName.contains(query.toLowerCase());
          })
          .map((queryDocumentSnapshot) => queryDocumentSnapshot)
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sheight,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: searchController,
            onChanged: (query) {
              filterVegetables(query);
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(60)),
              ),
              hintText: 'Search Vegetables...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  filterVegetables('');
                },
              ),
            ),
          ),
        ),
        sheight,
        TextButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddVegetableScreen(),
                )),
            child: const Text('Click here to add new Products',
                style: TextStyle(
                    color: darkgreen,
                    fontSize: 18,
                    decoration: TextDecoration.underline))),
        sheight,
        Flexible(
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
                this.snapshot = snapshot.data!;
                var vegetables = searchController.text.isEmpty
                    ? snapshot.data!.docs
                    : filteredVegetables;

                return ListView.builder(
                  itemCount: showAllItems
                      ? vegetables.length
                      : vegetables.length > 4
                          ? 4
                          : vegetables.length,
                  itemBuilder: (context, index) {
                    var vegetable = vegetables[index];
                    var name = vegetable['name'];
                    var price = vegetable['price'];
                    var imageUrl = vegetable['imageUrl'];
                    return Card(
                      child: ListTile(
                        leading: Container(
                          decoration: const BoxDecoration(color: kwhite),
                          width: 70,
                          height: 70,
                          child: imageUrl.isNotEmpty
                              ? Image.network(imageUrl) // Load image from URL
                              : Image.asset('assets/images.jpeg'),
                        ),
                        title: Text(name),
                        subtitle: Text('$price per Kg'),
                        trailing: GestureDetector(
                            onTap: () async {
                              await showDialog<double>(
                                context: context,
                                builder: (context) {
                                  TextEditingController priceController =
                                      TextEditingController();
                                  return AlertDialog(
                                    title: const Text('Edit Price'),
                                    content: TextField(
                                      controller: priceController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          labelText: 'New Price'),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(null);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            double price = double.tryParse(
                                                    priceController.text) ??
                                                0;

                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Save'))
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Icon(Icons.edit)),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        Next(
            onPressed: () {
              setState(() {
                showAllItems = !showAllItems;
              });
            },
            buttonText: showAllItems ? 'Show Less' : 'See More',
            buttonColor: darkgreen)
      ],
    );
  }

  Future<void> updateVegetablePrice(String vegetableId, double newPrice) async {
    try {
      await FirebaseFirestore.instance
          .collection('vegetables')
          .doc(vegetableId)
          .update({'price': newPrice});
    } catch (error) {
      print('Error updating vegetable price: $error');
    }
  }
}
