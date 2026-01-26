import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_preferences.dart';

class AppTheme {
  static final Map<AppColorTheme, Color> themeSeeds = {
    AppColorTheme.terminal: const Color(0xFFE0F2F1), // Pastel Mint
    AppColorTheme.matrix: const Color(0xFFF1F8E9),   // Pastel Green
    AppColorTheme.cyber: const Color(0xFFFFFDE7),    // Pastel Yellow
    AppColorTheme.monochrome: const Color(0xFFF5F5F5), // Soft Grey
    AppColorTheme.dusk: const Color(0xFFFBE9E7),     // Pastel Coral
  };

  static ThemeData createTheme(Brightness brightness, String fontFamily, AppColorTheme colorTheme) {
    final seedColor = themeSeeds[colorTheme] ?? themeSeeds[AppColorTheme.terminal]!;
    final isDark = brightness == Brightness.dark;
    
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
        surface: isDark ? const Color(0xFF1A1A1E) : const Color(0xFFFBFCFF),
        onSurface: isDark ? const Color(0xFFE1E1E6) : const Color(0xFF1A1A1E),
        primary: isDark ? seedColor.withValues(alpha: 0.8) : Color.lerp(seedColor, Colors.black, 0.4)!,
        onPrimary: isDark ? Colors.black : Colors.white,
        secondary: isDark ? seedColor.withValues(alpha: 0.6) : Color.lerp(seedColor, Colors.black, 0.6)!,
        outline: isDark ? Colors.white38 : Colors.black54,
        outlineVariant: isDark ? Colors.white10 : Colors.black12,
      ),
    );

    final textTheme = GoogleFonts.getTextTheme(fontFamily, baseTheme.textTheme);

    // High contrast text colors
    final mainTextColor = isDark ? const Color(0xFFE1E1E6) : const Color(0xFF1A1A1E);
    final secondaryTextColor = isDark ? const Color(0xFFA0A0A5) : const Color(0xFF4A4A4F);

    return baseTheme.copyWith(
      textTheme: textTheme.apply(
        bodyColor: mainTextColor,
        displayColor: mainTextColor,
      ).copyWith(
        labelSmall: textTheme.labelSmall?.copyWith(color: secondaryTextColor, fontSize: 11),
        bodySmall: textTheme.bodySmall?.copyWith(color: secondaryTextColor, fontSize: 12),
      ),
      scaffoldBackgroundColor: isDark ? const Color(0xFF121216) : const Color(0xFFFDFDFF),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: mainTextColor),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w300,
          letterSpacing: 4,
          color: mainTextColor,
          fontSize: 14,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white10 : Colors.black12,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        color: isDark ? const Color(0xFF25252A) : Colors.white,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: mainTextColor,
        textColor: mainTextColor,
      ),
    );
  }
}
