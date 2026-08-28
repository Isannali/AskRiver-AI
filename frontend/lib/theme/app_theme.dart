import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AppTheme {
  static const Color backgroundColor =
      Color(0xFFF4F6FA);

  static const Color primaryColor =
      Color(0xFF4B61B5);

  static const Color primaryLight =
      Color(0xFFE9EDFA);

  static const Color textPrimary =
      Color(0xFF4B596D);

  static const Color textSecondary =
      Color(0xFF778397);

  static const Color borderColor =
      Color(0xFFD6DDEA);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor:
          backgroundColor,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        surface: backgroundColor,
      ),

      textTheme: GoogleFonts.dmSansTextTheme(),

      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.lora(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
      ),
    );
  }
}