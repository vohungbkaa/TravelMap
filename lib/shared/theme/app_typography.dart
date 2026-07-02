import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  // Scale factor (can be adjusted easily centrally). Increased to 1.28 to match viewport layout proportions
  static double scale = 1.28;

  // Base font size values (scaled dynamically)
  static double get s25 => 25.0 * scale;
  static double get s24 => 24.0 * scale;
  static double get s23 => 23.0 * scale;
  static double get s22 => 22.0 * scale;
  static double get s21 => 21.0 * scale;
  static double get s20 => 20.0 * scale;
  static double get s19 => 19.0 * scale;
  static double get s18 => 18.0 * scale;
  static double get s17 => 17.0 * scale;
  static double get s16 => 16.0 * scale;
  static double get s15 => 15.0 * scale;
  static double get s14 => 14.0 * scale;
  static double get s13 => 13.0 * scale;
  static double get s12 => 12.0 * scale;
  static double get s11 => 11.0 * scale;
  static double get s10 => 10.0 * scale;
  static double get s9 => 9.0 * scale;
  static double get s8 => 8.0 * scale;
  static double get s7 => 7.0 * scale;
  static double get s6 => 6.0 * scale;

  // Static builders for scaled text styles
  static TextStyle style({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    List<Shadow>? shadows,
  }) {
    return TextStyle(
      fontSize: fontSize * scale,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      shadows: shadows,
    );
  }
}
