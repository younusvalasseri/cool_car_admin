//lib\Widgets\page_color.dart
import 'package:flutter/material.dart';

enum GradientDirection { topToBottom, bottomToTop }

class PageColor {
  static LinearGradient gradient(
      {GradientDirection direction = GradientDirection.topToBottom}) {
    return LinearGradient(
      begin: direction == GradientDirection.topToBottom
          ? Alignment.topCenter
          : Alignment.bottomCenter,
      end: direction == GradientDirection.topToBottom
          ? Alignment.bottomCenter
          : Alignment.topCenter,
      colors: const [
        Color.fromARGB(50, 251, 251, 251),
        Color.fromARGB(255, 116, 190, 237),
      ],
    );
  }
}
