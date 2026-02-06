import 'dart:ui';
import 'package:flutter/material.dart';

/// A beautiful glassmorphic card widget with customizable frosted glass effects.
///
/// Perfect for creating modern iOS-style interfaces with depth and elegance.
/// Supports full customization of blur intensity, opacity, colors, borders,
/// shadows, and more.
///
/// ## Basic Usage
///
/// ```dart
/// GlassyCard(
///   child: Text('Beautiful Glass Effect'),
/// )
/// ```
///
/// ## Advanced Usage
///
/// ```dart
/// GlassyCard(
///   blur: 15,
///   opacity: 0.2,
///   color: Colors.white,
///   borderRadius: BorderRadius.circular(24),
///   border: Border.all(color: Colors.white.withValues(alpha:0.3), width: 2),
///   shadowColor: Colors.black.withValues(alpha:0.1),
///   padding: EdgeInsets.all(24),
///   child: Column(
///     children: [
///       Icon(Icons.favorite, size: 48),
///       Text('Premium Design'),
///     ],
///   ),
/// )
/// ```
///
/// ## Parameters
///
/// - [child] - The widget to display inside the glass card (required)
/// - [blur] - Blur intensity (default: 10, range: 0-30)
/// - [opacity] - Glass opacity (default: 0.15, range: 0.0-1.0)
/// - [color] - Glass tint color (default: Colors.white)
/// - [borderRadius] - Corner radius (default: 16)
/// - [border] - Custom border (default: subtle white border)
/// - [padding] - Internal padding (default: 16 on all sides)
/// - [margin] - External margin (default: none)
/// - [width] - Fixed width (default: auto)
/// - [height] - Fixed height (default: auto)
/// - [shadowColor] - Shadow color (default: black with 0.1 opacity)
/// - [shadowBlur] - Shadow blur radius (default: 20)
/// - [shadowOffset] - Shadow offset (default: Offset(0, 10))
/// - [enableShadow] - Enable/disable shadow (default: true)
///
/// ## Performance Tips
///
/// - Lower blur values (5-10) are more performant
/// - Use [RepaintBoundary] for complex layouts
/// - Avoid animating blur frequently (expensive operation)
class KruiGlassyCard extends StatelessWidget {
  /// The widget to display inside the glass card
  final Widget child;

  /// Blur intensity (0-30, default: 10)
  final double blur;

  /// Glass opacity (0.0-1.0, default: 0.15)
  final double opacity;

  /// Glass tint color (default: Colors.white)
  final Color color;

  /// Corner radius (default: BorderRadius.circular(16))
  final BorderRadius? borderRadius;

  /// Custom border (default: subtle white border)
  final Border? border;

  /// Internal padding (default: EdgeInsets.all(16))
  final EdgeInsets? padding;

  /// External margin (default: none)
  final EdgeInsets? margin;

  /// Fixed width (default: auto)
  final double? width;

  /// Fixed height (default: auto)
  final double? height;

  /// Shadow color (default: black with 0.1 opacity)
  final Color? shadowColor;

  /// Shadow blur radius (default: 20)
  final double shadowBlur;

  /// Shadow offset (default: Offset(0, 10))
  final Offset shadowOffset;

  /// Enable/disable shadow (default: true)
  final bool enableShadow;

  /// Alignment of child within the card (default: null)
  final AlignmentGeometry? alignment;

  /// Creates a glassmorphic card with customizable effects
  const KruiGlassyCard({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.15,
    this.color = Colors.white,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.shadowColor,
    this.shadowBlur = 20,
    this.shadowOffset = const Offset(0, 10),
    this.enableShadow = true,
    this.alignment,
  })  : assert(blur >= 0 && blur <= 30, 'Blur must be between 0 and 30'),
        assert(opacity >= 0 && opacity <= 1, 'Opacity must be between 0 and 1');

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final effectivePadding = padding ?? const EdgeInsets.all(16);
    final effectiveShadowColor =
        shadowColor ?? Colors.black.withValues(alpha: 0.1);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: enableShadow
          ? BoxDecoration(
              borderRadius: effectiveBorderRadius,
              boxShadow: [
                BoxShadow(
                  color: effectiveShadowColor,
                  blurRadius: shadowBlur,
                  offset: shadowOffset,
                ),
              ],
            )
          : null,
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur,
            sigmaY: blur,
            tileMode: TileMode.clamp,
          ),
          child: Container(
            alignment: alignment,
            padding: effectivePadding,
            decoration: BoxDecoration(
              color: color.withValues(alpha: opacity),
              borderRadius: effectiveBorderRadius,
              border: border ??
                  Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Preset configurations for common GlassyCard styles
class GlassyCardPresets {
  /// Subtle glass effect - minimal blur, low opacity
  static KruiGlassyCard subtle({required Widget child}) {
    return KruiGlassyCard(
      blur: 5,
      opacity: 0.1,
      child: child,
    );
  }

  /// Standard glass effect - balanced blur and opacity
  static KruiGlassyCard standard({required Widget child}) {
    return KruiGlassyCard(
      blur: 10,
      opacity: 0.15,
      child: child,
    );
  }

  /// Strong glass effect - high blur, higher opacity
  static KruiGlassyCard strong({required Widget child}) {
    return KruiGlassyCard(
      blur: 20,
      opacity: 0.25,
      child: child,
    );
  }

  /// Dark glass effect - dark tint with moderate blur
  static KruiGlassyCard dark({required Widget child}) {
    return KruiGlassyCard(
      blur: 15,
      opacity: 0.3,
      color: Colors.black,
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.1),
        width: 1,
      ),
      child: child,
    );
  }

  /// Colored glass effect - custom color tint
  static KruiGlassyCard colored({
    required Widget child,
    required Color color,
  }) {
    return KruiGlassyCard(
      blur: 12,
      opacity: 0.2,
      color: color,
      border: Border.all(
        color: color.withValues(alpha: 0.3),
        width: 1.5,
      ),
      child: child,
    );
  }
}
