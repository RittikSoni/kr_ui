import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A premium minimalist button without glass effects.
/// Focuses on clean aesthetics, haptics, and smooth state transitions.
class KruiSimpleButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color color;
  final Color textColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final bool enableHaptics;
  final bool isLoading;
  final Duration animationDuration;

  const KruiSimpleButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.borderRadius,
    this.padding,
    this.enableHaptics = true,
    this.isLoading = false,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  State<KruiSimpleButton> createState() => _KruiSimpleButtonState();
}

class _KruiSimpleButtonState extends State<KruiSimpleButton> {
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
    final effectivePadding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    final isEnabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _triggerHaptic();
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: widget.animationDuration,
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: widget.animationDuration,
          curve: Curves.easeOut,
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: isEnabled
                ? (_isPressed
                    ? widget.color.withValues(alpha: 0.8)
                    : widget.color)
                : widget.color.withValues(alpha: 0.3),
            borderRadius: effectiveBorderRadius,
            boxShadow: [
              if (isEnabled && !_isPressed)
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: widget.textColor.withValues(alpha: isEnabled ? 1.0 : 0.5),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            child: AnimatedSwitcher(
              duration: widget.animationDuration,
              child: widget.isLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.textColor
                              .withValues(alpha: isEnabled ? 1.0 : 0.5),
                        ),
                      ),
                    )
                  : widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
