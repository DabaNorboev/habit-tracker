import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF1A7A4A);
  static const Color accentGreen = Color(0xFF2ECC71);
  static const Color darkBackground = Color(0xFF1C1C1C);
  static const Color darkCardBackground = Color(0xFF2C2C2C);
  static const Color lightText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFF888888);
  static const Color successGreen = Color(0xFF1A7A4A);
  static const Color disabledGray = Color(0xFF555555);

  // Карточки по категориям
  static const Color cardProductivityBlue = Color(0xFFE8EEF5);
  static const Color cardHealthGreen = Color(0xFFE8F5EE);
  static const Color cardWellnessYellow = Color(0xFFFFF9E6);
  static const Color cardMindfulnessPurple = Color(0xFFF3E8FF);
  static const Color cardSocialPink = Color(0xFFFFE8F5);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: lightText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryGreen,
      foregroundColor: lightText,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: disabledGray, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
      hintStyle: const TextStyle(color: secondaryText),
      labelStyle: const TextStyle(color: lightText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: lightText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: lightText,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: lightText,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: lightText,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: lightText,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: secondaryText,
        fontSize: 14,
      ),
    ),
  );

  // Функция для получения цвета карточки по индексу
  static Color getCardColor(int index) {
    final colors = [
      cardProductivityBlue,
      cardHealthGreen,
      cardWellnessYellow,
      cardMindfulnessPurple,
      cardSocialPink,
    ];
    return colors[index % colors.length];
  }
}
