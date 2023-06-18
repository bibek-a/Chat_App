// import 'dart:developer';

import 'package:flutter/material.dart';

class themeProvider with ChangeNotifier {
  //
  ThemeMode themeMode = ThemeMode.light;

  toggleTheme() {
    //
    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  bool isSelected = false;
  //
  addMember(val) {
    //
    isSelected = val;

    notifyListeners();
  }

  bool isSeenerAppeared = false;

  void seenerAppearance() {
    isSeenerAppeared = isSeenerAppeared == true ? false : true;
    notifyListeners();
  }

  notifyListeners();
}
