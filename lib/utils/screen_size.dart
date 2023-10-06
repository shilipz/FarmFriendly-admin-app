import 'package:flutter/widgets.dart';

class ScreenSize {
  static late MediaQueryData _mediaQueryData;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
  }

  static double get screenWidth => _mediaQueryData.size.width;
  static double get screenHeight => _mediaQueryData.size.height;
  static double get textScaleFactor => _mediaQueryData.textScaleFactor;
}
