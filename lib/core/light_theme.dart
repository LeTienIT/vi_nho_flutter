import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  colorScheme: const ColorScheme(
    brightness: Brightness.light,

    primary: Color(0xFF0F766E),
    onPrimary: Colors.white,

    secondary: Color(0xFF14B8A6),
    onSecondary: Colors.white,

    error: Color(0xFFDC2626),
    onError: Colors.white,

    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1E293B),

    primaryContainer: Color(0xFFCCFBF1),
    onPrimaryContainer: Color(0xFF134E4A),

    secondaryContainer: Color(0xFFDCFCE7),
    onSecondaryContainer: Color(0xFF14532D),
  ),

  scaffoldBackgroundColor: const Color(0xFFF4F7F9),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF4F7F9),
    foregroundColor: Color(0xFF0F172A),
    elevation: 0,
    centerTitle: true,
    surfaceTintColor: Colors.transparent,
  ),

  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 1,
    shadowColor: Colors.black.withOpacity(0.05),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    margin: const EdgeInsets.all(6),
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Color(0xFF0F172A),
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      color: Color(0xFF1E293B),
      height: 1.4,
    ),

    bodyMedium: TextStyle(
      fontSize: 14,
      color: Color(0xFF475569),
      height: 1.4,
    ),

    bodySmall: TextStyle(
      fontSize: 12,
      color: Color(0xFF64748B),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,

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
        color: Color(0xFFE2E8F0),
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFF14B8A6),
        width: 1.8,
      ),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: const Color(0xFF0F766E),
      foregroundColor: Colors.white,

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
    color: Color(0xFF475569),
    size: 22,
  ),

  dividerColor: const Color(0xFFE2E8F0),
);