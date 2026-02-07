import 'package:flutter/material.dart';

/// A premium button with pulsing glow effect and neon aesthetic.
///
/// Creates a button with multiple layered shadows that pulse to create a
/// mesmerizing glow effect. Perfect for premium CTAs, notifications, and
/// highlight actions.
///
/// Example:
/// ```dart
/// KruiGlowButton(
///   text: 'Get Started',
///   onTap: () => print('Tapped!'),
///   glowColor: Color(0xFF00F5FF),
///   isPulsing: true,
/// )
/// ```
class KruiGlowButton extends StatefulWidget {
  /// Text to display on the button
  final String text;

  /// Callback triggered when button is tapped
  final VoidCallback onTap;

  /// Color of the glow effect
  final Color glowColor;

  /// Color of the text
  final Color textColor;

  /// Button width
  final double width;

  /// Button height
  final double height;

  /// Whether the glow should pulse
  final bool isPulsing;

  const KruiGlowButton({
    super.key,
    required this.text,
    required this.onTap,
    this.glowColor = const Color(0xFF00F5FF),
    this.textColor = Colors.white,
    this.width = 200,
    this.height = 56,
    this.isPulsing = true,
  });

  @override
  State<KruiGlowButton> createState() => _KruiGlowButtonState();
}

class _KruiGlowButtonState extends State<KruiGlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isPulsing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.height / 2),
              gradient: LinearGradient(
                colors: [
                  widget.glowColor,
                  widget.glowColor.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      widget.glowColor.withOpacity(0.6 * _glowAnimation.value),
                  blurRadius: 30 * _glowAnimation.value,
                  spreadRadius: 5 * _glowAnimation.value,
                ),
                BoxShadow(
                  color:
                      widget.glowColor.withOpacity(0.3 * _glowAnimation.value),
                  blurRadius: 60 * _glowAnimation.value,
                  spreadRadius: 10 * _glowAnimation.value,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: widget.glowColor.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
