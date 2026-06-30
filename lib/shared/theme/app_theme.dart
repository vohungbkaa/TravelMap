import 'package:flutter/material.dart';
import 'package:travel_map/shared/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _scaleTextTheme(TextTheme textTheme) {
    TextStyle? scale(TextStyle? style) {
      if (style == null) return null;
      if (style.fontSize != null) {
        return style.copyWith(fontSize: style.fontSize! + 1.0);
      }
      return style;
    }

    return textTheme.copyWith(
      displayLarge: scale(textTheme.displayLarge),
      displayMedium: scale(textTheme.displayMedium),
      displaySmall: scale(textTheme.displaySmall),
      headlineLarge: scale(textTheme.headlineLarge),
      headlineMedium: scale(textTheme.headlineMedium),
      headlineSmall: scale(textTheme.headlineSmall),
      titleLarge: scale(textTheme.titleLarge),
      titleMedium: scale(textTheme.titleMedium),
      titleSmall: scale(textTheme.titleSmall),
      bodyLarge: scale(textTheme.bodyLarge),
      bodyMedium: scale(textTheme.bodyMedium),
      bodySmall: scale(textTheme.bodySmall),
      labelLarge: scale(textTheme.labelLarge),
      labelMedium: scale(textTheme.labelMedium),
      labelSmall: scale(textTheme.labelSmall),
    );
  }

  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        surface: AppColors.background,
        onSurface: AppColors.foreground,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.secondaryForeground,
        tertiary: AppColors.accent,
        onTertiary: AppColors.accentForeground,
        outline: AppColors.border,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    final scaledTextTheme = _scaleTextTheme(
      baseTheme.textTheme.apply(
        bodyColor: AppColors.foreground,
        displayColor: AppColors.foreground,
      ),
    );

    return baseTheme.copyWith(
      textTheme: scaledTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.foreground,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.foreground),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.border.withValues(alpha: 0.6),
            width: 0.8,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.secondary,
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        labelStyle: const TextStyle(
          fontSize: 13,
          color: AppColors.foreground,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: const TextStyle(
          fontSize: 13,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.mutedForeground,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
