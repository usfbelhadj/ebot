import 'package:flutter/material.dart';

ThemeData buildThemeData() {
  return ThemeData(
    primaryColor: const Color(0xFF008080), // Teal for health & vitality
    scaffoldBackgroundColor: const Color(
      0xFFF0F0F0,
    ), // Light gray for clean look
    hintColor: const Color(0xFFFFA500), // Orange for call-to-action
    appBarTheme: const AppBarTheme(color: Color(0xFF008080), elevation: 0),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFA500)),
    ),
  );
}
