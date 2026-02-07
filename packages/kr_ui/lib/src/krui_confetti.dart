import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A realistic confetti explosion with physics simulation.
///
/// Creates multiple confetti pieces with gravity, rotation, and air resistance.
/// More advanced than simple particle burst with realistic physics and multiple shapes.
///
/// Perfect for: Achievements, purchases, level complete, celebrations, gamification
///
/// Example:
/// ```dart
/// Stack(
///   children: [
///     YourContent(),
///     if (showConfetti)
///       KruiConfetti(
///         onComplete: () => setState(() => showConfetti = false),
///       ),
///   ],
/// )
/// ```
class KruiConfetti extends StatefulWidget {
  /// Number of confetti pieces
  final int particleCount;

  /// List of colors for confetti (random selection)
  final List<Color>? colors;

  /// Explosion force (higher = faster initial velocity)
  final double explosionForce;

  /// Gravity strength
  final double gravity;

  /// Animation duration
  final Duration duration;

  /// Callback when animation completes
  final VoidCallback? onComplete;

  /// Emission point (center if null)
  final Offset? emissionPoint;

  /// Include different shapes
  final bool useMultipleShapes;

  /// Size range for confetti pieces
  final double minSize;
  final double maxSize;

  /// Spread angle in radians (2*pi = 360 degrees)
  final double spreadAngle;

  /// Wind effect (horizontal drift)
  final double wind;

  /// Enable metallic shimmer effect
  final bool enableMetallic;

  /// Rotation variation (0 = no rotation, 1 = full random)
  final double rotationVariation;

  /// Preset position for confetti emission
  final ConfettiPosition? position;

  const KruiConfetti({
    super.key,
    this.particleCount = 50,
    this.colors,
    this.explosionForce = 400,
    this.gravity = 500,
    this.duration = const Duration(seconds: 3),
    this.onComplete,
    this.emissionPoint,
    this.useMultipleShapes = true,
    this.minSize = 8,
    this.maxSize = 16,
    this.spreadAngle = 2 * 3.14159, // Full 360 degrees
    this.wind = 0,
    this.enableMetallic = false,
    this.rotationVariation = 1.0,
    this.position,
  });

  @override
  State<KruiConfetti> createState() => _KruiConfettiState();
}

class _KruiConfettiState extends State<KruiConfetti>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<ConfettiParticle> _particles;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _initializeParticles();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
        }
      });

    _controller.forward();
  }

  void _initializeParticles() {
    _particles = List.generate(widget.particleCount, (index) {
      // Random angle for explosion (within spread angle)
      final centerAngle = -3.14159 / 2; // Upward
      final angle = centerAngle +
          (-widget.spreadAngle / 2) +
          (_random.nextDouble() * widget.spreadAngle);

      // Random velocity
      final speed = widget.explosionForce *
          (0.5 + _random.nextDouble() * 0.5); // 50-100% of max force

      final velocityX = math.cos(angle) * speed;
      final velocityY = math.sin(angle) * speed - 100; // Initial upward bias

      // Random color
      final colors = widget.colors ??
          [
            Colors.red,
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.purple,
            Colors.orange,
            Colors.pink,
            Colors.cyan,
          ];
      final color = colors[_random.nextInt(colors.length)];

      // Random shape
      final shape = widget.useMultipleShapes
          ? ConfettiShape.values[_random.nextInt(ConfettiShape.values.length)]
          : ConfettiShape.rectangle;

      // Random size
      final size = widget.minSize +
          _random.nextDouble() * (widget.maxSize - widget.minSize);

      // Random rotation speed (with variation control)
      final rotationSpeed = widget.rotationVariation > 0
          ? (-2 + _random.nextDouble() * 4) * widget.rotationVariation
          : 0;

      return ConfettiParticle(
        initialX: 0,
        initialY: 0,
        velocityX: velocityX,
        velocityY: velocityY,
        color: color,
        shape: shape,
        size: size,
        rotationSpeed: rotationSpeed.toDouble(),
        isMetallic: widget.enableMetallic,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate emission point based on position or custom offset
        Offset emissionPoint;
        if (widget.position != null) {
          emissionPoint = _getPositionOffset(widget.position!, constraints);
        } else {
          emissionPoint = widget.emissionPoint ??
              Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _ConfettiPainter(
                particles: _particles,
                progress: _controller.value,
                gravity: widget.gravity,
                emissionPoint: emissionPoint,
                wind: widget.wind,
              ),
            );
          },
        );
      },
    );
  }

  Offset _getPositionOffset(
      ConfettiPosition position, BoxConstraints constraints) {
    switch (position) {
      case ConfettiPosition.topLeft:
        return Offset(constraints.maxWidth * 0.1, constraints.maxHeight * 0.1);
      case ConfettiPosition.topCenter:
        return Offset(constraints.maxWidth * 0.5, 0);
      case ConfettiPosition.topRight:
        return Offset(constraints.maxWidth * 0.9, constraints.maxHeight * 0.1);
      case ConfettiPosition.center:
        return Offset(constraints.maxWidth * 0.5, constraints.maxHeight * 0.5);
      case ConfettiPosition.bottomLeft:
        return Offset(constraints.maxWidth * 0.1, constraints.maxHeight * 0.9);
      case ConfettiPosition.bottomCenter:
        return Offset(constraints.maxWidth * 0.5, constraints.maxHeight);
      case ConfettiPosition.bottomRight:
        return Offset(constraints.maxWidth * 0.9, constraints.maxHeight * 0.9);
    }
  }
}

