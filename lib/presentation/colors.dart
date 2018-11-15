import 'package:flutter/material.dart';

class ThemeColors {
  static const primary = Color(0xFFffab40);
  static const primaryLight = Color(0xFFFFC86B);
  static const primaryDark = Color(0xFFFFAB40);
  static const bodyText = Color(0xFF604B41);
  static const background = Color(0xFFFFFFFF);
}

final Map<String, Color> themeColors = const {
  'primary': Colors.orange,
  'primary_light': Color(0xFFFFC86B),
  'primary_dark': Color(0xFFFFAB40),
  'body_text': Color(0xFF604B41),
  'screen_background': Color(0xFFFFFFFF),
  'white': Color(0xFFFFFFFF)
};

final Map<String, dynamic> themeText = const {
  'base': 'OpenSans',
  'fancy': 'GrandHotel',
};
