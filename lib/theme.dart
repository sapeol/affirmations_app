import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_preferences.dart';

class AppTheme {
  static final Map<AppColorTheme, Color> themeSeeds = {
    AppColorTheme.sage: const Color(0xFF98A68B),
    AppColorTheme.lavender: const Color(0xFFA68BA6),
    AppColorTheme.sky: const Color(0xFF8BA2A6),
    AppColorTheme.rose: const Color(0xFFA68B8B),
    AppColorTheme.peach: const Color(0xFFA6988B),
  };

  static ThemeData createTheme(Brightness brightness, String fontFamily, AppColorTheme colorTheme) {
    final seedColor = themeSeeds[colorTheme] ?? themeSeeds[AppColorTheme.sage]!;
    
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
        surfaceContainerLowest: brightness == Brightness.light ? Colors.white : null,
      ),
    );

    final textTheme = GoogleFonts.getTextTheme(fontFamily, baseTheme.textTheme);

    return baseTheme.copyWith(
      textTheme: textTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: brightness == Brightness.light 
          ? Color.alphaBlend(seedColor.withValues(alpha: 0.05), Colors.white) 
          : null,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  static ThemeData get lightTheme => createTheme(Brightness.light, 'Lexend', AppColorTheme.sage);
  static ThemeData get darkTheme => createTheme(Brightness.dark, 'Lexend', AppColorTheme.sage);
}
