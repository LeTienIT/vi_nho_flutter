import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: const ColorScheme(
    brightness: Brightness.dark,

    primary: Color(0xFF2DD4BF),
    onPrimary: Color(0xFF042F2E),

    secondary: Color(0xFF34D399),
    onSecondary: Color(0xFF052E2B),

    error: Color(0xFFF87171),
    onError: Colors.black,

    surface: Color(0xFF111827),
    onSurface: Color(0xFFE2E8F0),

    primaryContainer: Color(0xFF134E4A),
    onPrimaryContainer: Color(0xFFCCFBF1),

    secondaryContainer: Color(0xFF14532D),
    onSecondaryContainer: Color(0xFFDCFCE7),
  ),

  scaffoldBackgroundColor: const Color(0xFF0B1220),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0B1220),
    foregroundColor: Color(0xFFF8FAFC),
    elevation: 0,
    centerTitle: true,
    surfaceTintColor: Colors.transparent,
  ),

  cardTheme: CardThemeData(
    color: const Color(0xFF111827),
    elevation: 0,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(
        color: Color(0xFF1F2937),
      ),
    ),

    margin: const EdgeInsets.all(6),
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF8FAFC),
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      color: Color(0xFFE2E8F0),
      height: 1.4,
    ),

    bodyMedium: TextStyle(
      fontSize: 14,
      color: Color(0xFFCBD5E1),
      height: 1.4,
    ),

    bodySmall: TextStyle(
      fontSize: 12,
      color: Color(0xFF94A3B8),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF111827),

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFF1F2937),
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFF2DD4BF),
        width: 1.8,
      ),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,

      backgroundColor: const Color(0xFF14B8A6),
      foregroundColor: const Color(0xFF042F2E),

      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),

  iconTheme: const IconThemeData(
    color: Color(0xFFCBD5E1),
    size: 22,
  ),

  dividerColor: const Color(0xFF1F2937),
);