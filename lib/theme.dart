import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_preferences.dart';

class AppTheme {
  static final Map<AppColorTheme, Color> themeSeeds = {
    AppColorTheme.terminal: const Color(0xFF00FF41), // Neon Green
    AppColorTheme.matrix: const Color(0xFF00FF00),
    AppColorTheme.cyber: const Color(0xFFF0DB4F), // JS Yellow
    AppColorTheme.monochrome: const Color(0xFFFFFFFF),
    AppColorTheme.dusk: const Color(0xFFFF7F50), // Coral
  };

  static ThemeData createTheme(Brightness brightness, String fontFamily, AppColorTheme colorTheme) {
    final seedColor = themeSeeds[colorTheme] ?? themeSeeds[AppColorTheme.terminal]!;
    
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
        surface: brightness == Brightness.dark ? const Color(0xFF0D0D0D) : const Color(0xFFF2F2F2),
      ),
    );

    final textTheme = GoogleFonts.getTextTheme(fontFamily, baseTheme.textTheme);

    return baseTheme.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: brightness == Brightness.dark ? const Color(0xFF0D0D0D) : const Color(0xFFF2F2F2),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Sharper, modern corners
          side: BorderSide(color: seedColor.withValues(alpha: 0.2), width: 1),
        ),
        color: brightness == Brightness.dark ? const Color(0xFF1A1A1A) : Colors.white,
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}