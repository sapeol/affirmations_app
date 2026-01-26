import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_preferences.dart';

class AppTheme {
  static final Map<AppColorTheme, AppPalette> palettes = {
    AppColorTheme.brutalist: AppPalette(
      primaryLight: const Color(0xFFFF3D00),
      primaryDark: const Color(0xFFFF3D00),
      secondaryLight: const Color(0xFF00E676),
      secondaryDark: const Color(0xFF00E676),
      accentLight: const Color(0xFF2979FF),
      accentDark: const Color(0xFF2979FF),
      backgroundLight: const Color(0xFFFFFFFF),
      backgroundDark: const Color(0xFF000000),
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
      primaryLight: const Color(0xFF6200EA),
      primaryDark: const Color(0xFFB388FF),
      secondaryLight: const Color(0xFF00BFA5),
      secondaryDark: const Color(0xFF64FFDA),
      accentLight: const Color(0xFFFFD600),
      accentDark: const Color(0xFFFFE57F),
      backgroundLight: const Color(0xFFFDFDFF),
      backgroundDark: const Color(0xFF080015),
      surfaceLight: Colors.white,
      surfaceDark: const Color(0xFF120025),
      textLight: const Color(0xFF1A1A1A),
      textDark: const Color(0xFFFFFFFF),
      isAlwaysDark: false,
      cardGradients: [
        [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)],
        [const Color(0xFF00B4DB), const Color(0xFF0083B0)],
        [const Color(0xFFF2994A), const Color(0xFFF2C94C)],
        [const Color(0xFFEE0979), const Color(0xFFFF6A00)],
      ],
    ),
    AppColorTheme.softcore: AppPalette(
      primaryLight: const Color(0xFFFF4081),
      primaryDark: const Color(0xFFFF80AB),
      secondaryLight: const Color(0xFF7CB342),
      secondaryDark: const Color(0xFFB2FF59),
      accentLight: const Color(0xFF039BE5),
      accentDark: const Color(0xFF81D4FA),
      backgroundLight: const Color(0xFFFFF0F5),
      backgroundDark: const Color(0xFF1A0F12),
      surfaceLight: Colors.white,
      surfaceDark: const Color(0xFF25161A),
      textLight: const Color(0xFF2D2D2D),
      textDark: const Color(0xFFFFF0F5),
      isAlwaysDark: false,
      cardGradients: [
        [const Color(0xFFFFE0E0), const Color(0xFFFFF5F5)],
        [const Color(0xFFE0F0FF), const Color(0xFFF5FAFF)],
        [const Color(0xFFE0FFE0), const Color(0xFFF5FFF5)],
        [const Color(0xFFF0E0FF), const Color(0xFFF9F5FF)],
      ],
    ),
    AppColorTheme.minimalist: AppPalette(
      primaryLight: const Color(0xFF000000),
      primaryDark: const Color(0xFFFFFFFF),
      secondaryLight: const Color(0xFF616161),
      secondaryDark: const Color(0xFFBDBDBD),
      accentLight: const Color(0xFF9E9E9E),
      accentDark: const Color(0xFF757575),
      backgroundLight: const Color(0xFFFFFFFF),
      backgroundDark: const Color(0xFF000000),
      surfaceLight: const Color(0xFFFFFFFF),
      surfaceDark: const Color(0xFF121212),
      textLight: const Color(0xFF000000),
      textDark: const Color(0xFFFFFFFF),
      isAlwaysDark: false,
      cardGradients: [
        [const Color(0xFFF5F5F5), const Color(0xFFEEEEEE)],
        [const Color(0xFFEEEEEE), const Color(0xFFE0E0E0)],
        [const Color(0xFFE0E0E0), const Color(0xFFBDBDBD)],
        [const Color(0xFFBDBDBD), const Color(0xFF9E9E9E)],
      ],
    ),
    AppColorTheme.cyber: AppPalette(
      primaryLight: const Color(0xFF00FF41),
      primaryDark: const Color(0xFF00FF41),
      secondaryLight: const Color(0xFFFF00FF),
      secondaryDark: const Color(0xFFFF00FF),
      accentLight: const Color(0xFF00FFFF),
      accentDark: const Color(0xFF00FFFF),
      backgroundLight: const Color(0xFF050505),
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
    Color primaryColor = effectiveIsDark ? palette.primaryDark : palette.primaryLight;
    Color secondaryColor = effectiveIsDark ? palette.secondaryDark : palette.secondaryLight;
    
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: effectiveIsDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme(
        brightness: effectiveIsDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        onPrimary: effectiveIsDark ? Colors.black : Colors.white,
        secondary: secondaryColor,
        onSecondary: effectiveIsDark ? Colors.black : Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: surfaceColor,
        onSurface: textColor,
      ),
    );

    final textTheme = GoogleFonts.getTextTheme(fontFamily, baseTheme.textTheme);

    return baseTheme.copyWith(
      textTheme: textTheme.apply(
        bodyColor: textColor,
        displayColor: textColor,
      ).copyWith(
        labelSmall: textTheme.labelSmall?.copyWith(
          color: textColor.withValues(alpha: 0.7), 
          fontWeight: FontWeight.w900, 
          fontSize: 12
        ),
        bodySmall: textTheme.bodySmall?.copyWith(color: textColor.withValues(alpha: 0.7)),
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
        color: textColor.withValues(alpha: 0.2),
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
  final Color primaryLight;
  final Color primaryDark;
  final Color secondaryLight;
  final Color secondaryDark;
  final Color accentLight;
  final Color accentDark;
  final Color backgroundLight;
  final Color backgroundDark;
  final Color surfaceLight;
  final Color surfaceDark;
  final Color textLight;
  final Color textDark;
  final bool isAlwaysDark;
  final List<List<Color>> cardGradients;

  AppPalette({
    required this.primaryLight,
    required this.primaryDark,
    required this.secondaryLight,
    required this.secondaryDark,
    required this.accentLight,
    required this.accentDark,
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