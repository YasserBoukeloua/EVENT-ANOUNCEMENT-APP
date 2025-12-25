import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryDark = Color.fromARGB(255, 35, 12, 51); // Main dark purple
  static const Color primaryMedium = Color(0xFF2d1b4e); // Medium purple
  static const Color primaryDarkest = Color(0xFF1a0d2e); // Darkest purple
  
  // Secondary/Accent colors
  static const Color accent = Color.fromRGBO(103, 101, 221, 1); // Accent purple/blue (also seen as 0xFF6765DD and 0xFF6C5CE7)
  static const Color accentAlt = Color(0xFF6C5CE7); // Alternative accent (very similar to accent)
  
  // Background colors
  static const Color backgroundLight = Color.fromARGB(255, 172, 173, 188); // Light gray background (also 0xFFACADBC)
  static const Color backgroundMedium = Color(0xFFc4b5d6); // Light purple background
  static const Color backgroundMediumDark = Color(0xFFb8a5cf); // Medium purple background
  static const Color backgroundSearch = Color.fromARGB(255, 155, 158, 206); // Search bar background
  
  // Utility colors
  static const Color success = Color(0xFF27AE60); // Green for success
  static const Color error = Color(0xFFEB5757); // Red for errors
  static const Color divider = Color(0xFFD9D9D9); // Light gray divider
  
  // Standard colors from Material
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
}
