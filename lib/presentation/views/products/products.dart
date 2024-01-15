import 'package:cucumber_admin/main.dart';
import 'package:cucumber_admin/presentation/views/products/products_approved_widget.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cucumber_admin/presentation/widgets/home_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:flutter/material.dart';

import 'products_pending_widget.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: SafeArea(
        child: Scaffold(
          backgroundColor: homeorange,
          body: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromARGB(255, 206, 245, 210),
                  Color.fromARGB(255, 111, 210, 115)
                ])),
            child: Column(
              children: [
                const Row(
                  children: [
                    Arrowback(backcolor: darkgreen),
                    Captions(captionColor: darkgreen, captions: 'All Products'),
                  ],
                ),
                sheight,
                const TabBar(
                  labelColor: darkgreen,
                  overlayColor: MaterialStatePropertyAll(kwhite),
                  indicatorColor: homeorange,
                  tabs: [
                    Tab(
                      text: 'Approved Products',
                    ),
                    Tab(text: 'Pending Approvals'),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [ApprovedProducts(), PendingApprovalWidget()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
