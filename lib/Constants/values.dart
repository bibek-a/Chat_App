// import 'package:flutter/material.dart';

class Values {
  static int _lastPage = 0;
  static setValue(int value) {
    _lastPage = value;
  }

  static getValue() {
    return _lastPage;
  }
}
