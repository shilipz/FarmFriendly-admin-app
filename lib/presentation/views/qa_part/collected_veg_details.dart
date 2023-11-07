import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_admin/main.dart';
import 'package:cucumber_admin/presentation/views/qa_part/qa_widgets.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cucumber_admin/presentation/widgets/contact_form_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

//----------In this page qa team can update vegetables collected/provide details on collected veggs----------

class ProductDetails extends StatefulWidget {
  final String vegetableName;
  final String docId;
  final String vegId;
  // final int quantity;
  // final DateTime collectionDate;
  const ProductDetails({
    super.key,
    required this.vegetableName,
    required this.docId,
    required this.vegId,

    //  required this.quantity,
    // required this.collectionDate
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool _detailsSubmitted = false;
  @override
  void initState() {
    _detailsSubmitted = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = today;
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Stack(
        children: [
          Image.asset('assets/sale info.png', fit: BoxFit.cover),
          const Arrowback(backcolor: kwhite),
          Padding(
            padding:
                EdgeInsets.only(top: screenHeight * 0.06, left: 26, right: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              sheight,
              Text(widget.vegetableName,
                  style: const TextStyle(
                      color: kwhite,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              sheight,
              Row(
                children: [
                  const Text(' Collected Quantity', style: commonText),
                  kwidth,
                  const QuantityButton(quantityIcon: Icons.remove),
                  kwidth,
                  const SalesContainer(saleText: '3'),
                  kwidth,
                  const QuantityButton(quantityIcon: Icons.add),
                ],
              ),
              sheight,
              const Text(
                'Date of Collection :',
                style: commonText,
              ),
              sheight,
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Container(
                  decoration: const BoxDecoration(
                      color: kwhite,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TableCalendar(
                      selectedDayPredicate: (day) {
                        // Use the _selectedDay variable to highlight the selected day
                        return isSameDay(today, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        // Update the _selectedDay variable when a day is selected
                        setState(() {
                          today = selectedDay;
                        });
                      },
                      rowHeight: 35,
                      focusedDay: today,
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14)),
                ),
              ),
              // Row(

              lheight,
              Center(
                child: SizedBox(
                  width: 160,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _detailsSubmitted
                        ? null
                        : () {
                            _addVegetableToFirestore(
                                context,
                                widget.vegetableName,
                                selectedDay,
                                widget.docId,
                                widget.vegId);

                            setState(() {
                              _detailsSubmitted = true;
                            });
                          },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return lightgreen; // Grey color when disabled (details submitted)
                          }
                          return Colors
                              .grey; // Green color when enabled (details not submitted)
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Collected',
                      style: TextStyle(fontSize: 18, color: kwhite),
                    ),
                  ),
                ),
              ),
              lheight,
              const Text('Quantity Approved by QA', style: commonText),
              const TextField(keyboardType: TextInputType.number), lheight,
              const Text(
                "If any quantity/whole didn't pass the QA, please leave a message to the farmer! ",
                style: commonText,
              ),
              sheight,
              Container(
                decoration: const BoxDecoration(
                    color: kwhite,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(),
                ),
              ),
              Row(
                children: [
                  const Next(
                      buttonText: 'Send details to farmer',
                      buttonColor: homeorange),
                  Next(
                      onPressed: () {},
                      buttonText: 'Proceed to payment',
                      buttonColor: lightgreen)
                ],
              ),
            ]),
          )
        ],
      ),
    )));
  }
}

void _addVegetableToFirestore(BuildContext context, String vegetableName,
    DateTime selectedDay, String docId, String vegId) async {
  log('collection created');
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    DocumentReference userDocument = users.doc(docId);
    await userDocument.collection('collected_vegetables').add({
      'vegetable_name': vegetableName,
      'quantity': 0,
      'docId': docId,
      'vegId': vegId,
      'collection_date': selectedDay
    });
    userDocument.collection('selling_vegetables').doc(vegId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Collection details added'),
    ));
  } else {}
}

DateTime today = DateTime.now();
