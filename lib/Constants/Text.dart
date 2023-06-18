import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Content {
  static getText(index) async {
    // int value = index + 1;
    String Response;
    Response = await rootBundle.loadString("assests.1.txt");
    String textFromFile = Response;
    return Text(textFromFile);
  }
}
