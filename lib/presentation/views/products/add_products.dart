import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddVegetableScreen extends StatelessWidget {
  const AddVegetableScreen({super.key});

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
  File? _image;
  UploadTask? uploadTask;
  Future _getImage(ImageSource source) async {
    final PickedFile = await ImagePicker().pickImage(source: source);

    if (PickedFile != null) {
      setState(() {
        _image = File(PickedFile.path);
      });
    }
  }

  Future uploadFile() async {
    final path = 'files/$_image';
    final file = File(_image!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');
  }

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
            Arrowback(backcolor: darkgreen),
            Captions(captionColor: darkgreen, captions: 'Add new Vegetable')
          ],
        ),
        sheight,
        GestureDetector(
          onTap: () {
            _showImageSourceDialog();
          },
          child: Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : null, // Display the selected image if available
              child: _image == null
                  ? const Icon(Icons.image, color: Colors.white)
                  : null,
            ),
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

  Future<void> _addVegetable() async {
    String name = _capitalizeFirstLetter(_nameController.text);
    double price = double.parse(_priceController.text);

    CollectionReference vegetablesRef =
        FirebaseFirestore.instance.collection('vegetables');
    final vegetables =
        FirebaseFirestore.instance.collection('vegetables').doc();
    Future uploadFile() async {
      final path = 'files/${_image!.path.split('/').last}';
      final file = File(_image!.path);
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() async {
        final urlDownload = await ref.getDownloadURL();
        print('Download Link: $urlDownload');

        // Update the Firestore document with the image URL
        await vegetables.update({'imageUrl': urlDownload});
      });
    }

    vegetablesRef
        .where('name', isEqualTo: name)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Vegetable with name $name already exists')));
      } else {
        await vegetables.set({
          'name': name,
          'price': price,
          'imageUrl': '',
        });
        // .then((value) {

        await uploadFile();
        _nameController.clear();
        _priceController.clear();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            animation: kAlwaysDismissedAnimation,
            backgroundColor: Colors.amber,
            content: Text('Vegetable added for sale')));
        // }).catchError((error) {
        //   log('Failed to add vegetable to Firestore: $error');
        // });
      }
    });
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take a photo'),
              onTap: () {
                _getImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Choose from gallery'),
              onTap: () {
                _getImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
