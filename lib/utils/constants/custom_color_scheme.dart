import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get brandColor => brightness == Brightness.light
      ? const Color(0xFFF9005D)
      // ? const Color(0xFFBC023B)
      // ? const Color(0xFFffe135)
      // : const Color(0xFFBC023B);
      : const Color(0xFFF9005D);
  //!des do
  // : const Color(0xFFAF69EF);

  Color get searchBarColor => brightness == Brightness.light
      ? const Color(0xFFDCDCDC)
      : const Color(0xFF181818);

  Color get searchBarTextColor => brightness == Brightness.light
      ? const Color(0xFF696969)
      : const Color(0xFF808080);

  Color get navBarIconColor => brightness == Brightness.light
      ? const Color(0xFF181818)
      : const Color(0xFFD3D3D3);

  Color get videoPreviewTextColor => brightness == Brightness.light
      ? const Color(0xFFF5F5F5)
      : const Color(0xFFF5F5F5);

  Color get textInputCursorColor => brightness == Brightness.light
      ? const Color(0xFF696969)
      : const Color(0xFFF5F5F5);

  Color get userBioColor => brightness == Brightness.light
      ? const Color(0xFF707070)
      : const Color(0xFF707070);

  Color get highlightColor => brightness == Brightness.light
      ? const Color(0xFFffffff)
      : const Color(0xFFffffff);

  Color get videoPlayerIconBackgroundColor => brightness == Brightness.light
      ? const Color(0xFF262525)
      : const Color(0xFF262525);
}


// 060507