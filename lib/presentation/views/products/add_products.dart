import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddVegetableScreen extends StatelessWidget {
  const AddVegetableScreen({super.key});
  void _pickImage() {
    ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          AddVegetableForm(),
        ],
      )),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Arrowback(backcolor: kblack),
            Captions(captionColor: kdarkgreen, captions: 'Add new Vegetable')
          ],
        ),
        sheight,
        const Center(
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
          ),
        ),
        lheight,
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Vegetable Name'),
          ),
        ),
        lheight,
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Price'),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: SizedBox(
            width: 90,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                _addVegetable();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(lightgreen),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ))),
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 18, color: kwhite),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _addVegetable() {
    String name = _capitalizeFirstLetter(_nameController.text);
    double price = double.parse(_priceController.text);

    CollectionReference vegetables =
        FirebaseFirestore.instance.collection('vegetables');

    vegetables
        .where('name', isEqualTo: name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Vegetable with name $name already exists')));
      } else {
        vegetables.add({
          'name': name,
          'price': price,
        }).then((value) {
          log('Vegetable added to Firestore with ID: ${value.id}');
          Navigator.of(context).pop();

          _nameController.clear();
          _priceController.clear();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              animation: kAlwaysDismissedAnimation,
              backgroundColor: Colors.amber,
              content: Text('Vegetable added for sale')));
        }).catchError((error) {
          log('Failed to add vegetable to Firestore: $error');
        });
      }
    });
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
