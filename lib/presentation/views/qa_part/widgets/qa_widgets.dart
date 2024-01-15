import 'package:cucumber_admin/main.dart';
import 'package:cucumber_admin/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final IconData? quantityIcon;
  final String? buttonText;
  final Function()? onpressed;

  const QuantityButton({
    this.buttonText,
    this.quantityIcon,
    Key? key,
    this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: 40,
            height: 40,
            color: kwhite,
            child: IconButton(
              onPressed: onpressed,
              icon: Icon(
                quantityIcon, // Default icon is Icons.add
                color: homeorange,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SalesContainer extends StatelessWidget {
  final String saleText;
  const SalesContainer({required this.saleText, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: kwhite, borderRadius: BorderRadius.all(Radius.circular(20))),
        width: screenWidth * 0.15,
        height: screenHeight * 0.04,
        child: Center(child: Text(saleText, style: commonText)));
  }
}
