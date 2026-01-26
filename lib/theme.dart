import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_preferences.dart';

class AppTheme {
  static final Map<AppColorTheme, AppPalette> palettes = {
    AppColorTheme.brutalist: AppPalette(
      primary: const Color(0xFF000000), 
      secondary: const Color(0xFFFF3D00), 
      accent: const Color(0xFF00E676), 
      background: const Color(0xFFFFFFFF),
      surface: const Color(0xFFFFFFFF),
      text: const Color(0xFF000000),
      isDark: false,
      cardGradients: [
        [const Color(0xFFFFD600), const Color(0xFFFFD600)], // Solid Yellow
        [const Color(0xFF00E676), const Color(0xFF00E676)], // Solid Green
        [const Color(0xFF2979FF), const Color(0xFF2979FF)], // Solid Blue
        [const Color(0xFFFF3D00), const Color(0xFFFF3D00)], // Solid Orange
      ],
    ),
    AppColorTheme.vibrant: AppPalette(
      primary: const Color(0xFF6200EA), 
      secondary: const Color(0xFF00BFA5), 
      accent: const Color(0xFFFFD600), 
      background: const Color(0xFFF5F5F5),
      surface: Colors.white,
      text: const Color(0xFF121212),
      isDark: false,
      cardGradients: [
        [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)], // Purple Bliss
        [const Color(0xFF00B4DB), const Color(0xFF0083B0)], // Blue Lagoon
        [const Color(0xFFF2994A), const Color(0xFFF2C94C)], // Mango
        [const Color(0xFFEE0979), const Color(0xFFFF6A00)], // Roseanna
      ],
    ),
    AppColorTheme.softcore: AppPalette(
      primary: const Color(0xFFFF80AB), 
      secondary: const Color(0xFFB2FF59), 
      accent: const Color(0xFF80D8FF), 
      background: const Color(0xFFFDF6F9),
      surface: Colors.white,
      text: const Color(0xFF3D3D3D),
      isDark: false,
      cardGradients: [
        [const Color(0xFFFFE0E0), const Color(0xFFFFF5F5)],
        [const Color(0xFFE0F0FF), const Color(0xFFF5FAFF)],
        [const Color(0xFFE0FFE0), const Color(0xFFF5FFF5)],
        [const Color(0xFFF0E0FF), const Color(0xFFF9F5FF)],
      ],
    ),
    AppColorTheme.minimalist: AppPalette(
      primary: const Color(0xFF212121), 
      secondary: const Color(0xFF757575), 
      accent: const Color(0xFFBDBDBD), 
      background: const Color(0xFFFAFAFA),
      surface: Colors.white,
      text: const Color(0xFF000000),
      isDark: false,
      cardGradients: [
        [const Color(0xFFE0E0E0), const Color(0xFFF5F5F5)],
        [const Color(0xFFECE9E6), const Color(0xFFFFFFFF)],
        [const Color(0xFFCFD9DF), const Color(0xFFE2EBF0)],
        [const Color(0xFFBDC3C7), const Color(0xFF2C3E50)],
      ],
    ),
    AppColorTheme.cyber: AppPalette(
      primary: const Color(0xFF00FF41), 
      secondary: const Color(0xFFFF00FF), 
      accent: const Color(0xFF00FFFF), 
      background: const Color(0xFF050505),
      surface: const Color(0xFF121212),
      text: const Color(0xFF00FF41),
      isDark: true,
      cardGradients: [
        [const Color(0xFF000000), const Color(0xFF434343)], // Carbon
        [const Color(0xFF0F2027), const Color(0xFF2C5364)], // Deep Ocean
        [const Color(0xFF141E30), const Color(0xFF243B55)], // Royal Blue
        [const Color(0xFF000000), const Color(0xFF0F9B0F)], // Matrix
      ],
    ),
  };

  static ThemeData createTheme(Brightness brightness, String fontFamily, AppColorTheme colorTheme) {
    final palette = palettes[colorTheme] ?? palettes[AppColorTheme.brutalist]!;
    final bool effectiveIsDark = palette.isDark || brightness == Brightness.dark;
    
    Color backgroundColor = effectiveIsDark ? (palette.isDark ? palette.background : const Color(0xFF0F0F12)) : palette.background;
    Color surfaceColor = effectiveIsDark ? (palette.isDark ? palette.surface : const Color(0xFF1A1A1E)) : palette.surface;
    Color textColor = effectiveIsDark ? (palette.isDark ? palette.text : const Color(0xFFE1E1E6)) : palette.text;
    
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
  final List<List<Color>> cardGradients;

  AppPalette({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.text,
    required this.isDark,
    required this.cardGradients,
  });
}
