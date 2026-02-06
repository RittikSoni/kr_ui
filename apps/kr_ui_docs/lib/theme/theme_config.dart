import 'package:flutter/material.dart';

/// Available color themes for the documentation site
enum AppColorTheme {
  blue('Blue', 'iOS-inspired blue theme'),
  yellow('Yellow', 'Warm yellow/gold theme'),
  navy('Navy', 'Deep navy blue theme'),
  purple('Purple', 'Vibrant purple theme'),
  green('Green', 'Fresh green theme'),
  pink('Pink', 'Soft pink theme');

  final String displayName;
  final String description;

  const AppColorTheme(this.displayName, this.description);
}

/// Brightness mode for the theme
enum AppBrightnessMode {
  light,
  dark,
}

/// Color theme definitions with light and dark variants
class ColorThemeData {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final List<Color> gradientColors;

  const ColorThemeData({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.gradientColors,
  });

  /// Get color theme data for a specific theme and brightness
  static ColorThemeData get(AppColorTheme theme, AppBrightnessMode mode) {
    final bool isDark = mode == AppBrightnessMode.dark;

    switch (theme) {
      case AppColorTheme.blue:
        return ColorThemeData(
          primary: const Color(0xFF007AFF),
          primaryDark: const Color(0xFF0051D5),
          primaryLight: const Color(0xFF3395FF),
          gradientColors: isDark
              ? [
                  const Color(0xFF007AFF),
                  const Color(0xFF0051D5),
                  const Color(0xFF5E5CE6)
                ]
              : [
                  const Color(0xFF007AFF),
                  const Color(0xFF0051D5),
                  const Color(0xFF8B5CF6)
                ],
        );

      case AppColorTheme.yellow:
        return ColorThemeData(
          primary: const Color(0xFFFFB800),
          primaryDark: const Color(0xFFFF9500),
          primaryLight: const Color(0xFFFFD60A),
          gradientColors: isDark
              ? [
                  const Color(0xFFFFB800),
                  const Color(0xFFFF9500),
                  const Color(0xFFFF6B00)
                ]
              : [
                  const Color(0xFFFFD60A),
                  const Color(0xFFFFB800),
                  const Color(0xFFFF9500)
                ],
        );

      case AppColorTheme.navy:
        return ColorThemeData(
          primary: const Color(0xFF1E3A8A),
          primaryDark: const Color(0xFF1E40AF),
          primaryLight: const Color(0xFF3B82F6),
          gradientColors: isDark
              ? [
                  const Color(0xFF1E3A8A),
                  const Color(0xFF1E40AF),
                  const Color(0xFF06B6D4)
                ]
              : [
                  const Color(0xFF1E3A8A),
                  const Color(0xFF3B82F6),
                  const Color(0xFF06B6D4)
                ],
        );

      case AppColorTheme.purple:
        return ColorThemeData(
          primary: const Color(0xFF8B5CF6),
          primaryDark: const Color(0xFF7C3AED),
          primaryLight: const Color(0xFFA78BFA),
          gradientColors: isDark
              ? [
                  const Color(0xFF8B5CF6),
                  const Color(0xFF7C3AED),
                  const Color(0xFFD946EF)
                ]
              : [
                  const Color(0xFF8B5CF6),
                  const Color(0xFFA78BFA),
                  const Color(0xFFEC4899)
                ],
        );

      case AppColorTheme.green:
        return ColorThemeData(
          primary: const Color(0xFF10B981),
          primaryDark: const Color(0xFF059669),
          primaryLight: const Color(0xFF34D399),
          gradientColors: isDark
              ? [
                  const Color(0xFF10B981),
                  const Color(0xFF059669),
                  const Color(0xFF14B8A6)
                ]
              : [
                  const Color(0xFF10B981),
                  const Color(0xFF34D399),
                  const Color(0xFF14B8A6)
                ],
        );

      case AppColorTheme.pink:
        return ColorThemeData(
          primary: const Color(0xFFEC4899),
          primaryDark: const Color(0xFFDB2777),
          primaryLight: const Color(0xFFF472B6),
          gradientColors: isDark
              ? [
                  const Color(0xFFEC4899),
                  const Color(0xFFDB2777),
                  const Color(0xFFF43F5E)
                ]
              : [
                  const Color(0xFFEC4899),
                  const Color(0xFFF472B6),
                  const Color(0xFFFBBF24)
                ],
        );
    }
  }
}
