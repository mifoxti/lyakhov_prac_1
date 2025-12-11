import 'package:flutter/material.dart';

class AppColors {
  // Светлая тема
  static const Color lightPrimary = Color(0xFF673AB7); // Deep Purple
  static const Color lightPrimaryDark = Color(0xFF512DA8);
  static const Color lightPrimaryLight = Color(0xFF9575CD);
  static const Color lightAccent = Color(0xFFBA68C8); // Purple Accent
  static const Color lightBackground = Color(0xFFF3E5F5); // Deep Purple 50
  static const Color lightSurface = Colors.white;
  static const Color lightOnPrimary = Colors.white;
  static const Color lightOnSurface = Color(0xFF212121);
  static const Color lightOnBackground = Color(0xFF424242);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightDivider = Color(0xFFBDBDBD);

  // Темная тема
  static const Color darkPrimary = Color(0xFF9575CD); // Lighter Purple for dark mode
  static const Color darkPrimaryDark = Color(0xFFBA68C8);
  static const Color darkPrimaryLight = Color(0xFFD1C4E9);
  static const Color darkAccent = Color(0xFFCE93D8);
  static const Color darkBackground = Color(0xFF121212); // Material Dark Background
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkOnBackground = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF424242);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightAccent,
        surface: AppColors.lightSurface,
        background: AppColors.lightBackground,
        error: Color(0xFFD32F2F),
        onPrimary: AppColors.lightOnPrimary,
        onSecondary: Colors.white,
        onSurface: AppColors.lightOnSurface,
        onBackground: AppColors.lightOnBackground,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        elevation: 2,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.lightOnPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightOnPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.lightDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnBackground,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnBackground,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.lightOnBackground,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.lightOnBackground,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.lightOnBackground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.lightOnBackground,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.lightTextSecondary,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightPrimary,
      ),
      dividerColor: AppColors.lightDivider,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkAccent,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
        error: Color(0xFFCF6679),
        onPrimary: AppColors.darkOnPrimary,
        onSecondary: Colors.black,
        onSurface: AppColors.darkOnSurface,
        onBackground: AppColors.darkOnBackground,
        onError: Colors.black,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.darkOnSurface),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.darkOnBackground,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.darkOnBackground,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.darkOnBackground,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkOnBackground,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkOnBackground,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.darkOnBackground,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.darkTextSecondary,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.darkPrimary,
      ),
      dividerColor: AppColors.darkDivider,
    );
  }

  // Helper методы для получения цветов в зависимости от темы
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onBackground;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.lightTextSecondary
        : AppColors.darkTextSecondary;
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
