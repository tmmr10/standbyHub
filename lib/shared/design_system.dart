import 'package:flutter/material.dart';

abstract class StandByColors {
  static const Color trueBlack = Color(0xFF000000);
  static const Color oledBackground = Color(0xFF0A0A0A);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color surfaceCard = Color(0xFF222222);
  static const Color accent = Color(0xFF00DDFF);
  static const Color accentGlow = Color(0x4000DDFF);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textMuted = Color(0xFF666666);
  static const Color proGold = Color(0xFFFFD700);
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
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w200,
            color: StandByColors.textPrimary,
            letterSpacing: -1,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w300,
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
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: StandByColors.textMuted,
            letterSpacing: 1.5,
          ),
        ),
      );
}
