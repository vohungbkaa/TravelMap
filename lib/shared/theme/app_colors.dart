import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Heritage palette: clean warm off-white, terracotta, deep forest green, gold
  static const Color background = Color(0xFFFBFBFB);
  static const Color foreground = Color(0xFF2D221A);

  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF2D221A);

  static const Color primary = Color(0xFFA64B2A);
  static const Color primaryForeground = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFFF4F1EA);
  static const Color secondaryForeground = Color(0xFF3D2C20);

  static const Color accent = Color(0xFF1E5631);
  static const Color accentForeground = Color(0xFFFFFFFF);

  static const Color gold = Color(0xFFE5A93C);
  static const Color goldSurface = Color(0xFFFFF9EE);

  static const Color muted = Color(0xFFF0ECE1);
  static const Color mutedForeground = Color(0xFF7A6B5D);

  static const Color border = Color(0xFFECE6D8);
  static const Color destructive = Color(0xFFD32F2F);

  // Gradients
  static const LinearGradient gradientHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFA64B2A), Color(0xFF7E351B)],
  );

  static const LinearGradient gradientWarm = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFBFBFB), Color(0xFFF4F1EA)],
  );

  static const LinearGradient gradientAvatar = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFA64B2A), Color(0xFF1E5631)],
  );

  // Shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF2D221A).withValues(alpha: 0.07),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}
