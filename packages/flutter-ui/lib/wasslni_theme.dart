import 'package:flutter/material.dart';

/// Wasslni Moroccan Luxury Color Constants & Radii
/// Supports both Day Mode (Default) and Dark Mode
class WasslniColors {
  // Brand Emeralds
  static const Color emerald900 = Color(0xFF06231A);
  static const Color emerald800 = Color(0xFF0B3D2E); // Primary Brand
  static const Color emerald700 = Color(0xFF11543F);
  static const Color emerald500 = Color(0xFF1E9E78);
  static const Color emerald400 = Color(0xFF34C79B);
  static const Color emerald50  = Color(0xFFE8F5F1);

  // Brand Gold Accents
  static const Color gold900 = Color(0xFF523F14);
  static const Color gold500 = Color(0xFFC9A24B); // Primary Accent
  static const Color gold400 = Color(0xFFE0BE6E);
  static const Color gold200 = Color(0xFFF5E7C2);

  // Day Light Theme Surfaces (DEFAULT)
  static const Color lightCanvas = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceRaised = Color(0xFFF1F4F2);
  static const Color lightBorder = Color(0xFFE2E8E5);
  static const Color lightBorderSubtle = Color(0xFFEDF2EF);

  // Day Light Text
  static const Color lightTextPrimary = Color(0xFF141F1A);
  static const Color lightTextSecondary = Color(0xFF4A5E54);
  static const Color lightTextTertiary = Color(0xFF7A8F85);

  // Dark Theme Surfaces
  static const Color darkCanvas = Color(0xFF0A0D0B);
  static const Color darkSurface = Color(0xFF121714);
  static const Color darkSurfaceRaised = Color(0xFF1A221E);
  static const Color darkBorder = Color(0xFF26322C);
  static const Color darkBorderSubtle = Color(0xFF1A241F);

  // Dark Text
  static const Color darkTextPrimary = Color(0xFFF7F4EE);
  static const Color darkTextSecondary = Color(0xFFA3B3AA);
  static const Color darkTextTertiary = Color(0xFF62756A);

  // Default aliases mapped to Day Mode
  static const Color textPrimary = lightTextPrimary;
  static const Color textSecondary = lightTextSecondary;
  static const Color textTertiary = lightTextTertiary;

  // Status colors
  static const Color error = Color(0xFFEF4444); // SOS
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
}

class WasslniThemeData {
  /// Default Day Mode Theme for Wasslni
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: WasslniColors.lightCanvas,
      primaryColor: WasslniColors.emerald800,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: WasslniColors.lightTextPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: WasslniColors.lightTextPrimary),
      ),
      colorScheme: const ColorScheme.light(
        primary: WasslniColors.emerald800,
        secondary: WasslniColors.gold500,
        surface: WasslniColors.lightSurface,
        error: WasslniColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: WasslniColors.lightTextPrimary,
      ),
      fontFamily: 'IBMPlexSansArabic',
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: WasslniColors.darkCanvas,
      primaryColor: WasslniColors.emerald800,
      appBarTheme: const AppBarTheme(
        backgroundColor: WasslniColors.darkSurface,
        foregroundColor: WasslniColors.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      colorScheme: const ColorScheme.dark(
        primary: WasslniColors.emerald800,
        secondary: WasslniColors.gold500,
        surface: WasslniColors.darkSurface,
        error: WasslniColors.error,
        onPrimary: WasslniColors.darkTextPrimary,
        onSecondary: WasslniColors.darkCanvas,
        onSurface: WasslniColors.darkTextPrimary,
      ),
      fontFamily: 'IBMPlexSansArabic',
    );
  }
}
