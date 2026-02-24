import 'package:flutter/material.dart';

/// Thème dédié aux pages Cerbère (Utilisateurs et Rôles).
/// Aligné sur le design : fond #0f0f14, carte #1e1e28, primary #5b2eff, accent #2e1a6b.
class CerbereTheme {
  CerbereTheme._();

  // Couleurs du design (variables CSS fournies)
  static const Color background = Color(0xFF0F0F14);
  static const Color foreground = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF1A1A22);
  static const Color mutedForeground = Color(0xFF8A8AA3);
  static const Color border = Color(0xFF2A2A36);
  static const Color card = Color(0xFF1E1E28);
  static const Color cardForeground = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF5B2EFF);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFF2E1A6B);
  static const Color accentForeground = Color(0xFFFFFFFF);
  static const Color input = Color(0xFF1A1A22);
  static const Color secondaryForeground = Color(0xFFA0A0B5);
  static const Color destructive = Color(0xFFFF1744);

  static const double radiusSm = 4;
  static const double radiusMd = 6;
  static const double radiusLg = 8;
  static const double radiusXl = 12;

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: primaryForeground,
        surface: background,
        onSurface: foreground,
        surfaceContainerHighest: card,
        onSurfaceVariant: secondaryForeground,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: foreground),
        titleTextStyle: TextStyle(
          color: foreground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        color: card,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryForeground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: input,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: border),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        hintStyle: const TextStyle(color: mutedForeground, fontSize: 14),
        prefixIconColor: secondaryForeground,
      ),
      dividerColor: border,
    );
  }
}
