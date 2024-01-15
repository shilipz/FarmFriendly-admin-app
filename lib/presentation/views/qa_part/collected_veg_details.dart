import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucumber_admin/main.dart';
import 'package:cucumber_admin/presentation/presentation_logic/bloc/quantity_button/quantity_button_bloc.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cucumber_admin/presentation/widgets/contact_form_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cucumber_admin/presentation/views/qa_part/widgets/qa_widgets.dart';

//----------In this page qa team can update vegetables collected/provide details on collected veggs----------

class ProductDetails extends StatefulWidget {
  final String vegetableName;
  final String docId;
  final String vegId;
  final int vegPrice;
  final String vegQuantity;
  // final DateTime collectionDate;
  const ProductDetails({
    super.key,
    required this.vegetableName,
    required this.docId,
    required this.vegId,
    required this.vegPrice,
    required this.vegQuantity,
    // required this.collectionDate
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _razorpay = Razorpay();
  var amountController = TextEditingController();
  @override
  void initState() {
    _detailsSubmitted = false;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment successful');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  String selectedChoice = 'Choice 1';
  bool _detailsSubmitted = false;

  final QuantityButtonBloc quantityButtonBloc = QuantityButtonBloc();

  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = today;
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
      child: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding:
                EdgeInsets.only(top: screenHeight * 0.01, left: 26, right: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Arrowback(backcolor: darkgreen),
                    Text(widget.vegetableName,
                        style: const TextStyle(
                            color: darkgreen,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Price of ${widget.vegetableName} :',
                          style: commonText,
                        ),
                        const Text(' (at the time of collection)')
                      ],
                    ),
                    kwidth,
                    SalesContainer(saleText: '${widget.vegPrice}')
                  ],
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  sheight,
                  Text(
                    'Collected quantity: ${widget.vegQuantity} Kg',
                    style: commonText,
                  ),
                  sheight,
                  Row(
                    children: [
                      const Text(' Approved Quantity', style: commonText),
                      kwidth,
                      QuantityButton(
                          onpressed: () {
                            BlocProvider.of<QuantityButtonBloc>(context)
                                .add(DecreaseQuantity());
                          },
                          quantityIcon: Icons.remove),
                      kwidth,
                      BlocBuilder<QuantityButtonBloc, QuantityButtonState>(
                        builder: (context, state) {
                          return SalesContainer(
                              saleText: "${state.quantity.toString()} Kg");
                        },
                      ),
                      kwidth,
                      QuantityButton(
                          onpressed: () {
                            BlocProvider.of<QuantityButtonBloc>(context)
                                .add(IncreaseQuantity());
                          },
                          quantityIcon: Icons.add),
                    ],
                  ),
                  sheight,
                  BlocBuilder<QuantityButtonBloc, QuantityButtonState>(
                    builder: (context, state) {
                      var totalAmount = state.quantity * widget.vegPrice;
                      return Row(
                        children: [
                          const Text(
                            'Amount :',
                            style: commonText,
                          ),
                          kwidth,
                          Container(
                              decoration: const BoxDecoration(
                                  color: kwhite,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              width: screenWidth * 0.4,
                              height: screenHeight * 0.06,
                              child: Center(
                                  child: Text(
                                      '₹ $totalAmount for ${state.quantity} Kg',
                                      style: commonText))),
                        ],
                      );
                    },
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
                            return isSameDay(today, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
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
                  lheight,
                  const Text("Feedback", style: commonText),
                  sheight,
                  Wrap(
                    spacing: 8.0,
                    children: [
                      ChoiceChip(
                        selectedColor: kwhite,
                        label:
                            const Text('Complete quantity approved for sales'),
                        selected: selectedChoice == 'Choice 1',
                        onSelected: (selected) {
                          setState(() {
                            selectedChoice = selected ? 'Choice 1' : '';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: BlocBuilder<QuantityButtonBloc,
                            QuantityButtonState>(
                          builder: (context, state) {
                            return Text('Only ${state.quantity} Kg approved');
                          },
                        ),
                        selected: selectedChoice == 'Choice 2',
                        onSelected: (selected) {
                          setState(() {
                            selectedChoice = selected ? 'Choice 1' : '';
                          });
                        },
                      ),
                    ],
                  ),
                  sheight,
                  // Center(
                  //   child: SizedBox(
                  //     width: 160,
                  //     height: 50,
                  //     child: ElevatedButton(
                  //       onPressed: _detailsSubmitted
                  //           ? null
                  //           : () {
                  //               _addVegetableToFirestore(
                  //                   context,
                  //                   widget.vegetableName,
                  //                   selectedDay,
                  //                   widget.docId,
                  //                   widget.vegId,
                  //                   int.parse(widget.vegQuantity),
                  //                   widget.vegPrice);

                  //               setState(() {
                  //                 _detailsSubmitted = true;
                  //               });
                  //             },
                  //       style: ButtonStyle(
                  //         backgroundColor:
                  //             MaterialStateProperty.resolveWith<Color>(
                  //           (Set<MaterialState> states) {
                  //             if (states.contains(MaterialState.disabled)) {
                  //               return darkgreen;
                  //             }
                  //             return Colors.grey;
                  //           },
                  //         ),
                  //         shape:
                  //             MaterialStateProperty.all<RoundedRectangleBorder>(
                  //           RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(25),
                  //           ),
                  //         ),
                  //       ),
                  //       child: const Text(
                  //         'Collected',
                  //         style: TextStyle(fontSize: 18, color: kwhite),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  sheight,
                  Center(
                    child: BlocBuilder<QuantityButtonBloc, QuantityButtonState>(
                      builder: (context, state) {
                        return Next(
                            onPressed: () {
                              _detailsSubmitted
                                  ? null
                                  : () {
                                      _addVegetableToFirestore(
                                          context,
                                          widget.vegetableName,
                                          selectedDay,
                                          widget.docId,
                                          widget.vegId,
                                          int.parse(widget.vegQuantity),
                                          widget.vegPrice);

                                      setState(() {
                                        _detailsSubmitted = true;
                                      });
                                    };
                              var options = {
                                'key': 'rzp_test_ESaJeRtOUFPAcN',
                                'amount':
                                    ((state.quantity * widget.vegPrice) * 100)
                                        .toString(),
                                'name': 'Cucumber',
                                'description': 'Demo',
                                'prefill': {
                                  'contact': '8888888888',
                                  'email': 'admin@gmail.com'
                                }
                              };
                              _razorpay.open(options);
                            },
                            buttonText: 'Proceed to payment',
                            buttonColor: darkgreen);
                      },
                    ),
                  ),
                ])
              ],
            ),
          ),
        ]),
      ),
    )));
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }
}

void _addVegetableToFirestore(
  BuildContext context,
  String vegetableName,
  DateTime selectedDay,
  String docId,
  String vegId,
  num quantity,
  int vegPrice,
) async {
  log('collection created');
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final totalAmount = quantity * vegPrice;

    String formattedDate = selectedDay.toLocal().toString();

    DocumentReference userDocument = users.doc(docId);
    await userDocument
        .collection('collected_vegetables')
        .doc(formattedDate)
        .set({
      'vegetable_name': vegetableName,
      'veg_total_price': totalAmount,
      'quantity': quantity,
      'docId': docId,
      'price_per_unit': vegPrice,
      'vegId': vegId,
      'collection_date': selectedDay,
    });

    userDocument.collection('selling_vegetables').doc(vegId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Collection details added'),
    ));
  } else {
    // Handle the case where the user is not logged in
  }
}

DateTime today = DateTime.now();
