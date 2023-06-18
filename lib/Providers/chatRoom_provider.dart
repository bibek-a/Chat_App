import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ChatRoomProvider with ChangeNotifier {
  //
  bool hasInternet = false;
  bool? isLongPressed = false;
  String? recentMessageId;
  String copyText = "Copy Text";
  //
  checkInternet() async {
    hasInternet = await InternetConnectionChecker().hasConnection;
  }

  CopyText() {
    Clipboard.setData(new ClipboardData(text: copyText));
    notifyListeners();
  }

  bool isSeenerAppeared = false;

  void seenerAppearance() {
    isSeenerAppeared = isSeenerAppeared == true ? false : true;
    notifyListeners();
  }

  notifyListeners();
}
