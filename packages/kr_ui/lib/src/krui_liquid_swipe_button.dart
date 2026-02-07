import 'package:flutter/material.dart';

/// A swipeable button with liquid-like fill effect on horizontal drag.
///
/// Users drag the button from left to right to confirm an action. The button
/// fills with a translucent overlay as the user drags, and triggers the callback
/// when dragged beyond 95% of its width.
///
/// Perfect for: CTAs, confirm actions, premium interactions
///
/// Example:
/// ```dart
/// KruiLiquidSwipeButton(
///   text: 'Swipe to Confirm',
///   onComplete: () => print('Action confirmed!'),
///   primaryColor: Color(0xFF6C63FF),
///   accentColor: Color(0xFF4ECDC4),
/// )
/// ```
class KruiLiquidSwipeButton extends StatefulWidget {
  /// The text to display on the button
  final String text;

  /// Callback triggered when the swipe is completed (95% threshold)
  final VoidCallback onComplete;

  /// Primary gradient color
  final Color primaryColor;

  /// Accent gradient color
  final Color accentColor;

  /// Button height
  final double height;

  /// Button width
  final double width;

  /// Text displayed when user is actively dragging
  final String? swipingText;

  /// Text displayed when almost complete (past 80%)
  final String? almostCompleteText;

  /// Completion threshold (0.0 to 1.0). Default is 0.95 (95%)
  final double completionThreshold;

  /// Icon to display in the drag handle
  final IconData icon;

  /// Icon displayed when completed
  final IconData completionIcon;

  /// Enable shimmer effect during drag
  final bool enableShimmer;

  /// Enable pulsing animation on drag handle
  final bool enablePulse;

  /// Enable progress dots indicator
  final bool enableProgressDots;

  /// Custom text style for the button text
  final TextStyle? textStyle;

  /// Custom text style for the completion icon
  final TextStyle? completionTextStyle;

  /// Border width (0 for no border)
  final double borderWidth;

  /// Border color
  final Color? borderColor;

  /// Fill overlay opacity (0.0 to 1.0)
  final double fillOpacity;

  /// Shadow blur radius
  final double shadowBlurRadius;

  /// Custom border radius (null uses pill shape)
  final BorderRadius? borderRadius;

  const KruiLiquidSwipeButton({
    super.key,
    required this.text,
    required this.onComplete,
    this.primaryColor = const Color(0xFF6C63FF),
    this.accentColor = const Color(0xFF4ECDC4),
    this.height = 60,
    this.width = 280,
    this.swipingText,
    this.almostCompleteText,
    this.completionThreshold = 0.95,
    this.icon = Icons.arrow_forward_ios,
    this.completionIcon = Icons.check,
    this.enableShimmer = true,
    this.enablePulse = true,
    this.enableProgressDots = true,
    this.textStyle,
    this.completionTextStyle,
    this.borderWidth = 0,
    this.borderColor,
    this.fillOpacity = 0.3,
    this.shadowBlurRadius = 20,
    this.borderRadius,
  })  : assert(completionThreshold > 0 && completionThreshold <= 1.0,
            'completionThreshold must be between 0 and 1'),
        assert(fillOpacity >= 0 && fillOpacity <= 1.0,
            'fillOpacity must be between 0 and 1');

  @override
  State<KruiLiquidSwipeButton> createState() => _KruiLiquidSwipeButtonState();
}

