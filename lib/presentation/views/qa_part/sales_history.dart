// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cucumber_admin/presentation/views/qa_part/invoice/single_invoice.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'package:cucumber_admin/main.dart';
// import 'package:cucumber_admin/presentation/views/qa_part/invoice/invoice.dart';
// import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';

// import '../../../utils/constants/constants.dart';

// class SalesHistory extends StatelessWidget {
//   final String docId;

//   const SalesHistory({
//     Key? key,
//     required this.docId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           height: screenHeight,
//           width: screenWidth,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 begin: AlignmentDirectional.topStart,
//                 end: Alignment.bottomCenter,
//                 colors: [kwhite, lightgreen]),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(40),
//               topRight: Radius.circular(40),
//             ),
//           ),
//           child: Column(
//             children: [
//               const Row(
//                 children: [
//                   Arrowback(backcolor: darkgreen),
//                   Captions(captionColor: darkgreen, captions: 'Sales History')
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) {
//                       return CompleteInvoice(docId: docId);
//                     }),
//                   );
//                 },
//                 child: const Text(
//                   'See complete invoice',
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: FutureBuilder<QuerySnapshot>(
//                   future: FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(docId)
//                       .collection('collected_vegetables')
//                       .orderBy('collection_date', descending: true)
//                       .get(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     } else if (snapshot.hasError || !snapshot.hasData) {
//                       return const Center(
//                         child: Text('Something went wrong'),
//                       );
//                     } else if (snapshot.data!.docs.isEmpty) {
//                       return const Center(
//                         child: Text('No sales so far'),
//                       );
//                     } else {
//                       var vegetablesList = snapshot.data!.docs;
//                       vegetablesList.sort((a, b) {
//                         var dateA = (a['collection_date']).toDate();
//                         var dateB = (b['collection_date']).toDate();
//                         return dateB.compareTo(dateA);
//                       });

//                       Set<String> processedDates = {};
//                       List<String> uniqueDates = [];

//                       for (var vegetable in vegetablesList) {
//                         var timestamp =
//                             vegetable['collection_date'] as Timestamp;
//                         var vegCollectedDate = timestamp.toDate();
//                         var formattedDateDDMonth =
//                             DateFormat('dd MMMM yyyy').format(vegCollectedDate);

//                         if (!processedDates.contains(formattedDateDDMonth)) {
//                           processedDates.add(formattedDateDDMonth);
//                           uniqueDates.add(formattedDateDDMonth);
//                         }
//                       }

//                       return ListView.builder(
//                         itemCount: uniqueDates.length,
//                         itemBuilder: (context, index) {
//                           var formattedDateDDMonth = uniqueDates[index];

//                           return Padding(
//                             padding: const EdgeInsets.all(24),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Collection of $formattedDateDDMonth',
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w300,
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () async {
//                                     print(formattedDateDDMonth);
//                                     Navigator.of(context).push(
//                                       MaterialPageRoute(builder: (context) {
//                                         return Invoice(
//                                             docId: docId,
//                                             selectedDate: formattedDateDDMonth);
//                                       }),
//                                     );
//                                   },
//                                   child: const Text(
//                                     'See invoice',
//                                     style: TextStyle(
//                                       decoration: TextDecoration.underline,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     }
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
