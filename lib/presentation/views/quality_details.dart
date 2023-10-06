import 'package:cucumber_admin/presentation/widgets/common_widgets.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class QualityAnalyst extends StatelessWidget {
  const QualityAnalyst({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Arrowback(backcolor: kblack),
          Padding(
            padding: EdgeInsets.all(22),
            child: Text(
              'Farm name',
              style: commonText,
            ),
          )
        ],
      )),
    );
  }
}
