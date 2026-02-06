import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A beautiful glassmorphic button with customizable effects and interactions.
///
/// Features haptic feedback, press states, and full customization of glass effects.
/// Perfect for modern iOS-style interfaces with premium interactions.
///
/// ## Basic Usage
///
/// ```dart
/// GlassyButton(
///   onPressed: () => print('Tapped!'),
///   child: Text('Click Me'),
/// )
/// ```
///
/// ## Advanced Usage
///
/// ```dart
/// GlassyButton(
///   onPressed: () => print('Tapped!'),
///   blur: 15,
///   opacity: 0.2,
///   color: Colors.blue,
///   borderRadius: BorderRadius.circular(16),
///   padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
///   enableHaptics: true,
///   pressedOpacity: 0.3,
///   child: Row(
///     mainAxisSize: MainAxisSize.min,
///     children: [
///       Icon(Icons.favorite),
///       SizedBox(width: 8),
///       Text('Premium Action'),
///     ],
///   ),
/// )
/// ```
///
/// ## Parameters
///
/// - [onPressed] - Callback when button is tapped (required)
/// - [child] - The widget to display inside the button (required)
/// - [blur] - Blur intensity (default: 10, range: 0-30)
/// - [opacity] - Glass opacity (default: 0.15, range: 0.0-1.0)
/// - [pressedOpacity] - Opacity when pressed (default: 0.25)
/// - [color] - Glass tint color (default: Colors.white)
/// - [borderRadius] - Corner radius (default: 12)
/// - [border] - Custom border (default: subtle white border)
/// - [padding] - Internal padding (default: 16 horizontal, 12 vertical)
/// - [margin] - External margin (default: none)
/// - [width] - Fixed width (default: auto)
/// - [height] - Fixed height (default: auto)
/// - [enableHaptics] - Enable haptic feedback (default: true)
/// - [hapticType] - Type of haptic feedback (default: light)
/// - [shadowColor] - Shadow color (default: black with 0.1 opacity)
/// - [shadowBlur] - Shadow blur radius (default: 15)
/// - [enableShadow] - Enable/disable shadow (default: true)
/// - [animationDuration] - Press animation duration (default: 150ms)
///
/// ## Haptic Feedback
///
/// Supports three types of haptic feedback:
/// - [HapticType.light] - Light tap feedback (default)
/// - [HapticType.medium] - Medium impact feedback
/// - [HapticType.heavy] - Heavy impact feedback
class KruiGlassyButton extends StatefulWidget {
  /// Callback when button is tapped (required)
  final VoidCallback? onPressed;

  /// The widget to display inside the button (required)
  final Widget child;

  /// Blur intensity (0-30, default: 10)
  final double blur;

  /// Glass opacity when not pressed (0.0-1.0, default: 0.15)
  final double opacity;

  /// Glass opacity when pressed (0.0-1.0, default: 0.25)
  final double pressedOpacity;

  /// Glass tint color (default: Colors.white)
  final Color color;

  /// Corner radius (default: BorderRadius.circular(12))
  final BorderRadius? borderRadius;

  /// Custom border (default: subtle white border)
  final Border? border;

  /// Internal padding (default: 16 horizontal, 12 vertical)
  final EdgeInsets? padding;

  /// External margin (default: none)
  final EdgeInsets? margin;

  /// Fixed width (default: auto)
  final double? width;

  /// Fixed height (default: auto)
  final double? height;

  /// Enable haptic feedback (default: true)
  final bool enableHaptics;

  /// Type of haptic feedback (default: light)
  final HapticType hapticType;

  /// Shadow color (default: black with 0.1 opacity)
  final Color? shadowColor;

  /// Shadow blur radius (default: 15)
  final double shadowBlur;

  /// Enable/disable shadow (default: true)
  final bool enableShadow;

  /// Press animation duration (default: 150ms)
  final Duration animationDuration;

  /// Whether the button is currently in a loading state
  final bool isLoading;

  /// Alignment of child within the button (default: center)
  final AlignmentGeometry alignment;

  /// Creates a glassmorphic button with customizable effects
  const KruiGlassyButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.blur = 10,
    this.opacity = 0.15,
    this.pressedOpacity = 0.25,
    this.color = Colors.white,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.enableHaptics = true,
    this.hapticType = HapticType.light,
    this.shadowColor,
    this.shadowBlur = 15,
    this.enableShadow = true,
    this.animationDuration = const Duration(milliseconds: 150),
    this.isLoading = false,
    this.alignment = Alignment.center,
  })  : assert(blur >= 0 && blur <= 30, 'Blur must be between 0 and 30'),
        assert(opacity >= 0 && opacity <= 1, 'Opacity must be between 0 and 1'),
        assert(pressedOpacity >= 0 && pressedOpacity <= 1,
            'Pressed opacity must be between 0 and 1');

  @override
  State<KruiGlassyButton> createState() => _KruiGlassyButtonState();
}

class _KruiGlassyButtonState extends State<KruiGlassyButton> {
  bool _isPressed = false;