class _KruiLiquidSwipeButtonState extends State<KruiLiquidSwipeButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _fillAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;
  bool _isCompleted = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fillAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bounceAnimation = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) {
      setState(() => _isDragging = true);
    }

    final progress = (details.localPosition.dx / widget.width).clamp(0.0, 1.0);
    _controller.value = progress;

    if (progress >= widget.completionThreshold && !_isCompleted) {
      _isCompleted = true;
      _controller.forward().then((_) {
        widget.onComplete();
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _isCompleted = false;
              _isDragging = false;
            });
            _controller.reverse();
            _bounceController.forward(from: 0);
          }
        });
      });
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() => _isDragging = false);
    if (!_isCompleted && _controller.value > 0) {
      _controller.reverse();
      _bounceController.forward(from: 0);
    }
  }

  String _getDisplayText() {
    if (_fillAnimation.value >= widget.completionThreshold) {
      return String.fromCharCode(widget.completionIcon.codePoint);
    }
    if (_fillAnimation.value > 0.8 && _isDragging) {
      return widget.almostCompleteText ?? 'Release!';
    }
    if (_isDragging && _fillAnimation.value > 0.2) {
      return widget.swipingText ?? 'Keep going...';
    }
    return widget.text;
  }

  Color _getProgressColor() {
    if (_fillAnimation.value > 0.8) {
      return Color.lerp(widget.accentColor, Colors.green,
              (_fillAnimation.value - 0.8) / 0.2) ??
          widget.accentColor;
    }
    return Color.lerp(
            widget.primaryColor, widget.accentColor, _fillAnimation.value) ??
        widget.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius:
              widget.borderRadius ?? BorderRadius.circular(widget.height / 2),
          gradient: LinearGradient(
            colors: [widget.primaryColor, widget.accentColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: widget.borderWidth > 0
              ? Border.all(
                  color:
                      widget.borderColor ?? Colors.white.withValues(alpha: 0.3),
                  width: widget.borderWidth,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: widget.primaryColor.withValues(alpha: 0.4),
              blurRadius: widget.shadowBlurRadius,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Animated fill indicator with shimmer
            AnimatedBuilder(
              animation: _fillAnimation,
              builder: (context, child) {
                return Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: widget.width * _fillAnimation.value,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: widget.borderRadius ??
                              BorderRadius.circular(widget.height / 2),
                          color: Colors.white
                              .withValues(alpha: widget.fillOpacity),
                        ),
                      ),
                      // Shimmer effect
                      if (_isDragging && widget.enableShimmer)
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Positioned(
                              right: -50,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withValues(alpha: 0),
                                      Colors.white.withValues(
                                          alpha: 0.3 * _pulseAnimation.value),
                                      Colors.white.withValues(alpha: 0),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            ),

            // Dynamic text with smooth transitions
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_fillAnimation, _bounceAnimation]),
                builder: (context, child) {
                  final displayText = _getDisplayText();
                  final isComplete =
                      _fillAnimation.value >= widget.completionThreshold;

                  final defaultStyle = TextStyle(
                    color: Colors.white,
                    fontSize: isComplete ? 32 : 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: isComplete ? 0 : 1.2,
                  );

                  final effectiveStyle = isComplete
                      ? (widget.completionTextStyle ?? defaultStyle)
                      : (widget.textStyle ?? defaultStyle);

                  return Transform.scale(
                    scale: 1.0 + (_bounceAnimation.value * 0.1),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: effectiveStyle,
                      child: Text(displayText),
                    ),
                  );
                },
              ),
            ),

            // Drag handle with rotation
            AnimatedBuilder(
              animation: Listenable.merge(
                  [_fillAnimation, _pulseAnimation, _bounceAnimation]),
              builder: (context, child) {
                final rotation =
                    _fillAnimation.value * 0.5; // Rotate up to 90 degrees
                final scale = (_isDragging && widget.enablePulse)
                    ? _pulseAnimation.value
                    : 1.0;

                return Positioned(
                  left: (widget.width - widget.height) * _fillAnimation.value,
                  child: Transform.scale(
                    scale: scale * (1.0 + _bounceAnimation.value * 0.2),
                    child: Container(
                      width: widget.height,
                      height: widget.height,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Transform.rotate(
                        angle: rotation * 3.14159, // Convert to radians
                        child: Icon(
                          widget.icon,
                          color: _getProgressColor(),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Progress dots indicator
            if (_isDragging && widget.enableProgressDots)
              AnimatedBuilder(
                animation: _fillAnimation,
                builder: (context, child) {
                  return Positioned(
                    left: 10,
                    right: 10,
                    bottom: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final dotProgress =
                            (_fillAnimation.value * 3 - index).clamp(0.0, 1.0);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                                .withValues(alpha: 0.3 + (dotProgress * 0.7)),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
