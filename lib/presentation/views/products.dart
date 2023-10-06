import 'package:cucumber_admin/presentation/views/products_approved_widget.dart';
import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cucumber_admin/presentation/widgets/home_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:flutter/material.dart';

import 'products_pending_widget.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: SafeArea(
        child: Scaffold(
          backgroundColor: lightgreen,
          body: Column(
            children: [
              const CustomAppbar(),
              const Captions(captionColor: kwhite, captions: 'All Products'),
              lheight,
              const TabBar(
                overlayColor: MaterialStatePropertyAll(darkgreen),
                indicatorColor: kwhite,
                tabs: [
                  Tab(
                    text: 'Approved Products',
                  ),
                  Tab(text: 'Pending Approvals'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    // Approved Products Tab
                    ApprovedProducts(),
                    // Pending Approvals Tab
                    PendingApprovalWidget()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
