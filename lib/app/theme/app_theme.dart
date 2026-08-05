import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF496BA8);
  static const Color background = Color(0xFFF7F8FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF171A21);
  static const Color textSecondary = Color(0xFF6B7280);

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFDCE7FF),
      onPrimaryContainer: Color(0xFF17345F),
      secondary: Color(0xFF65558F),
      onSecondary: Colors.white,
      surface: surface,
      onSurface: textPrimary,
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
      outline: border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,

      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: background,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
      ),

      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          height: 1.15,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          height: 1.2,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          height: 1.25,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.4,
          color: textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          height: 1.35,
          color: textSecondary,
        ),
      ),

      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          side: BorderSide(
            color: border,
          ),
        ),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          borderSide: BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 54),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      navigationBarTheme: const NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: surface,
        indicatorColor: Color(0xFFDCE7FF),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            color: textPrimary,
          ),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}