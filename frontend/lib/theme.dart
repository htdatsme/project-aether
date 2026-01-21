import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AetherTheme {
  // Fresh / Aquatic Palette (Reference A)
  static const Color freshMistTeal = Color(0xFFD4DDDC);
  static const Color freshBoneWhite = Color(0xFFF0ECE3);
  static const Color freshCharcoal = Color(0xFF424340);

  // Oud / Leather Palette (Reference B)
  static const Color oudAntiqueGold = Color(0xFFC29B57);
  static const Color oudDeepBronze = Color(0xFF856439);
  static const Color oudObsidian = Color(0xFF0D0E10);
  static const Color oudGunmetal = Color(0xFF212628);

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.bodoniModa(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.bodoniModa(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
      ),
    );
  }

  static ThemeData get freshTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: freshBoneWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: freshMistTeal,
        background: freshBoneWhite,
        surface: freshMistTeal, // Surface as "Mist"
        onSurface: freshCharcoal,
        primary: freshMistTeal,
        secondary: freshCharcoal,
        brightness: Brightness.light,
      ),
      textTheme: _textTheme.apply(
        bodyColor: freshCharcoal,
        displayColor: freshCharcoal,
      ),
    );
  }

  static ThemeData get oudTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: oudObsidian,
      colorScheme: ColorScheme.fromSeed(
        seedColor: oudAntiqueGold,
        background: oudObsidian,
        surface: oudGunmetal,
        onSurface: oudAntiqueGold,
        primary: oudAntiqueGold,
        secondary: oudDeepBronze,
        brightness: Brightness.dark,
      ),
      textTheme: _textTheme.apply(
        bodyColor: freshBoneWhite, // High contrast against dark
        displayColor: oudAntiqueGold,
      ),
    );
  }

  // Keeping legacy getters mapped to new styles for compatibility
  static ThemeData get lightTheme => freshTheme;
  static ThemeData get darkTheme => oudTheme;
}