/// Represents a single confetti particle
class ConfettiParticle {
  final double initialX;
  final double initialY;
  final double velocityX;
  final double velocityY;
  final Color color;
  final ConfettiShape shape;
  final double size;
  final double rotationSpeed;
  final bool isMetallic;

  ConfettiParticle({
    required this.initialX,
    required this.initialY,
    required this.velocityX,
    required this.velocityY,
    required this.color,
    required this.shape,
    required this.size,
    required this.rotationSpeed,
    this.isMetallic = false,
  });
}

/// Custom painter for confetti particles
class _ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;
  final double gravity;
  final Offset emissionPoint;
  final double wind;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
    required this.gravity,
    required this.emissionPoint,
    required this.wind,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final particle in particles) {
      // Calculate position with physics
      final time = progress * 3; // Scale time for animation
      final x = emissionPoint.dx +
          particle.initialX +
          (particle.velocityX * time) +
          (wind * time * time); // Wind effect
      final y = emissionPoint.dy +
          particle.initialY +
          (particle.velocityY * time) +
          (0.5 * gravity * time * time);

      // Calculate rotation
      final rotation = particle.rotationSpeed * time * 2 * math.pi;

      // Calculate opacity (fade out at the end)
      final opacity = progress < 0.8 ? 1.0 : (1.0 - (progress - 0.8) / 0.2);

      // Skip if off screen
      if (x < -50 || x > size.width + 50 || y > size.height + 50) continue;

      // Add metallic effect
      final baseColor = particle.isMetallic
          ? Color.lerp(particle.color, Colors.white, 0.3 + (progress * 0.2))!
          : particle.color;

      paint.color = baseColor.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      // Draw different shapes
      switch (particle.shape) {
        case ConfettiShape.rectangle:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 1.5,
            ),
            paint,
          );
          break;
        case ConfettiShape.circle:
          canvas.drawCircle(Offset.zero, particle.size / 2, paint);
          break;
        case ConfettiShape.star:
          _drawStar(canvas, paint, particle.size);
          break;
        case ConfettiShape.triangle:
          _drawTriangle(canvas, paint, particle.size);
          break;
      }

      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, Paint paint, double size) {
    final path = Path();
    final angle = (2 * math.pi) / 5;

    for (int i = 0; i < 5; i++) {
      final outerAngle = i * angle - math.pi / 2;
      final innerAngle = outerAngle + angle / 2;

      final outerX = math.cos(outerAngle) * size / 2;
      final outerY = math.sin(outerAngle) * size / 2;

      final innerX = math.cos(innerAngle) * size / 4;
      final innerY = math.sin(innerAngle) * size / 4;

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawTriangle(Canvas canvas, Paint paint, double size) {
    final path = Path();
    path.moveTo(0, -size / 2);
    path.lineTo(-size / 2, size / 2);
    path.lineTo(size / 2, size / 2);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Confetti piece shapes
enum ConfettiShape {
  rectangle,
  circle,
  star,
  triangle,
}

/// Preset positions for confetti emission
enum ConfettiPosition {
  topLeft,
  topCenter,
  topRight,
  center,
  bottomLeft,
  bottomCenter,
  bottomRight,
}
