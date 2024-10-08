import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color backgroundColor = Color(0xFF8E8E8E);
  static const Color primaryTextColor = Color(0xFF1C344A);
  static const Color highlightColor =
      Color(0xFFC0F000); // Using the green from your image
  static const Color whiteBackgroundColor = Color(0xFFEFEFE7);
  static const Color secondaryWhiteBackgroundColor = Color(0xFFFFFFF4);
  static const Color greenSecondaryColor = Color(0xFF08AE02);
  static ThemeData get theme => ThemeData(
        primaryColor: primaryTextColor,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryTextColor,
          background: backgroundColor,
          surface: whiteBackgroundColor,
        ),
        textTheme: GoogleFonts.newsCycleTextTheme(
          ThemeData.light().textTheme.copyWith(
                bodyLarge: const TextStyle(color: primaryTextColor),
                bodyMedium: const TextStyle(color: primaryTextColor),
                titleLarge: const TextStyle(color: primaryTextColor),
              ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryTextColor,
            foregroundColor: whiteBackgroundColor,
          ),
        ),
        cardTheme: CardTheme(
          color: whiteBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          foregroundColor: primaryTextColor,
        ),
      );
}
