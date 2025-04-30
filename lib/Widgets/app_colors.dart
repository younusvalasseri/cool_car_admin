import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Colors.blue;
  static const Color primaryBlueLight = Color.fromARGB(191, 116, 190, 237);
  static const Color black = Colors.black;
  static const Color blackText = Colors.black;
  static const Color greyBack = Colors.grey;
  static const Color whiteText = Colors.white;
  static const Color appBarText = Colors.white;
  static const Color background = Color(0xFFF5F5F5);
  static const Color textDark = Colors.black87;
  static const Color white = Colors.white70;
  static const Color greenText = Colors.greenAccent;
  static Color blueShade = Colors.blue.shade700;
  static const Color barChartColor = Colors.blue;
  static const Color blueIcon = Colors.blue;
  static const Color redIcon = Colors.red;
  static const Color redText = Colors.red;
  static const Color greenBack = Colors.green;
  static const Color redBack = Colors.red;

  static const LinearGradient loginBackgroundGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
