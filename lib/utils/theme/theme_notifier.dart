import 'package:flutter/material.dart';
import 'package:uidraft1/utils/constants/themes.dart';
import 'package:uidraft1/utils/store/store_manager.dart';

///Provider to tell the App which Theme is active
class ThemeNotifier with ChangeNotifier {
  final darkTheme = constDarkTheme;

  final lightTheme = constLightTheme;

  late ThemeData _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'dark';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  ///Returns the current active Theme
  ThemeData getTheme() => _themeData;

  ///Sets the current active theme to dark mode
  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  ///Sets the current active theme to light mode
  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
