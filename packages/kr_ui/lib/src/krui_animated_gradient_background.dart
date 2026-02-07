import 'package:flutter/material.dart';

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

  const KruiAnimatedGradientBackground({
    super.key,
    required this.colors,
    this.duration = const Duration(seconds: 4),
    this.child,
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
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.colors,
              stops: stops,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
