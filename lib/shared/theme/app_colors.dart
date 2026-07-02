import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Heritage palette: clean warm off-white, terracotta, deep forest green, gold
  static const Color background = Color(0xFFF9F4E8);
  static const Color foreground = Color(0xFF453C35);

  static const Color card = Color(0xFFFFFBFA);
  static const Color cardForeground = Color(0xFF453C35);

  static const Color primary = Color(0xFFB33D20);
  static const Color primaryForeground = Color(0xFFFFFDFC);

  static const Color secondary = Color(0xFFF0EBE0);
  static const Color secondaryForeground = Color(0xFF564D45);

  static const Color accent = Color(0xFF587158);
  static const Color accentForeground = Color(0xFFFFFDFC);

  static const Color gold = Color(0xFFD7C186);
  static const Color goldSurface = Color(0xFFFFF9EE);

  static const Color muted = Color(0xFFF2EBE1);
  static const Color mutedForeground = Color(0xFF8A7B6D);

  static const Color border = Color(0xFFE5DED4);
  static const Color destructive = Color(0xFFB33300);

  // Gradients
  static const LinearGradient gradientHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB33D20), Color(0xFF9E361B)],
  );

  static const LinearGradient gradientWarm = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF9F4E8), Color(0xFFF0E5D5)],
  );

  static const LinearGradient gradientAvatar = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB33D20), Color(0xFF587158)],
  );

  // Shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF453C35).withValues(alpha: 0.07),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}
