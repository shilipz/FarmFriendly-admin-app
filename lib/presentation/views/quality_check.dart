import 'package:cucumber_admin/presentation/views/collection_adding.dart';
import 'package:cucumber_admin/presentation/views/quality_details.dart';
import 'package:cucumber_admin/presentation/widgets/home_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class TodaysPicks extends StatelessWidget {
  const TodaysPicks({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: lightgreen,
      body: Column(
        children: [
          const CustomAppbar(),
          const Text("Collected product details", style: commonHeading),
          lheight,
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddCollection(),
            )),
            child: const ListTile(
              leading: Text('Click to add collection details'),
            ),
          ),
          lheight,
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const QualityAnalyst(),
            )),
            child: const ListTile(
              tileColor: kwhite,
              leading: Text(
                "Dennis's Farm",
                style: commonText,
              ),
              subtitle: Text('Farm Address'),
            ),
          ),
          sheight
        ],
      ),
    ));
  }
}
