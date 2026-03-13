import 'package:flutter/material.dart';

abstract class StandByColors {
  static const Color trueBlack = Color(0xFF000000);
  static const Color oledBackground = Color(0xFF0A0A0A);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color surfaceCard = Color(0xFF222222);
  static const Color surfaceElevated = Color(0xFF2A2A2A);
  static const Color accent = Color(0xFF00DDFF);
  static const Color accentGlow = Color(0x4000DDFF);
  static const Color accentDim = Color(0xFF006B7A);
  static const Color divider = Color(0xFF1E1E1E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textMuted = Color(0xFF666666);
  static const Color proGold = Color(0xFFFFD700);
  static const Color proGoldDim = Color(0x33FFD700);
}

abstract class StandBySpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 16);
}

abstract class StandByTheme {
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: StandByColors.trueBlack,
        colorScheme: ColorScheme.dark(
          surface: StandByColors.oledBackground,
          primary: StandByColors.accent,
          secondary: StandByColors.accent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: StandByColors.trueBlack,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: StandByColors.surfaceCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
            color: StandByColors.textPrimary,
            letterSpacing: -1,
            height: 1.1,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w300,
            color: StandByColors.textPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: StandByColors.textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: StandByColors.textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: StandByColors.textSecondary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: StandByColors.textSecondary,
          ),
          labelSmall: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: StandByColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      );
}

abstract class StandByColorUtils {
  static Color parseColor(String hex) {
    final value = int.tryParse(hex, radix: 16);
    if (value != null) return Color(value);
    return StandByColors.accent;
  }

  static String colorToHex(Color color) {
    final a = (color.a * 255).round().toRadixString(16).padLeft(2, '0');
    final r = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '$a$r$g$b'.toUpperCase();
  }
}
