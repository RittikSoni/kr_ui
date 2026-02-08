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

  /// Custom drag handle size (defaults to button height)
  final double? dragHandleSize;

  /// Custom drag handle color (defaults to white)
  final Color? dragHandleColor;

  /// Custom background gradient colors (overrides primaryColor and accentColor for background)
  final List<Color>? backgroundGradientColors;

  /// Gradient begin alignment
  final Alignment gradientBegin;

  /// Gradient end alignment
  final Alignment gradientEnd;

  /// Animation duration for fill effect (milliseconds)
  final int fillAnimationDuration;

  /// Animation duration for reset (milliseconds)
  final int resetAnimationDuration;

  /// Minimum drag distance in pixels before slider moves
  final double minDragDistance;

  /// Enable haptic-like visual feedback on drag
  final bool enableHapticFeedback;

  /// Custom completion animation curve
  final Curve completionCurve;

  /// Custom reset animation curve
  final Curve resetCurve;

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
    this.dragHandleSize,
    this.dragHandleColor,
    this.backgroundGradientColors,
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
    this.fillAnimationDuration = 200,
    this.resetAnimationDuration = 300,
    this.minDragDistance = 5.0,
    this.enableHapticFeedback = true,
    this.completionCurve = Curves.easeOut,
    this.resetCurve = Curves.easeInOut,
  })  : assert(completionThreshold > 0 && completionThreshold <= 1.0,
            'completionThreshold must be between 0 and 1'),
        assert(fillOpacity >= 0 && fillOpacity <= 1.0,
            'fillOpacity must be between 0 and 1'),
        assert(minDragDistance >= 0, 'minDragDistance must be non-negative'),
        assert(fillAnimationDuration > 0,
            'fillAnimationDuration must be positive'),
        assert(resetAnimationDuration > 0,
            'resetAnimationDuration must be positive');

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
  double _dragStartX = 0.0;
  bool _hasCompletedThisGesture = false;

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
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
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

  void _onHorizontalDragStart(DragStartDetails details) {
    if (!_isCompleted && !_hasCompletedThisGesture) {
      setState(() {
        _isDragging = true;
        _dragStartX = details.localPosition.dx;
      });
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    // Guard against updates during completion animation
    if (_isCompleted || _hasCompletedThisGesture) return;

    // Calculate progress from the drag start position
    final dragDistance = details.localPosition.dx - _dragStartX;

    // Only update if dragging to the right and minimum threshold met
    if (dragDistance < widget.minDragDistance) return;

    final progress = (details.localPosition.dx / widget.width).clamp(0.0, 1.0);
    _controller.value = progress;

    // Trigger completion only once per gesture
    if (progress >= widget.completionThreshold && !_hasCompletedThisGesture) {
      setState(() {
        _isCompleted = true;
        _hasCompletedThisGesture = true;
      });

      _controller
          .animateTo(
        1.0,
        duration: Duration(milliseconds: widget.fillAnimationDuration),
        curve: widget.completionCurve,
      )
          .then((_) {
        widget.onComplete();
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            setState(() {
              _isCompleted = false;
              _isDragging = false;
            });
            _controller.animateBack(
              0.0,
              duration: Duration(milliseconds: widget.resetAnimationDuration),
              curve: widget.resetCurve,
            );
            _bounceController.forward(from: 0);
          }
        });
      });
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (!_isCompleted && _controller.value > 0) {
      _controller.animateBack(
        0.0,
        duration: Duration(milliseconds: widget.resetAnimationDuration),
        curve: widget.resetCurve,
      );
      _bounceController.forward(from: 0);
    }

    setState(() {
      _isDragging = false;
      _hasCompletedThisGesture = false;
    });
  }

  String _getDisplayText() {
    // Removed codepoint logic as we now use an Icon widget
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
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius:
              widget.borderRadius ?? BorderRadius.circular(widget.height / 2),
          gradient: LinearGradient(
            colors: widget.backgroundGradientColors ??
                [widget.primaryColor, widget.accentColor],
            begin: widget.gradientBegin,
            end: widget.gradientEnd,
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
              color: widget.primaryColor.withValues(alpha: 0.3),
              blurRadius: widget.shadowBlurRadius * 0.8,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: widget.primaryColor.withValues(alpha: 0.2),
              blurRadius: widget.shadowBlurRadius * 0.4,
              offset: const Offset(0, 4),
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
            // Dynamic text/icon with smooth transitions
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_fillAnimation, _bounceAnimation]),
                builder: (context, child) {
                  final displayText = _getDisplayText();
                  final isComplete =
                      _fillAnimation.value >= widget.completionThreshold;

                  return Transform.scale(
                    scale: 1.0 + (_bounceAnimation.value * 0.1),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        );
                      },
                      child: isComplete
                          ? Icon(
                              widget.completionIcon,
                              key: const ValueKey('completion_icon'),
                              color: widget.completionTextStyle?.color ??
                                  Colors.white,
                              size: widget.completionTextStyle?.fontSize ?? 32,
                            )
                          : AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: widget.textStyle ??
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                              child: Text(
                                displayText,
                                key: ValueKey('text_$displayText'),
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),

            // Drag handle without rotation
            AnimatedBuilder(
              animation: Listenable.merge(
                  [_fillAnimation, _pulseAnimation, _bounceAnimation]),
              builder: (context, child) {
                final scale = (_isDragging && widget.enablePulse)
                    ? _pulseAnimation.value
                    : 1.0;

                final handleSize = widget.dragHandleSize ?? widget.height;
                final handleColor = widget.dragHandleColor ?? Colors.white;

                return Positioned(
                  left: (widget.width - handleSize) * _fillAnimation.value,
                  child: Transform.scale(
                    scale: scale *
                        (1.0 +
                            _bounceAnimation.value *
                                (widget.enableHapticFeedback ? 0.15 : 0.05)),
                    child: Container(
                      width: handleSize,
                      height: handleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: handleColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            spreadRadius: -2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        color: _getProgressColor(),
                        size: 20,
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
