import 'dart:ui';
// import 'dart:ui/painting.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class MeroStyle {
  static getStyle(double fontSize) {
    return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          // color: Color.fromARGB(255, 95, 67, 56),
          color: Colors.black,
          // fontWeight: FontWeight.w600,
          fontSize: fontSize,
          letterSpacing: 0.2),
    );
  }

  static getStyle1(double fontSize) {
    return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
          letterSpacing: 0.4),
    );
  }

  static getStyle2(double fontSize) {
    return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          // color: Color.fromARGB(255, 95, 67, 56),
          color: Colors.white,
          // fontWeight: FontWeight.bold,
          fontSize: fontSize,
          letterSpacing: 0.2),
    );
  }
}
