import 'package:flutter/material.dart';
import '../res/color_manager.dart';
import '../res/font_manager.dart';
import '../res/styles_manager.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: ColorManager.primaryGreen,
      scaffoldBackgroundColor: ColorManager.lightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorManager.primaryGreen,
        primary: ColorManager.primaryGreen,
        brightness: Brightness.light,
        surface: ColorManager.lightSurface,
      ),
      textTheme: TextTheme(
        headlineMedium: getBoldStyle(fontSize: FontManager.s24, color: ColorManager.lightTextPrimary),
        bodyLarge: getRegularStyle(fontSize: FontManager.s16, color: ColorManager.lightTextPrimary),
        bodyMedium: getRegularStyle(fontSize: FontManager.s14, color: ColorManager.lightTextSecondary),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ColorManager.primaryGreen,
        selectionColor: ColorManager.primaryGreen.withValues(alpha: 0.25),
        selectionHandleColor: ColorManager.primaryGreen,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorManager.lightCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorManager.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorManager.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorManager.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorManager.red),
        ),
        hintStyle: getRegularStyle(fontSize: FontManager.s14, color: ColorManager.lightTextSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primaryGreen,
          foregroundColor: ColorManager.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: getBoldStyle(fontSize: FontManager.s16, color: ColorManager.white),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: ColorManager.primaryGreen,
      scaffoldBackgroundColor: ColorManager.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorManager.primaryGreen,
        primary: ColorManager.primaryGreen,
        brightness: Brightness.dark,
        surface: ColorManager.darkSurface,
      ),
      textTheme: TextTheme(
        headlineMedium: getBoldStyle(fontSize: FontManager.s24, color: ColorManager.darkTextPrimary),
        bodyLarge: getRegularStyle(fontSize: FontManager.s16, color: ColorManager.darkTextPrimary),
        bodyMedium: getRegularStyle(fontSize: FontManager.s14, color: ColorManager.darkTextSecondary),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ColorManager.primaryGreen,
        selectionColor: ColorManager.primaryGreen.withValues(alpha: 0.25),
        selectionHandleColor: ColorManager.primaryGreen,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorManager.darkCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorManager.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorManager.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorManager.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorManager.red),
        ),
        hintStyle: getRegularStyle(fontSize: FontManager.s14, color: ColorManager.darkTextSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primaryGreen,
          foregroundColor: ColorManager.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: getBoldStyle(fontSize: FontManager.s16, color: ColorManager.white),
        ),
      ),
    );
  }
}
