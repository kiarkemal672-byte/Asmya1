import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const Color gold = Color(0xFFD97706);
  static const Color goldLight = Color(0xFFF59E0B);
  static const Color goldDark = Color(0xFFB45309);

  // Dark
  static const Color darkBg = Color(0xFF1A1A1A);
  static const Color darkBgGradientTop = Color(0xFF222222);
  static const Color darkCard = Color(0xFF222222);
  static const Color darkCardAlt = Color(0xFF2A2A2A);
  static const Color darkBorder = Color(0xFF333333);
  static const Color darkTextPrimary = Color(0xFFFAFAFA);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);

  // Light
  static const Color lightBg = Color(0xFFFAF7F0);
  static const Color lightBgGradientTop = Color(0xFFF5EFE0);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardAlt = Color(0xFFFFFBF2);
  static const Color lightBorder = Color(0xFFE7E2D6);
  static const Color lightTextPrimary = Color(0xFF1F1F1F);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);

  // Status
  static const Color green = Color(0xFF16A34A);
  static const Color red = Color(0xFFDC2626);
  static const Color blue = Color(0xFF2563EB);
  static const Color purple = Color(0xFF7C3AED);
  static const Color pink = Color(0xFFEC4899);
  static const Color yellow = Color(0xFFEAB308);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.gold,
      secondary: AppColors.goldLight,
      surface: AppColors.darkCard,
      error: AppColors.red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBg,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w900,
      ),
      iconTheme: IconThemeData(color: AppColors.gold),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.darkBorder, width: 1),
      ),
    ),
    inputDecorationTheme: _inputDecoration(true),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkCard,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: AppColors.darkTextSecondary,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    textTheme: _textTheme(AppColors.darkTextPrimary, AppColors.darkTextSecondary),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.darkBorder, thickness: 1),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.gold,
      secondary: AppColors.goldLight,
      surface: AppColors.lightCard,
      error: AppColors.red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBg,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w900,
      ),
      iconTheme: IconThemeData(color: AppColors.gold),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.lightBorder, width: 1),
      ),
    ),
    inputDecorationTheme: _inputDecoration(false),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightCard,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: AppColors.lightTextSecondary,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    ),
    textTheme: _textTheme(AppColors.lightTextPrimary, AppColors.lightTextSecondary),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.lightBorder, thickness: 1),
  );

  static InputDecorationTheme _inputDecoration(bool dark) => InputDecorationTheme(
    filled: true,
    fillColor: dark ? AppColors.darkCardAlt : AppColors.lightCardAlt,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: dark ? AppColors.darkBorder : AppColors.lightBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: dark ? AppColors.darkBorder : AppColors.lightBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: TextStyle(color: dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
  );

  static TextTheme _textTheme(Color primary, Color secondary) => TextTheme(
    headlineLarge: TextStyle(color: primary, fontWeight: FontWeight.w900, fontSize: 32),
    headlineMedium: TextStyle(color: primary, fontWeight: FontWeight.w800, fontSize: 24),
    titleLarge: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 18),
    titleMedium: TextStyle(color: primary, fontWeight: FontWeight.w600, fontSize: 16),
    bodyLarge: TextStyle(color: primary, fontSize: 16),
    bodyMedium: TextStyle(color: primary, fontSize: 14),
    bodySmall: TextStyle(color: secondary, fontSize: 12),
    labelLarge: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 14),
  );
}
