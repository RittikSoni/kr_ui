import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A premium minimalist icon button without glass effects.
///
/// Clean solid or tinted background with haptics and scale animation,
/// matching [KruiSimpleButton] style.
///
/// ## Basic Usage
///
/// ```dart
/// KruiSimpleIconButton(
///   onPressed: () => print('Tapped'),
///   icon: Icons.add,
/// )
/// ```
///
/// ## With tooltip and custom color
///
/// ```dart
/// KruiSimpleIconButton(
///   onPressed: () {},
///   icon: Icons.settings,
///   iconSize: 22,
///   tooltip: 'Settings',
///   color: Colors.blue,
///   iconColor: Colors.white,
/// )
/// ```
class KruiSimpleIconButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double? iconSize;
  final Color? iconColor;
  final String? tooltip;
  final Color color;
  final BorderRadius? borderRadius;
  final double size;
  final bool enableHaptics;
  final Duration animationDuration;

  const KruiSimpleIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    this.iconColor,
    this.tooltip,
    this.color = Colors.black,
    this.borderRadius,
    this.size = 48,
    this.enableHaptics = true,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  State<KruiSimpleIconButton> createState() => _KruiSimpleIconButtonState();
}

class _KruiSimpleIconButtonState extends State<KruiSimpleIconButton> {
  bool _isPressed = false;

  void _triggerHaptic() {
    if (widget.enableHaptics && widget.onPressed != null) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(14);
    final effectiveIconSize = widget.iconSize ?? 24;
    final isEnabled = widget.onPressed != null;
    final effectiveIconColor = widget.iconColor ??
        (isEnabled ? Colors.white : Colors.white.withValues(alpha: 0.5));

    Widget button = GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _triggerHaptic();
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: widget.animationDuration,
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: widget.animationDuration,
          curve: Curves.easeOut,
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isEnabled
                ? (_isPressed
                    ? widget.color.withValues(alpha: 0.85)
                    : widget.color)
                : widget.color.withValues(alpha: 0.35),
            borderRadius: effectiveBorderRadius,
            boxShadow: [
              if (isEnabled && !_isPressed)
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: Icon(
            widget.icon,
            size: effectiveIconSize,
            color: effectiveIconColor,
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
