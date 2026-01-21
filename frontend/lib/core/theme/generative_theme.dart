import 'package:flutter/material.dart';
import 'dart:ui';

@immutable
class GenerativeTheme extends ThemeExtension<GenerativeTheme> {
  final Color vibeStartColor;
  final Color vibeEndColor;
  final Color goldAccent;
  final double physicsGravity;
  final double blurSigma;

  const GenerativeTheme({
    required this.vibeStartColor,
    required this.vibeEndColor,
    required this.goldAccent,
    required this.physicsGravity,
    required this.blurSigma,
  });

  // Default "Champagne" state
  factory GenerativeTheme.champagne() {
    return const GenerativeTheme(
      vibeStartColor: Color(0xFFFFF8E7), // Cosmic Latte
      vibeEndColor: Color(0xFFD4AF37),   // Metallic Gold
      goldAccent: Color(0xFFD4AF37),
      physicsGravity: 0.2,
      blurSigma: 10.0,
    );
  }
  
  // "Rose" state
  factory GenerativeTheme.rose() {
    return const GenerativeTheme(
      vibeStartColor: Color(0xFFFFF0F5), // Lavender Blush
      vibeEndColor: Color(0xFFB76E79),   // Rose Gold
      goldAccent: Color(0xFFB76E79),
      physicsGravity: 0.8,
      blurSigma: 15.0,
    );
  }

  @override
  GenerativeTheme copyWith({
    Color? vibeStartColor,
    Color? vibeEndColor,
    Color? goldAccent,
    double? physicsGravity,
    double? blurSigma,
  }) {
    return GenerativeTheme(
      vibeStartColor: vibeStartColor ?? this.vibeStartColor,
      vibeEndColor: vibeEndColor ?? this.vibeEndColor,
      goldAccent: goldAccent ?? this.goldAccent,
      physicsGravity: physicsGravity ?? this.physicsGravity,
      blurSigma: blurSigma ?? this.blurSigma,
    );
  }

  @override
  GenerativeTheme lerp(ThemeExtension<GenerativeTheme>? other, double t) {
    if (other is! GenerativeTheme) {
      return this;
    }
    return GenerativeTheme(
      vibeStartColor: Color.lerp(vibeStartColor, other.vibeStartColor, t)!,
      vibeEndColor: Color.lerp(vibeEndColor, other.vibeEndColor, t)!,
      goldAccent: Color.lerp(goldAccent, other.goldAccent, t)!,
      physicsGravity: lerpDouble(physicsGravity, other.physicsGravity, t)!,
      blurSigma: lerpDouble(blurSigma, other.blurSigma, t)!,
    );
  }
}
