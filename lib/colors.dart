import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Colors.black;
  static const Color secondaryColor = Colors.black;
  static const Color backgroundColor = Colors.black;
  static const Color tileColor = Color.fromARGB(255, 175, 243, 199);
  static const Color textColor = Color.fromARGB(255, 36, 14, 126);
  static const Color progressBackgroundColor =
      Color.fromARGB(255, 255, 204, 188);
  static const Color progressValueColor = Color.fromARGB(255, 255, 64, 129);
  static const Color buttonColor = Color.fromARGB(255, 255, 204, 188);
  static const Color buttonTextColor = Colors.black;
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: Colors.pink,
      brightness: Brightness.light,
    );
  }
}
