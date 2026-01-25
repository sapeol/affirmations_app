import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF98A68B); // Sage Green

  static ThemeData createTheme(Brightness brightness, String fontFamily) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: brightness,
        surfaceContainerLowest: brightness == Brightness.light ? Colors.white : null,
      ),
    );

    // Dynamic Google Font selection
    final textTheme = GoogleFonts.getTextTheme(fontFamily, baseTheme.textTheme);

    return baseTheme.copyWith(
      textTheme: textTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: brightness == Brightness.light ? const Color(0xFFF1F4EE) : null,
      ),
    );
  }

  static ThemeData get lightTheme => createTheme(Brightness.light, 'Lexend');
  static ThemeData get darkTheme => createTheme(Brightness.dark, 'Lexend');
}