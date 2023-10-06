import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddVegetableScreen extends StatelessWidget {
  const AddVegetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AddVegetableForm(),
    );
  }
}

class AddVegetableForm extends StatefulWidget {
  const AddVegetableForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddVegetableFormState createState() => _AddVegetableFormState();
}

class _AddVegetableFormState extends State<AddVegetableForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  // final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextFormField(
          controller: _priceController,
          decoration: const InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
        ),
        // TextFormField(
        //   controller: _quantityController,
        //   decoration: InputDecoration(labelText: 'Quantity'),
        //   keyboardType: TextInputType.number,
        // ),
        ElevatedButton(
          onPressed: () {
            // Call a function to add the vegetable to Firestore
            _addVegetable();
          },
          child: const Text('Add Vegetable'),
        ),
      ],
    );
  }

  void _addVegetable() {
    // Get values from controllers
    String name = _nameController.text;
    double price = double.parse(_priceController.text);
    // int quantity = int.parse(_quantityController.text);

    // Reference to the 'vegetables' collection in Firestore
    CollectionReference vegetables =
        FirebaseFirestore.instance.collection('vegetables');

    // Add vegetable to Firestore
    vegetables.add({
      'name': name,
      'price': price,
      // 'quantity': quantity,
    }).then((value) {
      // Successful addition
      log('Vegetable added to Firestore with ID: ${value.id}');

      // Clear form fields after adding vegetable
      _nameController.clear();
      _priceController.clear();
      // _quantityController.clear();
    }).catchError((error) {
      // Error handling, if the addition fails
      log('Failed to add vegetable to Firestore: $error');
    });
  }
}
