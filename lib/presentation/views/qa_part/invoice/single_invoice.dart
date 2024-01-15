// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class Invoice extends StatelessWidget {
//   final String docId;
//   final String selectedDate;

//   const Invoice({
//     Key? key,
//     required this.docId,
//     required this.selectedDate,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     DateTime parsedDate;

//     try {
//       parsedDate = DateTime.parse(selectedDate);
//       print('Parsed Date: $parsedDate');
//     } catch (e) {
//       print('Error parsing date: $e');
//       return Scaffold(
//         body: Center(
//           child: Text('Error parsing date'),
//         ),
//       );
//     }

//     return FutureBuilder<QuerySnapshot>(
//       future: FirebaseFirestore.instance
//           .collection('users')
//           .doc(docId)
//           .collection('collected_vegetables')
//           .where('collection_date',
//               isGreaterThanOrEqualTo: Timestamp.fromDate(parsedDate))
//           .where('collection_date',
//               isLessThan: Timestamp.fromDate(parsedDate.add(Duration(days: 1))))
//           .get(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         } else if (snapshot.hasError || !snapshot.hasData) {
//           return Scaffold(
//             body: Center(
//               child: Text('Something went wrong'),
//             ),
//           );
//         } else if (snapshot.data!.docs.isEmpty) {
//           return Scaffold(
//             body: Center(
//               child: Text('No sales for the selected date'),
//             ),
//           );
//         } else {
//           var vegetablesList = snapshot.data!.docs;

//           return Scaffold(
//             body: InvoiceDetailsWidget(vegetablesList: vegetablesList),
//           );
//         }
//       },
//     );
//   }
// }

// class InvoiceDetailsWidget extends StatelessWidget {
//   final List<QueryDocumentSnapshot> vegetablesList;

//   const InvoiceDetailsWidget({Key? key, required this.vegetablesList})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var totalAmount = 0;
//     for (var vegetable in vegetablesList) {
//       totalAmount += vegetable['veg_total_price'] as int;
//     }

//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(24),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Admin,\nCucumber Wholesalers,\n Market road'),
//                       SizedBox(
//                           height: 50, width: 50, child: Icon(Icons.qr_code)),
//                     ],
//                   ),
//                   SizedBox(height: 22),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Shilpa,\nShilpas farm,\n Market road'),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             children: [
//                               Text(
//                                 'Invoice Number:',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 'Invoice Date:',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 'Payment status:',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             children: [
//                               Text('12/01/2024'),
//                               Text('12/01/2024'),
//                               Text('Paid'),
//                             ],
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 30),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'INVOICE',
//                               style: TextStyle(
//                                   fontSize: 24, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               'print pdf',
//                               style: TextStyle(
//                                   decoration: TextDecoration.underline),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             DataTable(
//               headingRowColor: MaterialStatePropertyAll(Colors.grey),
//               columnSpacing: 6,
//               columns: const [
//                 DataColumn(label: Text('Date')),
//                 DataColumn(label: Text('Vegetable')),
//                 DataColumn(label: Text('Quantity')),
//                 DataColumn(label: Text('Unit Price')),
//                 DataColumn(label: Text('Total Price')),
//               ],
//               rows: vegetablesList.map<DataRow>((vegetable) {
//                 var collectionDate =
//                     (vegetable['collection_date'] as Timestamp).toDate();
//                 var formattedDate =
//                     DateFormat('dd/MM/yy').format(collectionDate);

//                 var vegetableName = vegetable['vegetable_name'];
//                 var quantity = vegetable['quantity'];
//                 var unitPrice = vegetable['price_per_unit'];
//                 var totalPrice = vegetable['veg_total_price'];

//                 return DataRow(
//                   cells: [
//                     DataCell(Text(formattedDate)),
//                     DataCell(Text(vegetableName)),
//                     DataCell(Text(quantity.toString())),
//                     DataCell(Text('₹$unitPrice')),
//                     DataCell(Text('₹$totalPrice')),
//                   ],
//                 );
//               }).toList(),
//             ),
//             Divider(),
//             Row(
//               children: [
//                 SizedBox(width: 118),
//                 Text('Total amount paid : '),
//                 Text('₹${totalAmount.toString()}'),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Divider(),
//             const SizedBox(height: 20),
//             Center(
//               child: Text(
//                 'Thank You!',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
