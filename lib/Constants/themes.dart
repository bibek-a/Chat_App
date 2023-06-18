import "package:flutter/material.dart";

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
    ));

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color.fromARGB(255, 16, 16, 16),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Color.fromARGB(255, 16, 16, 16),
    ));
