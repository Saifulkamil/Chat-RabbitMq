import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        surface: Color(0xFFF5F5F5),
        primary: coklatMain,
        secondary: Color(0xFF333333),
        secondaryContainer: Color(0xFFFFFFFF),
        onSecondary: coklatBlackMain));
