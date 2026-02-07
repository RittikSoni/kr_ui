import 'package:flutter/material.dart';

/// An advanced skeleton shimmer loader with wave effects and customizable shapes.
///
/// Creates animated shimmer placeholders for loading states. More advanced than
/// basic skeleton loaders with gradient wave animation, multiple directions, and
/// pre-built shape components.
///
/// Perfect for: Content loading, list placeholders, card grids, lazy loading
///
/// Example:
/// ```dart
/// KruiSkeletonShimmer(
///   child: Column(
///     children: [
///       SkeletonLine(width: 200),
///       SkeletonLine(width: 150),
///       SkeletonCircle(size: 60),
///     ],
///   ),
/// )
/// ```
class KruiSkeletonShimmer extends StatefulWidget {
  /// Child widget containing skeleton shapes
  final Widget child;

  /// Base color of skeleton
  final Color baseColor;

  /// Highlight color of shimmer wave
  final Color highlightColor;

  /// Animation duration for one complete wave
  final Duration duration;

  /// Wave direction
  final ShimmerDirection direction;

  /// Enable shimmer animation
  final bool enabled;

  const KruiSkeletonShimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.duration = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.leftToRight,
    this.enabled = true,
  });

  @override
  State<KruiSkeletonShimmer> createState() => _KruiSkeletonShimmerState();
}

class _KruiSkeletonShimmerState extends State<KruiSkeletonShimmer>
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

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(KruiSkeletonShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return _createShimmerGradient(bounds).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }

  LinearGradient _createShimmerGradient(Rect bounds) {
    final double position = _animation.value;

    // Calculate gradient positions based on direction
    Alignment begin, end;
    switch (widget.direction) {
      case ShimmerDirection.leftToRight:
        begin = Alignment(position - 1, 0);
        end = Alignment(position, 0);
        break;
      case ShimmerDirection.rightToLeft:
        begin = Alignment(-position, 0);
        end = Alignment(-position + 1, 0);
        break;
      case ShimmerDirection.topToBottom:
        begin = Alignment(0, position - 1);
        end = Alignment(0, position);
        break;
      case ShimmerDirection.bottomToTop:
        begin = Alignment(0, -position);
        end = Alignment(0, -position + 1);
        break;
    }

    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        widget.baseColor,
        widget.highlightColor,
        widget.baseColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }
}

/// Pre-built skeleton line shape
class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? color;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFE0E0E0),
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }
}

/// Pre-built skeleton circle shape
class SkeletonCircle extends StatelessWidget {
  final double size;
  final Color? color;

  const SkeletonCircle({
    super.key,
    this.size = 48,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFE0E0E0),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Pre-built skeleton rectangle shape
class SkeletonRectangle extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? color;

  const SkeletonRectangle({
    super.key,
    this.width = 100,
    this.height = 100,
    this.borderRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFE0E0E0),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

/// Pre-built skeleton card shape
class SkeletonCard extends StatelessWidget {
  final double? width;
  final double height;
  final Color? color;

  const SkeletonCard({
    super.key,
    this.width,
    this.height = 200,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLine(width: (width ?? 300) * 0.7, height: 20),
          const SizedBox(height: 12),
          const SkeletonLine(height: 14),
          const SizedBox(height: 8),
          SkeletonLine(width: (width ?? 300) * 0.5, height: 14),
          const Spacer(),
          Row(
            children: [
              const SkeletonCircle(size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: (width ?? 300) * 0.4, height: 12),
                    const SizedBox(height: 4),
                    SkeletonLine(width: (width ?? 300) * 0.3, height: 10),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shimmer wave direction
enum ShimmerDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}
