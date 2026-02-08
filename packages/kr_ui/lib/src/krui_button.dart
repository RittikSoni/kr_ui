import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Button variant types for different use cases
enum KruiButtonVariant {
  /// Solid background with high contrast - primary actions
  primary,

  /// Muted background with medium contrast - secondary actions
  secondary,

  /// Red/danger styling for destructive actions
  destructive,

  /// Border only with transparent background
  outline,

  /// Minimal styling with hover states only
  ghost,

  /// Text-only with underline on hover
  link,

  /// Gradient background with animated shadow
  gradient,

  /// Glassmorphic design with blur and transparency
  glassy,

  /// Glowing effect with pulsing animation
  glowy,
}

/// Icon position in button
enum KruiButtonIconPosition {
  /// Icon appears before the label
  leading,

  /// Icon appears after the label
  trailing,
}

/// A universal, production-ready button component with multiple variants.
///
/// Supports icons, loading states, haptic feedback, and optional ripple effects.
/// Designed to cover all edge cases with big-tech level polish and performance.
///
/// Example:
/// ```dart
/// KruiButton(
///   variant: KruiButtonVariant.primary,
///   label: 'Click Me',
///   onPressed: () => print('Pressed'),
///   icon: Icons.check,
///   iconPosition: KruiButtonIconPosition.leading,
/// )
/// ```
class KruiButton extends StatefulWidget {
  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button label text
  final String? label;

  /// Custom child widget (overrides label if provided)
  final Widget? child;

  /// Button style variant (defaults to primary)
  final KruiButtonVariant variant;

  /// Optional icon to display
  final IconData? icon;

  /// Icon position relative to label
  final KruiButtonIconPosition iconPosition;

  /// Whether button is in loading state
  final bool isLoading;

  /// Enable ripple animation effect (set false for better performance)
  final bool enableRipple;

  /// Enable haptic feedback on press
  final bool enableHaptics;

  /// Custom border radius
  final BorderRadius? borderRadius;

  /// Custom padding
  final EdgeInsets? padding;

  /// Animation duration for transitions
  final Duration animationDuration;

  /// Custom background color (overrides variant default)
  final Color? backgroundColor;

  /// Custom text/icon color (overrides variant default)
  final Color? foregroundColor;

  /// Custom border color for outline variant
  final Color? borderColor;

  /// Icon size
  final double iconSize;

  /// Text style override
  final TextStyle? textStyle;

  /// Minimum button width
  final double? minWidth;

  /// Minimum button height
  final double? minHeight;

  /// Gradient colors (only for gradient variant)
  final List<Color>? gradientColors;

  /// Elevation/shadow intensity (0-10)
  final double elevation;

  const KruiButton({
    super.key,
    this.variant = KruiButtonVariant.primary,
    this.onPressed,
    this.label,
    this.child,
    this.icon,
    this.iconPosition = KruiButtonIconPosition.leading,
    this.isLoading = false,
    this.enableRipple = true,
    this.enableHaptics = true,
    this.borderRadius,
    this.padding,
    this.animationDuration = const Duration(milliseconds: 200),
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.iconSize = 20,
    this.textStyle,
    this.minWidth,
    this.minHeight,
    this.gradientColors,
    this.elevation = 2,
  }) : assert(
          label != null || child != null,
          'Either label or child must be provided',
        );

  @override
  State<KruiButton> createState() => _KruiButtonState();
}

