import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_preferences.dart';

class AppTheme {
  // Palettes designed for high contrast and punchy visuals
  static final Map<AppColorTheme, AppPalette> palettes = {
    AppColorTheme.brutalist: AppPalette(
      primary: const Color(0xFFFF3D00), // Safety Orange
      secondary: const Color(0xFF00E676), // Neon Green
      accent: const Color(0xFF2979FF), // Electric Blue
      background: const Color(0xFFFFFFFF),
      surface: const Color(0xFFEEEEEE),
      text: const Color(0xFF000000),
      isDark: false,
    ),
    AppColorTheme.vibrant: AppPalette(
      primary: const Color(0xFF6200EA), // Deep Purple
      secondary: const Color(0xFF00BFA5), // Teal
      accent: const Color(0xFFFFD600), // Vivid Yellow
      background: const Color(0xFFF5F5F5),
      surface: Colors.white,
      text: const Color(0xFF121212),
      isDark: false,
    ),
    AppColorTheme.softcore: AppPalette(
      primary: const Color(0xFFFF80AB), // Soft Pink
      secondary: const Color(0xFFB2FF59), // Light Lime
      accent: const Color(0xFF80D8FF), // Sky Blue
      background: const Color(0xFFFFF0F5),
      surface: Colors.white,
      text: const Color(0xFF2D2D2D),
      isDark: false,
    ),
    AppColorTheme.minimalist: AppPalette(
      primary: const Color(0xFF212121), // Charcoal
      secondary: const Color(0xFF757575), // Grey
      accent: const Color(0xFFBDBDBD), // Silver
      background: const Color(0xFFFAFAFA),
      surface: Colors.white,
      text: const Color(0xFF000000),
      isDark: false,
    ),
    AppColorTheme.cyber: AppPalette(
      primary: const Color(0xFF00FF41), // Matrix Green
      secondary: const Color(0xFFFF00FF), // Neon Pink
      accent: const Color(0xFF00FFFF), // Cyan
      background: const Color(0xFF0D0D0D),
      surface: const Color(0xFF1A1A1A),
      text: const Color(0xFF00FF41),
      isDark: true,
    ),
  };

  static ThemeData createTheme(Brightness brightness, String fontFamily, AppColorTheme colorTheme) {
    final palette = palettes[colorTheme] ?? palettes[AppColorTheme.brutalist]!;
    
    // Check if we should use dark mode overrides
    final bool effectiveIsDark = palette.isDark || brightness == Brightness.dark;
    
    Color backgroundColor = effectiveIsDark ? (palette.isDark ? palette.background : const Color(0xFF0F0F12)) : palette.background;
    Color surfaceColor = effectiveIsDark ? (palette.isDark ? palette.surface : const Color(0xFF1A1A1E)) : palette.surface;
    Color textColor = effectiveIsDark ? (palette.isDark ? palette.text : const Color(0xFFE1E1E6)) : palette.text;
    
    // Ensure WCAG Compliance (AA is 4.5:1, AAA is 7:1)
    // For our specific vibrant/punchy request, we favor high-contrast text on bright backgrounds.
    
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: effectiveIsDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
        primary: palette.primary,
        secondary: palette.secondary,
        tertiary: palette.accent,
        surface: surfaceColor,
        onSurface: textColor,
        brightness: effectiveIsDark ? Brightness.dark : Brightness.light,
      ),
    );

    final textTheme = GoogleFonts.getTextTheme(fontFamily, baseTheme.textTheme);

    return baseTheme.copyWith(
      textTheme: textTheme.apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor.withValues(alpha: 0.8)),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: textColor,
          fontSize: 16,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: colorTheme == AppColorTheme.brutalist ? 8 : 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(colorTheme == AppColorTheme.brutalist ? 4 : 32),
          side: colorTheme == AppColorTheme.brutalist ? BorderSide(color: textColor, width: 3) : BorderSide.none,
        ),
        color: surfaceColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.isDark ? Colors.black : Colors.white,
          elevation: colorTheme == AppColorTheme.brutalist ? 4 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(colorTheme == AppColorTheme.brutalist ? 0 : 12),
            side: colorTheme == AppColorTheme.brutalist ? BorderSide(color: textColor, width: 2) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class AppPalette {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color text;
  final bool isDark;

  AppPalette({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.text,
    required this.isDark,
  });
}