import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'krui_glassy_button.dart';

/// A beautiful glassmorphic (liquid glass) icon button with frosted blur and haptics.
///
/// Use for icon-only actions with the same premium glass style as [KruiGlassyButton].
///
/// ## Basic Usage
///
/// ```dart
/// KruiGlassyIconButton(
///   onPressed: () => print('Tapped'),
///   icon: Icons.favorite_border,
/// )
/// ```
///
/// ## With tooltip and size
///
/// ```dart
/// KruiGlassyIconButton(
///   onPressed: () {},
///   icon: Icons.settings,
///   iconSize: 22,
///   tooltip: 'Settings',
///   blur: 12,
///   opacity: 0.2,
/// )
/// ```
class KruiGlassyIconButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double? iconSize;
  final Color? iconColor;
  final String? tooltip;
  final double blur;
  final double opacity;
  final double pressedOpacity;
  final Color color;
  final BorderRadius? borderRadius;
  final Border? border;
  final double size;
  final bool enableHaptics;
  final HapticType hapticType;
  final Color? shadowColor;
  final double shadowBlur;
  final bool enableShadow;
  final Duration animationDuration;

  const KruiGlassyIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    this.iconColor,
    this.tooltip,
    this.blur = 10,
    this.opacity = 0.15,
    this.pressedOpacity = 0.25,
    this.color = Colors.white,
    this.borderRadius,
    this.border,
    this.size = 48,
    this.enableHaptics = true,
    this.hapticType = HapticType.light,
    this.shadowColor,
    this.shadowBlur = 12,
    this.enableShadow = true,
    this.animationDuration = const Duration(milliseconds: 150),
  })  : assert(blur >= 0 && blur <= 30, 'Blur must be between 0 and 30'),
        assert(opacity >= 0 && opacity <= 1, 'Opacity must be between 0 and 1'),
        assert(pressedOpacity >= 0 && pressedOpacity <= 1,
            'Pressed opacity must be between 0 and 1');

  @override
  State<KruiGlassyIconButton> createState() => _KruiGlassyIconButtonState();
}

class _KruiGlassyIconButtonState extends State<KruiGlassyIconButton> {
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

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(12);
    final effectiveIconSize = widget.iconSize ?? 24;
    final effectiveIconColor = widget.iconColor ??
        (widget.onPressed == null
            ? Colors.grey.withValues(alpha: 0.5)
            : Colors.black.withValues(alpha: 0.85));
    final effectiveShadowColor =
        widget.shadowColor ?? Colors.black.withValues(alpha: 0.1);
    final currentOpacity = _isPressed ? widget.pressedOpacity : widget.opacity;

    Widget button = GestureDetector(
      onTapDown: widget.onPressed != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              setState(() => _isPressed = false);
              _triggerHaptic();
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: widget.onPressed != null
          ? () => setState(() => _isPressed = false)
          : null,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: Curves.easeOut,
        width: widget.size,
        height: widget.size,
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
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: currentOpacity),
                borderRadius: effectiveBorderRadius,
                border: widget.border ??
                    Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
              ),
              child: Icon(
                widget.icon,
                size: effectiveIconSize,
                color: effectiveIconColor,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null && widget.tooltip!.isNotEmpty) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }
    return button;
  }
}
