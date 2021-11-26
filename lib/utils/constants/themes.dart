import 'package:flutter/material.dart';

final ThemeData constDarkTheme = ThemeData(
  primaryColor: Colors.green,
  brightness: Brightness.dark,
  backgroundColor: Colors.yellow,
  dividerColor: Colors.black12,
  // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
  //     .copyWith(secondary: Colors.white, brightness: Brightness.dark),
  // canvasColor: const Color(0xFF020304),
  canvasColor: const Color(0xFF292D32),
  appBarTheme: const AppBarTheme(backgroundColor: Colors.yellow, elevation: 0),
  scaffoldBackgroundColor: const Color(0xFF020304),
);

final ThemeData constLightTheme = ThemeData(
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  // backgroundColor: const Color(0xFF020304),
  dividerColor: Colors.white54,
  // canvasColor: const Color(0xFF020304),
  canvasColor: const Color(0xFFf6f8fa),
  // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(
  //   secondary: Colors.black,
  //   brightness: Brightness.light,
  // ),
);
