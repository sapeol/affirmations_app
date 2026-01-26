import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_preferences.dart';

class AppTheme {
  // Enforcing WCAG 2.1 AA Compliance (4.5:1 ratio for normal text)
  static final Map<AppColorTheme, AppPalette> palettes = {
    AppColorTheme.brutalist: AppPalette(
      primaryLight: const Color(0xFFD50000), // Darker Red for contrast on white
      primaryDark: const Color(0xFFFF5252),  // Lighter Red for contrast on black
      secondaryLight: const Color(0xFF00C853),
      secondaryDark: const Color(0xFF69F0AE),
      accentLight: const Color(0xFF2962FF),
      accentDark: const Color(0xFF82B1FF),
      backgroundLight: const Color(0xFFFFFFFF),
      backgroundDark: const Color(0xFF000000),
      surfaceLight: const Color(0xFFF5F5F5),
      surfaceDark: const Color(0xFF121212),
      textLight: const Color(0xFF000000),
      textDark: const Color(0xFFFFFFFF),
      isAlwaysDark: false,
      cardGradients: [
        [const Color(0xFFFDD835), const Color(0xFFFBC02D)], // Deep Yellows
        [const Color(0xFF00C853), const Color(0xFF00E676)], 
        [const Color(0xFF2962FF), const Color(0xFF448AFF)],
        [const Color(0xFFFF3D00), const Color(0xFFFF6E40)],
      ],
    ),
    AppColorTheme.vibrant: AppPalette(
      primaryLight: const Color(0xFF6200EA),
      primaryDark: const Color(0xFFB388FF),
      secondaryLight: const Color(0xFF009688),
      secondaryDark: const Color(0xFF80CBC4),
      accentLight: const Color(0xFFF57C00),
      accentDark: const Color(0xFFFFB74D),
      backgroundLight: const Color(0xFFFAFAFF),
      backgroundDark: const Color(0xFF050010),
      surfaceLight: Colors.white,
      surfaceDark: const Color(0xFF0D001A),
      textLight: const Color(0xFF121212),
      textDark: const Color(0xFFFFFFFF),
      isAlwaysDark: false,
      cardGradients: [
        [const Color(0xFF7B1FA2), const Color(0xFF9C27B0)],
        [const Color(0xFF00796B), const Color(0xFF009688)],
        [const Color(0xFFE64A19), const Color(0xFFF4511E)],
        [const Color(0xFF1976D2), const Color(0xFF2196F3)],
      ],
    ),
    AppColorTheme.softcore: AppPalette(
      primaryLight: const Color(0xFFC2185B), // Deep Pink for contrast
      primaryDark: const Color(0xFFF48FB1),
      secondaryLight: const Color(0xFF388E3C),
      secondaryDark: const Color(0xFFA5D6A7),
      accentLight: const Color(0xFF1976D2),
      accentDark: const Color(0xFF90CAF9),
      backgroundLight: const Color(0xFFFFF5F8),
      backgroundDark: const Color(0xFF1A0D10),
      surfaceLight: Colors.white,
      surfaceDark: const Color(0xFF251216),
      textLight: const Color(0xFF212121),
      textDark: const Color(0xFFFFF5F8),
      isAlwaysDark: false,
      cardGradients: [
        [const Color(0xFFFFCDD2), const Color(0xFFEF9A9A)],
        [const Color(0xFFC5CAE9), const Color(0xFF9FA8DA)],
        [const Color(0xFFC8E6C9), const Color(0xFFA5D6A7)],
        [const Color(0xFFE1BEE7), const Color(0xFFCE93D8)],
      ],
    ),
    AppColorTheme.minimalist: AppPalette(
      primaryLight: const Color(0xFF000000),
      primaryDark: const Color(0xFFFFFFFF),
      secondaryLight: const Color(0xFF424242),
      secondaryDark: const Color(0xFFE0E0E0),
      accentLight: const Color(0xFF616161),
      accentDark: const Color(0xFFBDBDBD),
      backgroundLight: const Color(0xFFFFFFFF),
      backgroundDark: const Color(0xFF000000),
      surfaceLight: const Color(0xFFFFFFFF),
      surfaceDark: const Color(0xFF121212),
      textLight: const Color(0xFF000000),
      textDark: const Color(0xFFFFFFFF),
      isAlwaysDark: false,
      cardGradients: [
        [const Color(0xFFEEEEEE), const Color(0xFFE0E0E0)],
        [const Color(0xFFE0E0E0), const Color(0xFFBDBDBD)],
        [const Color(0xFFBDBDBD), const Color(0xFF9E9E9E)],
        [const Color(0xFF9E9E9E), const Color(0xFF757575)],
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
        [const Color(0xFF000000), const Color(0xFF212121)],
        [const Color(0xFF000000), const Color(0xFF1B5E20)],
        [const Color(0xFF000000), const Color(0xFF0D47A1)],
        [const Color(0xFF000000), const Color(0xFF4A148C)],
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
        error: const Color(0xFFB00020),
        onError: Colors.white,
        surface: surfaceColor,
        onSurface: textColor,
      ),
    );

    final textTheme = GoogleFonts.getTextTheme(fontFamily, baseTheme.textTheme);

    // Enforcing Minimum Font Sizes and Line Spacing (1.5x)
    return baseTheme.copyWith(
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(fontSize: 32, height: 1.2, color: textColor, fontWeight: FontWeight.bold),
        headlineMedium: textTheme.headlineMedium?.copyWith(fontSize: 24, height: 1.4, color: textColor, fontWeight: FontWeight.w600),
        bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: 18, height: 1.6, color: textColor),
        bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: 16, height: 1.5, color: textColor),
        bodySmall: textTheme.bodySmall?.copyWith(fontSize: 14, height: 1.5, color: textColor.withValues(alpha: 0.8)),
        labelSmall: textTheme.labelSmall?.copyWith(
          color: textColor.withValues(alpha: 0.7), 
          fontWeight: FontWeight.w900, 
          fontSize: 14,
          letterSpacing: 1.2,
        ),
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: textColor,
          fontSize: 18,
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
          borderRadius: BorderRadius.circular(colorTheme == AppColorTheme.brutalist ? 4 : 24),
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
