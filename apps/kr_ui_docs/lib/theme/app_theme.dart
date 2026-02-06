import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_provider.dart';

/// Extension on AppTheme for dynamic theming Support
class DynamicTheme {
  final ThemeProvider provider;

  const DynamicTheme(this.provider);

  // ============================================================
  // DYNAMIC COLOR PALETTE
  // ============================================================

  /// Primary color based on current theme
  Color get primary => provider.currentColorData.primary;
  Color get primaryDark => provider.currentColorData.primaryDark;
  Color get primaryLight => provider.currentColorData.primaryLight;
  List<Color> get gradientColors => provider.currentColorData.gradientColors;

  // Surface Colors based on brightness
  Color get surface => provider.isDarkMode
      ? const Color(0xFF1E293B) // slate-800
      : const Color(0xFFFFFFFF);

  Color get surfaceBackground => provider.isDarkMode
      ? const Color(0xFF0F172A) // slate-900
      : const Color(0xFFF5F5F7);

  Color get surfaceCard => provider.isDarkMode
      ? const Color(0xFF334155) // slate-700
      : const Color(0xFFFFFFFF);

  // Text Colors based on brightness
  Color get textPrimary => provider.isDarkMode
      ? const Color(0xFFF1F5F9) // slate-100
      : const Color(0xFF000000);

  Color get textSecondary => provider.isDarkMode
      ? const Color(0xFF94A3B8) // slate-400
      : const Color(0xFF666666);

  Color get textTertiary => provider.isDarkMode
      ? const Color(0xFF64748B) // slate-500
      : const Color(0xFF999999);

  // Border Colors based on brightness
  Color get borderLight => provider.isDarkMode
      ? const Color(0xFF334155) // slate-700
      : const Color(0xFFE5E5EA);

  Color get borderMedium => provider.isDarkMode
      ? const Color(0xFF475569) // slate-600
      : const Color(0xFFD1D1D6);

  // Code Background
  Color get codeBackground => provider.isDarkMode
      ? const Color(0xFF1E293B) // slate-800
      : const Color(0xFFF6F8FA);

  Color get surfaceGray => provider.isDarkMode
      ? const Color(0xFF0F172A).withValues(alpha: 0.5)
      : const Color(0xFFF9FAFB);

  // ============================================================
  // COMPLETE THEME DATA
  // ============================================================

  /// Generate complete ThemeData based on current settings
  ThemeData get themeData {
    final isDark = provider.isDarkMode;
    final colorData = provider.currentColorData;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      textTheme: GoogleFonts.gildaDisplayTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorData.primary,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: colorData.primary,
        secondary: colorData.primaryLight,
      ),
      scaffoldBackgroundColor: surfaceBackground,
      cardColor: surfaceCard,
      dividerColor: borderLight,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: colorData.primary.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorData.primary);
          }
          return IconThemeData(color: textSecondary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final style =
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500);
          if (states.contains(WidgetState.selected)) {
            return style.copyWith(color: colorData.primary);
          }
          return style.copyWith(color: textSecondary);
        }),
      ),
    );
  }
}

/// Comprehensive design system for kr_ui documentation (unchanged for compatibility)
class AppTheme {
  // ============================================================
  // COLOR PALETTE
  // ============================================================

  // Primary Colors (kept for backward compatibility)
  static const Color primaryBlue = Color(0xFF007AFF);
  static const Color primaryBlueDark = Color(0xFF0051D5);
  static const Color primaryBlueLight = Color(0xFF4DA3FF);

  // Surface Colors
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceGray = Color(0xFFF5F5F7);
  static const Color surfaceGrayLight = Color(0xFFFBFBFC);
  static const Color surfaceDark = Color(0xFF1C1C1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Accent Colors
  static const Color accentGreen = Color(0xFF34C759);
  static const Color accentRed = Color(0xFFFF3B30);
  static const Color accentOrange = Color(0xFFFF9500);
  static const Color accentPurple = Color(0xFF5856D6);

  // Border Colors
  static const Color borderLight = Color(0xFFE5E5EA);
  static const Color borderMedium = Color(0xFFD1D1D6);
  static const Color borderDark = Color(0xFFC7C7CC);

  // Code Syntax Colors (Light Theme)
  static const Color codeKeyword = Color(0xFF9B2393);
  static const Color codeString = Color(0xFFD02020);
  static const Color codeNumber = Color(0xFF1750EB);
  static const Color codeComment = Color(0xFF5D6C79);
  static const Color codeClass = Color(0xFF3F6E75);
  static const Color codeFunction = Color(0xFF0F68A0);
  static const Color codeBackground = Color(0xFFF6F8FA);

  // ============================================================
  // TYPOGRAPHY
  // ============================================================

  // Display (Hero text)
  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 64,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -2,
  );

  static TextStyle displayMedium = GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -1.5,
  );

  // Headings
  static TextStyle h1 = GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -1,
  );

  static TextStyle h2 = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.5,
  );

  static TextStyle h3 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle h4 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body Text
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Code Text
  static TextStyle codeLarge = GoogleFonts.jetBrainsMono(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle codeMedium = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle codeSmall = GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Labels & Captions
  static TextStyle label = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ============================================================
  // SPACING SYSTEM (4px base grid)
  // ============================================================

  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space64 = 64.0;
  static const double space80 = 80.0;
  static const double space96 = 96.0;

  // ============================================================
  // BORDER RADIUS
  // ============================================================

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusFull = 9999.0;

  static BorderRadius borderRadiusSmall = BorderRadius.circular(radiusSmall);
  static BorderRadius borderRadiusMedium = BorderRadius.circular(radiusMedium);
  static BorderRadius borderRadiusLarge = BorderRadius.circular(radiusLarge);
  static BorderRadius borderRadiusXLarge = BorderRadius.circular(radiusXLarge);
  static BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);

  // ============================================================
  // SHADOWS
  // ============================================================

  static List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowXLarge = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 40,
      offset: const Offset(0, 16),
    ),
  ];

  // ============================================================
  // ANIMATION DURATIONS & CURVES
  // ============================================================

  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 350);

  static const Curve curveStandard = Curves.easeInOut;
  static const Curve curveEmphasized = Curves.easeOutCubic;
  static const Curve curveDecelerate = Curves.easeOut;

  // ============================================================
  // RESPONSIVE BREAKPOINTS
  // ============================================================

  static const double breakpointMobile = 768;
  static const double breakpointTablet = 1024;
  static const double breakpointDesktop = 1440;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < breakpointMobile;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= breakpointMobile &&
      MediaQuery.of(context).size.width < breakpointTablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= breakpointTablet;
}
