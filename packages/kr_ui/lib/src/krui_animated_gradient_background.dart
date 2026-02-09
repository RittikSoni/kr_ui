import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animation direction for gradient
enum GradientAnimationDirection {
  /// Rotates the gradient alignment
  rotate,

  /// Slides color stops
  slide,

  /// Pulses with opacity
  pulse,
}

/// A container with smoothly animated gradient background.
///
/// Creates a mesmerizing gradient effect that continuously animates through
/// the provided colors. Perfect for hero sections, login screens, and premium
/// app backgrounds.
///
/// Example:
/// ```dart
/// KruiAnimatedGradientBackground(
///   colors: [
///     Color(0xFF667eea),
///     Color(0xFF764ba2),
///     Color(0xFFF093FB),
///   ],
///   duration: Duration(seconds: 5),
///   child: Center(child: Text('Beautiful!')),
/// )
/// ```
class KruiAnimatedGradientBackground extends StatefulWidget {
  /// List of colors to animate through
  final List<Color> colors;

  /// Duration of one complete animation cycle
  final Duration duration;

  /// Optional child widget to overlay on the gradient
  final Widget? child;

  /// Gradient begin alignment
  final Alignment begin;

  /// Gradient end alignment
  final Alignment end;

  /// Animation curve
  final Curve curve;

  /// Whether to reverse the animation (continuous loop)
  final bool reverse;

  /// Animation direction type
  final GradientAnimationDirection animationDirection;

  const KruiAnimatedGradientBackground({
    super.key,
    required this.colors,
    this.duration = const Duration(seconds: 4),
    this.child,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.curve = Curves.easeInOut,
    this.reverse = true,
    this.animationDirection = GradientAnimationDirection.slide,
  });

  @override
  State<KruiAnimatedGradientBackground> createState() =>
      _KruiAnimatedGradientBackgroundState();
}

class _KruiAnimatedGradientBackgroundState
    extends State<KruiAnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.reverse) {
      _controller.repeat(reverse: true);
    } else {
      _controller.repeat();
    }

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildGradient() {
    switch (widget.animationDirection) {
      case GradientAnimationDirection.rotate:
        return _buildRotatingGradient();
      case GradientAnimationDirection.slide:
        return _buildSlidingGradient();
      case GradientAnimationDirection.pulse:
        return _buildPulsingGradient();
    }
  }

  Widget _buildSlidingGradient() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Generate dynamic stops based on number of colors
        final stops = List<double>.generate(
          widget.colors.length,
          (index) {
            if (index == 0) return 0.0;
            if (index == widget.colors.length - 1) return 1.0;
            // Animate middle stops
            final baseStop = index / (widget.colors.length - 1);
            final offset = (_animation.value - 0.5) * 0.3;
            return (baseStop + offset).clamp(0.0, 1.0);
          },
        );

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: widget.begin,
              end: widget.end,
              colors: widget.colors,
              stops: stops,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }

  Widget _buildRotatingGradient() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Rotate alignment based on animation value
        final angle = _animation.value * 2 * math.pi; // Full rotation
        final begin = Alignment(
          widget.begin.x * math.cos(angle) - widget.begin.y * math.sin(angle),
          widget.begin.x * math.sin(angle) + widget.begin.y * math.cos(angle),
        );
        final end = Alignment(
          widget.end.x * math.cos(angle) - widget.end.y * math.sin(angle),
          widget.end.x * math.sin(angle) + widget.end.y * math.cos(angle),
        );

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: widget.colors,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }

  Widget _buildPulsingGradient() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Pulse opacity of gradient overlay
        final opacity = 0.7 + (_animation.value * 0.3); // Range: 0.7 to 1.0

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: widget.begin,
              end: widget.end,
              colors: widget.colors
                  .map((c) => c.withValues(alpha: opacity))
                  .toList(),
            ),
          ),
          child: widget.child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildGradient();
  }
}
