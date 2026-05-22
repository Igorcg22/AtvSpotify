import 'package:flutter/material.dart';

class SpotifyTheme {
  static const green = Color(0xFF1DB954);
  static const background = Color(0xFF121212);
  static const surface = Color(0xFF1E1E1E);
  static const cardBackground = Color(0xFF282828);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: green,
      colorScheme: const ColorScheme.dark(
        primary: green,
        background: background,
        surface: surface,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }
}