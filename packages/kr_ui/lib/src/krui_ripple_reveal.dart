import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A widget that reveals/hides content with a circular ripple animation from tap point.
///
/// Creates a unique interaction where tapping reveals or hides child content
/// with an expanding/contracting circle that originates from the exact tap position.
///
/// Perfect for: Image galleries, tutorial overlays, progressive disclosure, password reveal
///
/// Example:
/// ```dart
/// KruiRippleReveal(
///   revealChild: Image.network('https://example.com/image.jpg'),
///   hiddenChild: Container(color: Colors.grey),
///   onTap: (revealed) => print('Revealed: $revealed'),
/// )
/// ```
class KruiRippleReveal extends StatefulWidget {
  /// Widget to show when revealed
  final Widget revealChild;

  /// Widget to show when hidden (optional)
  final Widget? hiddenChild;

  /// Initial reveal state
  final bool initiallyRevealed;

  /// Animation duration
  final Duration duration;

  /// Callback when reveal state changes
  final ValueChanged<bool>? onTap;

  /// Ripple color overlay
  final Color? rippleColor;

  /// Enable reverse animation (can re-hide)
  final bool allowReverse;

  /// Custom ripple curve
  final Curve curve;

  /// Optional width for the widget (null = expand to parent constraints)
  final double? width;

  /// Optional height for the widget (null = expand to parent constraints)
  final double? height;

  /// Optional controller for programmatic reveal/hide
  final KruiRippleRevealController? controller;

  const KruiRippleReveal({
    super.key,
    required this.revealChild,
    this.hiddenChild,
    this.initiallyRevealed = false,
    this.duration = const Duration(milliseconds: 600),
    this.onTap,
    this.rippleColor,
    this.allowReverse = true,
    this.curve = Curves.easeInOut,
    this.width,
    this.height,
    this.controller,
  });

  @override
  State<KruiRippleReveal> createState() => _KruiRippleRevealState();
}

class _KruiRippleRevealState extends State<KruiRippleReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isRevealed = false;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _isRevealed = widget.initiallyRevealed;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (_isRevealed) {
      _controller.value = 1.0;
    }

    // Connect to external controller if provided
    widget.controller?._attach(this);
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;

      if (_isRevealed && widget.allowReverse) {
        _isRevealed = false;
        _controller.reverse();
      } else if (!_isRevealed) {
        _isRevealed = true;
        _controller.forward();
      }

      widget.onTap?.call(_isRevealed);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget stack = GestureDetector(
      onTapDown: _handleTap,
      child: Stack(
        children: [
          // Base revealed widget (always visible)
          Positioned.fill(child: widget.revealChild),
          // Clipped hidden widget on top (clips away as progress increases)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ClipPath(
                clipper: _RippleClipper(
                  progress: 1.0 - _animation.value, // Invert progress
                  tapPosition: _tapPosition,
                ),
                child: Stack(
                  children: [
                    // Hidden widget
                    Positioned.fill(
                      child: widget.hiddenChild ??
                          Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(Icons.touch_app, size: 48),
                            ),
                          ),
                    ),
                    // Optional ripple color overlay
                    if (widget.rippleColor != null)
                      Positioned.fill(
                        child: Container(
                          color: widget.rippleColor!
                              .withValues(alpha: _animation.value * 0.3),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    // If width or height is specified, wrap in SizedBox
    if (widget.width != null || widget.height != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: stack,
      );
    }

    return stack;
  }

  /// Programmatically reveal the content
  void reveal({Offset? fromPosition}) {
    setState(() {
      _tapPosition = fromPosition;
      _isRevealed = true;
    });
    _controller.forward();
    widget.onTap?.call(true);
  }

  /// Programmatically hide the content
  void hide({Offset? fromPosition}) {
    if (widget.allowReverse) {
      setState(() {
        _tapPosition = fromPosition;
        _isRevealed = false;
      });
      _controller.reverse();
      widget.onTap?.call(false);
    }
  }
}

/// Controller for programmatically controlling KruiRippleReveal
class KruiRippleRevealController {
  _KruiRippleRevealState? _state;

  void _attach(_KruiRippleRevealState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  /// Reveal the content with optional starting position
  void reveal({Offset? fromPosition}) {
    _state?.reveal(fromPosition: fromPosition);
  }

  /// Hide the content with optional starting position
  void hide({Offset? fromPosition}) {
    _state?.hide(fromPosition: fromPosition);
  }

  /// Check if content is currently revealed
  bool get isRevealed => _state?._isRevealed ?? false;
}

/// Custom clipper that creates circular reveal from tap point
class _RippleClipper extends CustomClipper<Path> {
  final double progress;
  final Offset? tapPosition;

  _RippleClipper({
    required this.progress,
    required this.tapPosition,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    if (progress == 0.0) {
      // Fully clipped (nothing visible)
      return path;
    }

    // Default to center if no tap position
    final center = tapPosition ?? Offset(size.width / 2, size.height / 2);

    // Calculate maximum radius needed to cover entire widget from tap point
    final maxRadius = _calculateMaxRadius(size, center);

    // Current radius based on progress
    final currentRadius = maxRadius * progress;

    // Create circular clip
    path.addOval(Rect.fromCircle(
      center: center,
      radius: currentRadius,
    ));

    return path;
  }

  @override
  bool shouldReclip(_RippleClipper oldClipper) {
    return oldClipper.progress != progress ||
        oldClipper.tapPosition != tapPosition;
  }

  /// Calculate the maximum radius needed to cover the entire widget
  double _calculateMaxRadius(Size size, Offset center) {
    // Calculate distance to each corner
    final distanceToTopLeft = _distance(center, const Offset(0, 0));
    final distanceToTopRight = _distance(center, Offset(size.width, 0));
    final distanceToBottomLeft = _distance(center, Offset(0, size.height));
    final distanceToBottomRight =
        _distance(center, Offset(size.width, size.height));

    // Return the maximum distance
    return math.max(
      math.max(distanceToTopLeft, distanceToTopRight),
      math.max(distanceToBottomLeft, distanceToBottomRight),
    );
  }

  double _distance(Offset a, Offset b) {
    return math.sqrt(
      math.pow(a.dx - b.dx, 2) + math.pow(a.dy - b.dy, 2),
    );
  }
}
