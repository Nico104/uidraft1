import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get brandColor => brightness == Brightness.light
      ? const Color(0xFFF9005D)
      : const Color(0xFFF9005D);

  Color get searchBarColor => brightness == Brightness.light
      ? const Color(0xFF181818)
      : const Color(0xFF181818);

  Color get searchBarTextColor => brightness == Brightness.light
      ? const Color(0xFF808080)
      : const Color(0xFF808080);

  Color get navBarIconColor => brightness == Brightness.light
      ? const Color(0xFFD3D3D3)
      : const Color(0xFFD3D3D3);
}