  Future<void> _triggerHaptic() async {
    if (!widget.enableHaptics) return;

    switch (widget.hapticType) {
      case HapticType.light:
        await HapticFeedback.lightImpact();
        break;
      case HapticType.medium:
        await HapticFeedback.mediumImpact();
        break;
      case HapticType.heavy:
        await HapticFeedback.heavyImpact();
        break;
    }
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  void _handleTap() {
    _triggerHaptic();
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(12);
    final effectivePadding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    final effectiveShadowColor =
        widget.shadowColor ?? Colors.black.withValues(alpha: 0.1);
    final currentOpacity = _isPressed ? widget.pressedOpacity : widget.opacity;

    Widget button = GestureDetector(
      onTapDown: widget.onPressed != null ? _handleTapDown : null,
      onTapUp: widget.onPressed != null ? _handleTapUp : null,
      onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
      onTap: widget.onPressed != null ? _handleTap : null,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeOut,
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        decoration: widget.enableShadow
            ? BoxDecoration(
                borderRadius: effectiveBorderRadius,
                boxShadow: [
                  BoxShadow(
                    color: effectiveShadowColor,
                    blurRadius: widget.shadowBlur,
                    offset: const Offset(0, 4),
                  ),
                ],
              )
            : null,
        child: ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.blur,
              sigmaY: widget.blur,
              tileMode: TileMode.clamp,
            ),
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.easeOut,
              alignment: widget.alignment,
              padding: effectivePadding,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: currentOpacity),
                borderRadius: effectiveBorderRadius,
                border: widget.border ??
                    Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: widget.onPressed == null
                      ? Colors.grey.withValues(alpha: 0.5)
                      : Colors.black.withValues(alpha: 0.8),
                ),
                child: IconTheme(
                  data: IconThemeData(
                    color: widget.onPressed == null
                        ? Colors.grey.withValues(alpha: 0.5)
                        : Colors.black.withValues(alpha: 0.8),
                  ),
                  child: widget.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.onPressed == null
                                  ? Colors.grey.withValues(alpha: 0.5)
                                  : Colors.black.withValues(alpha: 0.8),
                            ),
                          ),
                        )
                      : widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.width == null && widget.height == null) {
      button = IntrinsicWidth(
        child: IntrinsicHeight(
          child: button,
        ),
      );
    }
    return button;
  }
}

/// Types of haptic feedback for GlassyButton
enum HapticType {
  /// Light impact feedback (subtle)
  light,

  /// Medium impact feedback (moderate)
  medium,

  /// Heavy impact feedback (strong)
  heavy,
}

/// Preset configurations for common GlassyButton styles
class GlassyButtonPresets {
  /// Primary action button - strong visual presence
  static KruiGlassyButton primary({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return KruiGlassyButton(
      onPressed: onPressed,
      blur: 12,
      opacity: 0.2,
      pressedOpacity: 0.3,
      color: const Color(0xFF007AFF), // iOS blue
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      borderRadius: BorderRadius.circular(12),
      child: child,
    );
  }

  /// Secondary action button - subtle appearance
  static KruiGlassyButton secondary({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return KruiGlassyButton(
      onPressed: onPressed,
      blur: 8,
      opacity: 0.12,
      pressedOpacity: 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      borderRadius: BorderRadius.circular(12),
      child: child,
    );
  }

  /// Danger/destructive action button - red tint
  static KruiGlassyButton danger({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return KruiGlassyButton(
      onPressed: onPressed,
      blur: 12,
      opacity: 0.2,
      pressedOpacity: 0.3,
      color: const Color(0xFFFF3B30), // iOS red
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      borderRadius: BorderRadius.circular(12),
      child: child,
    );
  }

  /// Success action button - green tint
  static KruiGlassyButton success({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return KruiGlassyButton(
      onPressed: onPressed,
      blur: 12,
      opacity: 0.2,
      pressedOpacity: 0.3,
      color: const Color(0xFF34C759), // iOS green
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      borderRadius: BorderRadius.circular(12),
      child: child,
    );
  }

  /// Icon button - small, square, for icon-only actions
  static KruiGlassyButton icon({
    required VoidCallback? onPressed,
    required Widget icon,
  }) {
    return KruiGlassyButton(
      onPressed: onPressed,
      blur: 8,
      opacity: 0.15,
      pressedOpacity: 0.25,
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(10),
      child: icon,
    );
  }

  /// Outline button - transparent with a prominent border
  static KruiGlassyButton outline({
    required VoidCallback? onPressed,
    required Widget child,
    Color color = Colors.white,
  }) {
    return KruiGlassyButton(
      onPressed: onPressed,
      blur: 4,
      opacity: 0.05,
      pressedOpacity: 0.12,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.6), width: 1.5),
      enableShadow: false,
      child: child,
    );
  }

  /// Ghost button - very subtle background, no border
  static KruiGlassyButton ghost({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return KruiGlassyButton(
      onPressed: onPressed,
      blur: 4,
      opacity: 0.0,
      pressedOpacity: 0.08,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      borderRadius: BorderRadius.circular(12),
      enableShadow: false,
      border: Border.all(color: Colors.transparent, width: 0),
      child: child,
    );
  }

  /// Link button - minimal text link style, no background or border
  static KruiGlassyButton link({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return KruiGlassyButton(
      onPressed: onPressed,
      blur: 0,
      opacity: 0.0,
      pressedOpacity: 0.0,
      enableShadow: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.transparent, width: 0),
      child: child,
    );
  }

  /// Gradient and Shadow - premium vibrant look
  static KruiGlassyButton gradient({
    required VoidCallback? onPressed,
    required Widget child,
    required List<Color> colors,
  }) {
    return KruiGlassyButton(
      onPressed: onPressed,
      blur: 12,
      opacity: 0.25,
      pressedOpacity: 0.35,
      color: colors.first,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(12),
      shadowColor: colors.first.withValues(alpha: 0.35),
      shadowBlur: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
