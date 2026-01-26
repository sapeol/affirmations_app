import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_preferences.dart';

class AppTheme {
  static final Map<AppColorTheme, AppPalette> palettes = {
    AppColorTheme.brutalist: AppPalette(
      primary: const Color(0xFFFF3D00), // Safety Orange
      secondary: const Color(0xFF00E676), // Neon Green
      accent: const Color(0xFF2979FF), // Electric Blue
      backgroundLight: const Color(0xFFFFFFFF),
      backgroundDark: const Color(0xFF050505),
      surfaceLight: const Color(0xFFFFFFFF),
      surfaceDark: const Color(0xFF121212),
      textLight: const Color(0xFF000000),
      textDark: const Color(0xFFFFFFFF),
      isAlwaysDark: false,
      cardGradients: [
        [const Color(0xFFFFD600), const Color(0xFFFFD600)],
        [const Color(0xFF00E676), const Color(0xFF00E676)],
        [const Color(0xFF2979FF), const Color(0xFF2979FF)],
        [const Color(0xFFFF3D00), const Color(0xFFFF3D00)],
      ],
    ),
    AppColorTheme.vibrant: AppPalette(
      primary: const Color(0xFF6200EA),
      secondary: const Color(0xFF00BFA5),
      accent: const Color(0xFFFFD600),
      backgroundLight: const Color(0xFFFDFDFF),
      backgroundDark: const Color(0xFF0F0F12),
      surfaceLight: Colors.white,
      surfaceDark: const Color(0xFF1A1A1E),
      textLight: const Color(0xFF1A1A1A),
      textDark: const Color(0xFFE1E1E6),
      isAlwaysDark: false,
      cardGradients: [
        [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)],
        [const Color(0xFF00B4DB), const Color(0xFF0083B0)],
        [const Color(0xFFF2994A), const Color(0xFFF2C94C)],
        [const Color(0xFFEE0979), const Color(0xFFFF6A00)],
      ],
    ),
    AppColorTheme.softcore: AppPalette(
      primary: const Color(0xFFFF80AB),
      secondary: const Color(0xFFB2FF59),
      accent: const Color(0xFF80D8FF),
      backgroundLight: const Color(0xFFFDF6F9),
      backgroundDark: const Color(0xFF161214),
      surfaceLight: Colors.white,
      surfaceDark: const Color(0xFF251F22),
      textLight: const Color(0xFF3D3D3D),
      textDark: const Color(0xFFF5E1E6),
      isAlwaysDark: false,
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
      backgroundLight: const Color(0xFFFAFAFA),
      backgroundDark: const Color(0xFF0A0A0A),
      surfaceLight: Colors.white,
      surfaceDark: const Color(0xFF1A1A1A),
      textLight: const Color(0xFF000000),
      textDark: const Color(0xFFEEEEEE),
      isAlwaysDark: false,
      cardGradients: [
        [const Color(0xFFE0E0E0), const Color(0xFFF5F5F5)],
        [const Color(0xFFECE9E6), const Color(0xFFFFFFFF)],
        [const Color(0xFFCFD9DF), const Color(0xFFE2EBF0)],
        [const Color(0xFFBDC3C7), const Color(0xFFBDC3C7)],
      ],
    ),
    AppColorTheme.cyber: AppPalette(
      primary: const Color(0xFF00FF41),
      secondary: const Color(0xFFFF00FF),
      accent: const Color(0xFF00FFFF),
      backgroundLight: const Color(0xFF050505), // Forced dark
      backgroundDark: const Color(0xFF050505),
      surfaceLight: const Color(0xFF121212),
      surfaceDark: const Color(0xFF121212),
      textLight: const Color(0xFF00FF41),
      textDark: const Color(0xFF00FF41),
      isAlwaysDark: true,
      cardGradients: [
        [const Color(0xFF000000), const Color(0xFF434343)],
        [const Color(0xFF0F2027), const Color(0xFF2C5364)],
        [const Color(0xFF141E30), const Color(0xFF243B55)],
        [const Color(0xFF000000), const Color(0xFF0F9B0F)],
      ],
    ),
  };

  static ThemeData createTheme(Brightness brightness, String fontFamily, AppColorTheme colorTheme) {
    final palette = palettes[colorTheme] ?? palettes[AppColorTheme.brutalist]!;
    final isSystemDark = brightness == Brightness.dark;
    final bool effectiveIsDark = palette.isAlwaysDark || isSystemDark;
    
    Color backgroundColor = effectiveIsDark ? palette.backgroundDark : palette.backgroundLight;
    Color surfaceColor = effectiveIsDark ? palette.surfaceDark : palette.surfaceLight;
    Color textColor = effectiveIsDark ? palette.textDark : palette.textLight;
    
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
      ).copyWith(
        labelSmall: textTheme.labelSmall?.copyWith(
          color: textColor.withValues(alpha: 0.5), 
          fontWeight: FontWeight.w900, 
          fontSize: 12
        ),
        bodySmall: textTheme.bodySmall?.copyWith(color: textColor.withValues(alpha: 0.6)),
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: textColor,
          fontSize: 16,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: textColor.withValues(alpha: 0.1),
        thickness: 1,
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
      iconTheme: IconThemeData(color: textColor),
    );
  }
}

class AppPalette {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color backgroundLight;
  final Color backgroundDark;
  final Color surfaceLight;
  final Color surfaceDark;
  final Color textLight;
  final Color textDark;
  final bool isAlwaysDark;
  final List<List<Color>> cardGradients;

  AppPalette({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.backgroundLight,
    required this.backgroundDark,
    required this.surfaceLight,
    required this.surfaceDark,
    required this.textLight,
    required this.textDark,
    required this.isAlwaysDark,
    required this.cardGradients,
  });
}
