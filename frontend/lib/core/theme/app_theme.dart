import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'generative_theme.dart';

class AppTheme {
  // Global Background: #FAF9F6 (Alabaster / Off-White) - CONSTANT
  static const Color scaffoldBackgroundColor = Color(0xFFFAF9F6);
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color obsidianText = Color(0xFF1A1A1A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: goldAccent,
        background: scaffoldBackgroundColor,
        surface: scaffoldBackgroundColor,
        onSurface: obsidianText,
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cinzelDecorative(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: obsidianText,
        ),
        displayMedium: GoogleFonts.cinzelDecorative(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: obsidianText,
        ),
        displaySmall: GoogleFonts.cinzelDecorative(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: obsidianText,
        ),
        titleLarge: GoogleFonts.cinzelDecorative(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: obsidianText,
        ),
        headlineSmall: GoogleFonts.cormorantGaramond(
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          color: obsidianText,
        ),
        labelLarge: GoogleFonts.cinzelDecorative(
          fontWeight: FontWeight.w700,
          letterSpacing: 2.0,
          color: goldAccent,
        ),
        bodyLarge: GoogleFonts.cormorantGaramond(
          fontSize: 18.0,
          color: obsidianText,
        ),
        bodyMedium: GoogleFonts.cormorantGaramond(
          fontSize: 18.0,
          color: obsidianText,
        ),
      ),
      extensions: const [
        // Default to Champagne Vibe as base
        GenerativeTheme(
          vibeStartColor: Color(0xFFFFF8E7), // Cosmic Latte
          vibeEndColor: Color(0xFFD4AF37),   // Metallic Gold
          goldAccent: goldAccent,
          physicsGravity: 0.2,
          blurSigma: 10.0,
        ),
      ],
    );
  }
}
