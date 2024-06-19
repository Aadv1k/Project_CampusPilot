import 'package:flutter/material.dart';

class WarmWhiteColor {
  WarmWhiteColor._(); // Private constructor to prevent instantiation

  static const Color warmWhite50 = Color(0xFFFFFBF0);
  static const Color warmWhite100 = Color(0xFFFFF7E0);
  static const Color warmWhite200 = Color(0xFFFFF3D0);
  static const Color warmWhite300 = Color(0xFFFFEFC0);
  static const Color warmWhite400 = Color(0xFFFFEBB0);
  static const Color warmWhite500 = Color(0xFFFFE7A0);
  static const Color warmWhite600 = Color(0xFFFFE390);
  static const Color warmWhite700 = Color(0xFFFFDF80);
  static const Color warmWhite800 = Color(0xFFFFDB70);
  static const Color warmWhite900 = Color(0xFFFFD760);

  static const MaterialColor warmWhite = MaterialColor(
    0xFFFFE7A0,
    <int, Color>{
      50: warmWhite50,
      100: warmWhite100,
      200: warmWhite200,
      300: warmWhite300,
      400: warmWhite400,
      500: warmWhite500,
      600: warmWhite600,
      700: warmWhite700,
      800: warmWhite800,
      900: warmWhite900,
    },
  );
}
