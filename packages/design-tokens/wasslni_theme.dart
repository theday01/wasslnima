import 'package:flutter/material.dart';

/// Wasslni Ultra-Luxury Moroccan Design System Palette
/// Royal Emerald (#0D3E30), Imperial Gold (#D4AF37), Titanium Charcoal (#070908)
class WasslniTheme {
  // Brand Emerald
  static const Color emeraldDark = Color(0xFF061D15);
  static const Color emeraldPrimary = Color(0xFF0D3E30);
  static const Color emeraldLight = Color(0xFF185E49);
  static const Color emeraldGlow = Color(0x730D3E30);

  // Imperial Moroccan Gold
  static const Color goldDark = Color(0xFF523F14);
  static const Color goldPrimary = Color(0xFFD4AF37); // Royal Gold
  static const Color goldLight = Color(0xFFF3E5AB);
  static const Color goldGlow = Color(0x59D4AF37);

  // Surfaces & Canvas (Ultra Dark Luxury)
  static const Color canvas = Color(0xFF070908);
  static const Color surface = Color(0xFF0E1311);
  static const Color surfaceElevated = Color(0xFF161E1A);
  static const Color borderSubtle = Color(0x14FFFFFF);
  static const Color borderGold = Color(0x47D4AF37);

  // Typography
  static const Color textPrimary = Color(0xFFFBF9F5);
  static const Color textSecondary = Color(0xFF9FAEA6);
  static const Color textTertiary = Color(0xFF586B62);

  // Feedback Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFF43F5E); // SOS

  // Radii
  static const double radiusSm = 10.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 32.0;

  // Master Dark Theme
  static ThemeData get luxuryDarkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: canvas,
      primaryColor: emeraldPrimary,
      colorScheme: const ColorScheme.dark(
        primary: emeraldPrimary,
        secondary: goldPrimary,
        surface: surface,
        error: error,
        onPrimary: textPrimary,
        onSecondary: canvas,
        onSurface: textPrimary,
      ),
      fontFamily: 'IBMPlexSansArabic',
      cardTheme: CardTheme(
        color: surfaceElevated,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        modalBackgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
        ),
      ),
    );
  }
}
