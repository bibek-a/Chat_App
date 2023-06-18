// import 'dart:developer';
// import 'package:chating_app/models/UserModel.dart';
import "package:flutter/material.dart";

class GroupProvider with ChangeNotifier {
  bool isChecked = false;
  int? selectedIndex;
  addMember(val, index) {
    isChecked = val;
    selectedIndex = index;
    notifyListeners();
  }

//
//
//
  String? message = "";
  Color? messageColor;
  bool? isOkay;
  //
  showMessageForGroupName(String val) {
    //
    if (val.length > 3) {
      isOkay = true;
      message = "Change will appear soon";
      messageColor = Color.fromARGB(255, 3, 72, 6);
    } else {
      isOkay = false;
      message = "Letter must be greater than 3";
      messageColor = Color.fromARGB(255, 159, 19, 9);
    }

    notifyListeners();
  }

  showMessageForNickname(String val) {
    //
    if (val.length > 0) {
      isOkay = true;
      message = "Change will appear soon";
      messageColor = Color.fromARGB(255, 3, 72, 6);
    } else {
      isOkay = false;
      message = "It is empty";
      messageColor = Color.fromARGB(255, 159, 19, 9);
    }

    notifyListeners();
  }

  bool isSeenerAppeared = false;

  void seenerAppearance() {
    isSeenerAppeared = isSeenerAppeared == true ? false : true;
    notifyListeners();
  }

  notifyListeners();
}
