import 'package:flutter/material.dart';

/// Wasslni Moroccan Luxury Color Constants & Radii
class WasslniColors {
  static const Color emerald900 = Color(0xFF06231A);
  static const Color emerald800 = Color(0xFF0B3D2E); // Primary Brand
  static const Color emerald700 = Color(0xFF11543F);
  static const Color emerald500 = Color(0xFF1E9E78);
  static const Color emerald400 = Color(0xFF34C79B);

  static const Color gold900 = Color(0xFF523F14);
  static const Color gold500 = Color(0xFFC9A24B); // Primary Accent
  static const Color gold400 = Color(0xFFE0BE6E);
  static const Color gold200 = Color(0xFFF5E7C2);

  static const Color darkCanvas = Color(0xFF0A0D0B);
  static const Color darkSurface = Color(0xFF121714);
  static const Color darkSurfaceRaised = Color(0xFF1A221E);
  static const Color darkBorder = Color(0xFF26322C);
  static const Color darkBorderSubtle = Color(0xFF1A241F);

  static const Color textPrimary = Color(0xFFF7F4EE);
  static const Color textSecondary = Color(0xFFA3B3AA);
  static const Color textTertiary = Color(0xFF62756A);

  static const Color error = Color(0xFFEF4444); // SOS
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
}

class WasslniThemeData {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: WasslniColors.darkCanvas,
      primaryColor: WasslniColors.emerald800,
      colorScheme: const ColorScheme.dark(
        primary: WasslniColors.emerald800,
        secondary: WasslniColors.gold500,
        surface: WasslniColors.darkSurface,
        error: WasslniColors.error,
        onPrimary: WasslniColors.textPrimary,
        onSecondary: WasslniColors.darkCanvas,
        onSurface: WasslniColors.textPrimary,
      ),
      fontFamily: 'IBMPlexSansArabic',
    );
  }
}