class _KruiButtonState extends State<KruiButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _isHovered = false;
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    if (widget.variant == KruiButtonVariant.gradient ||
        widget.variant == KruiButtonVariant.glowy) {
      _gradientController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  void _triggerHaptic() {
    if (widget.enableHaptics && widget.onPressed != null && !widget.isLoading) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTap() {
    if (widget.onPressed != null && !widget.isLoading) {
      _triggerHaptic();
      widget.onPressed!();
    }
  }

  // Get variant-specific styling
  _ButtonStyle _getButtonStyle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (widget.variant) {
      case KruiButtonVariant.primary:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ??
              (isDark
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF2563EB)), // Blue
          foregroundColor: widget.foregroundColor ?? Colors.white,
          borderColor: Colors.transparent,
          showBorder: false,
          showShadow: true,
          isGlassy: false,
        );

      case KruiButtonVariant.secondary:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ??
              (isDark
                  ? const Color(0xFF374151)
                  : const Color(0xFFE5E7EB)), // Gray
          foregroundColor: widget.foregroundColor ??
              (isDark ? Colors.white : const Color(0xFF1F2937)),
          borderColor: Colors.transparent,
          showBorder: false,
          showShadow: false,
          isGlassy: false,
        );

      case KruiButtonVariant.destructive:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ??
              (isDark
                  ? const Color(0xFFDC2626)
                  : const Color(0xFFEF4444)), // Red
          foregroundColor: widget.foregroundColor ?? Colors.white,
          borderColor: Colors.transparent,
          showBorder: false,
          showShadow: true,
          isGlassy: false,
        );

      case KruiButtonVariant.outline:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          foregroundColor: widget.foregroundColor ??
              (isDark ? Colors.white : const Color(0xFF1F2937)),
          borderColor: widget.borderColor ??
              (isDark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB)),
          showBorder: true,
          showShadow: false,
          isGlassy: false,
        );

      case KruiButtonVariant.ghost:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          foregroundColor: widget.foregroundColor ??
              (isDark ? Colors.white : const Color(0xFF1F2937)),
          borderColor: Colors.transparent,
          showBorder: false,
          showShadow: false,
          isGlassy: false,
        );

      case KruiButtonVariant.link:
        return _ButtonStyle(
          backgroundColor: Colors.transparent,
          foregroundColor: widget.foregroundColor ??
              (isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
          borderColor: Colors.transparent,
          showBorder: false,
          showShadow: false,
          isGlassy: false,
        );

      case KruiButtonVariant.gradient:
        return _ButtonStyle(
          backgroundColor: Colors.transparent, // Gradient handles this
          foregroundColor: widget.foregroundColor ?? Colors.white,
          borderColor: Colors.transparent,
          showBorder: false,
          showShadow: true,
          isGlassy: false,
        );

      case KruiButtonVariant.glassy:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ??
              (isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.2)),
          foregroundColor: widget.foregroundColor ??
              (isDark ? Colors.white : const Color(0xFF1F2937)),
          borderColor: widget.borderColor ??
              (isDark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.white.withOpacity(0.3)),
          showBorder: true,
          showShadow: true,
          isGlassy: true,
        );

      case KruiButtonVariant.glowy:
        return _ButtonStyle(
          backgroundColor: widget.backgroundColor ??
              (isDark
                  ? const Color(0xFF8B5CF6) // Purple
                  : const Color(0xFF6366F1)), // Indigo
          foregroundColor: widget.foregroundColor ?? Colors.white,
          borderColor: Colors.transparent,
          showBorder: false,
          showShadow: true,
          isGlassy: false,
        );
    }
  }

  Widget _buildButtonContent(_ButtonStyle style) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    final contentColor =
        style.foregroundColor.withOpacity(isEnabled ? 1.0 : 0.5);

    // Loading state
    if (widget.isLoading) {
      return SizedBox(
        width: widget.iconSize,
        height: widget.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(contentColor),
        ),
      );
    }

    // Build content widgets
    final List<Widget> contentWidgets = [];

    // Add icon if provided
    if (widget.icon != null) {
      final iconWidget = Icon(
        widget.icon,
        size: widget.iconSize,
        color: contentColor,
      );

      if (widget.iconPosition == KruiButtonIconPosition.leading) {
        contentWidgets.add(iconWidget);
        if (widget.label != null || widget.child != null) {
          contentWidgets.add(const SizedBox(width: 8));
        }
      }
    }

    // Add label or child
    if (widget.child != null) {
      contentWidgets.add(
        DefaultTextStyle(
          style: (widget.textStyle ?? const TextStyle()).copyWith(
            color: contentColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          child: widget.child!,
        ),
      );
    } else if (widget.label != null) {
      contentWidgets.add(
        Text(
          widget.label!,
          style: (widget.textStyle ?? const TextStyle()).copyWith(
            color: contentColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      );
    }

    // Add trailing icon if needed
    if (widget.icon != null &&
        widget.iconPosition == KruiButtonIconPosition.trailing) {
      if (widget.label != null || widget.child != null) {
        contentWidgets.add(const SizedBox(width: 8));
      }
      contentWidgets.add(
        Icon(
          widget.icon,
          size: widget.iconSize,
          color: contentColor,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: contentWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = _getButtonStyle();
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    // Compute effective styling
    final effectiveBorderRadius = widget.borderRadius ??
        (widget.variant == KruiButtonVariant.link
            ? BorderRadius.circular(0)
            : BorderRadius.circular(14));

    final effectivePadding = widget.padding ??
        (widget.variant == KruiButtonVariant.link
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 12));

    // Compute hover/press states
    Color computedBgColor = style.backgroundColor;
    if (widget.variant == KruiButtonVariant.ghost && _isHovered && isEnabled) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      computedBgColor = isDark
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.05);
    } else if (widget.variant == KruiButtonVariant.outline &&
        _isHovered &&
        isEnabled) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      computedBgColor = isDark
          ? Colors.white.withOpacity(0.05)
          : Colors.black.withOpacity(0.02);
    }

    if (_isPressed && isEnabled) {
      computedBgColor = style.backgroundColor == Colors.transparent
          ? computedBgColor
          : HSLColor.fromColor(style.backgroundColor)
              .withLightness(
                (HSLColor.fromColor(style.backgroundColor).lightness - 0.1)
                    .clamp(0.0, 1.0),
              )
              .toColor();
    }

    // Build button decoration
    Widget buttonChild = AnimatedContainer(
      duration: widget.animationDuration,
      curve: Curves.easeOutCubic,
      padding: effectivePadding,
      constraints: BoxConstraints(
        minWidth: widget.minWidth ?? 0,
        minHeight: widget.minHeight ?? 0,
      ),
      decoration: BoxDecoration(
        color: widget.variant == KruiButtonVariant.gradient
            ? null
            : (isEnabled ? computedBgColor : computedBgColor.withOpacity(0.5)),
        gradient: widget.variant == KruiButtonVariant.gradient
            ? LinearGradient(
                colors: widget.gradientColors ??
                    [
                      const Color(0xFF6366F1), // Indigo
                      const Color(0xFF8B5CF6), // Purple
                      const Color(0xFFEC4899), // Pink
                    ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: effectiveBorderRadius,
        border: style.showBorder
            ? Border.all(
                color: isEnabled
                    ? style.borderColor
                    : style.borderColor.withOpacity(0.5),
                width: style.isGlassy ? 1.2 : 1.5,
              )
            : null,
        boxShadow: style.showShadow && isEnabled && !_isPressed
            ? [
                BoxShadow(
                  color: (widget.variant == KruiButtonVariant.gradient
                          ? const Color(0xFF8B5CF6)
                          : widget.variant == KruiButtonVariant.glassy
                              ? Colors.black.withOpacity(0.1)
                              : widget.variant == KruiButtonVariant.glowy
                                  ? style.backgroundColor
                                  : style.backgroundColor)
                      .withOpacity(widget.variant == KruiButtonVariant.glassy
                          ? 0.15
                          : widget.variant == KruiButtonVariant.glowy
                              ? 0.6 + (_gradientController.value * 0.2)
                              : 0.3 * widget.elevation / 2),
                  blurRadius: widget.variant == KruiButtonVariant.glassy
                      ? 20
                      : widget.variant == KruiButtonVariant.glowy
                          ? 25 + (_gradientController.value * 10)
                          : 8 + widget.elevation,
                  offset: Offset(
                      0,
                      widget.variant == KruiButtonVariant.glassy
                          ? 4
                          : widget.variant == KruiButtonVariant.glowy
                              ? 0
                              : 2 + widget.elevation / 2),
                  spreadRadius: widget.variant == KruiButtonVariant.glassy
                      ? 0
                      : widget.variant == KruiButtonVariant.glowy
                          ? 2
                          : -1,
                ),
                if (widget.variant == KruiButtonVariant.glassy)
                  BoxShadow(
                    color: Colors.white.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                if (widget.variant == KruiButtonVariant.glowy)
                  BoxShadow(
                    color: style.backgroundColor
                        .withOpacity(0.4 + (_gradientController.value * 0.2)),
                    blurRadius: 40 + (_gradientController.value * 15),
                    offset: const Offset(0, 0),
                    spreadRadius: -5,
                  ),
              ]
            : null,
      ),
      child: _buildButtonContent(style),
    );

    // Add link underline effect
    if (widget.variant == KruiButtonVariant.link) {
      buttonChild = ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buttonChild,
              AnimatedOpacity(
                duration: widget.animationDuration,
                opacity: _isHovered ? 1.0 : 0.0,
                child: Container(
                  height: 1,
                  color: style.foregroundColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Add scale animation
    buttonChild = AnimatedScale(
      scale: _isPressed && isEnabled ? 0.96 : 1.0,
      duration: widget.animationDuration,
      curve: Curves.easeOut,
      child: buttonChild,
    );

    // Wrap with gesture detection
    Widget result = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor:
          isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: isEnabled
            ? (_) {
                setState(() => _isPressed = false);
                _handleTap();
              }
            : null,
        onTapCancel:
            isEnabled ? () => setState(() => _isPressed = false) : null,
        child: buttonChild,
      ),
    );

    // Add ripple effect (Material ink ripple)
    if (widget.enableRipple && widget.variant != KruiButtonVariant.link) {
      result = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? _handleTap : null,
          borderRadius: effectiveBorderRadius,
          splashColor: style.foregroundColor.withOpacity(0.1),
          highlightColor: style.foregroundColor.withOpacity(0.05),
          child: IgnorePointer(
            child: result,
          ),
        ),
      );
    }

    // Add backdrop filter for glassy variant
    if (widget.variant == KruiButtonVariant.glassy) {
      result = ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: result,
        ),
      );
    }

    return result;
  }
}

// Helper class for button styling
class _ButtonStyle {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final bool showBorder;
  final bool showShadow;
  final bool isGlassy;

  const _ButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.showBorder,
    required this.showShadow,
    this.isGlassy = false,
  });
}
