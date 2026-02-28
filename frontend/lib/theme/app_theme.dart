import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF000000); // True Black
  static const Color surface = Color(0xFF15141A);   // Deep Violet-Black
  static const Color cyanAccent = Color(0xFF00E5FF);
  static const Color magentaAccent = Color(0xFFFF007F);
  static const Color textLight = Color(0xFFE0E0E0);
  static const Color textMuted = Color(0xFF8A8A93);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: cyanAccent,
      colorScheme: const ColorScheme.dark(
        primary: cyanAccent,
        secondary: magentaAccent,
        surface: surface,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: const TextStyle(color: textLight, fontWeight: FontWeight.w800),
        titleLarge: const TextStyle(color: textLight, fontWeight: FontWeight.bold, fontSize: 24),
        bodyLarge: const TextStyle(color: textLight, fontSize: 16),
        bodyMedium: const TextStyle(color: textMuted, fontSize: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
