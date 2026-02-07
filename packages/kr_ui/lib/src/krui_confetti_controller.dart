import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'krui_confetti.dart' show ConfettiPosition, ConfettiShape;

/// A callable confetti controller for showing confetti animations like toast notifications
class KruiConfettiController {
  static OverlayEntry? _overlayEntry;

  /// Show confetti with customizable options
  ///
  /// Example:
  /// ```dart
  /// KruiConfettiController.show(
  ///   context,
  ///   position: ConfettiPosition.topCenter,
  ///   particleCount: 80,
  ///   colors: [Colors.gold, Colors.orange],
  /// );
  /// ```
  static void show(
    BuildContext context, {
    int particleCount = 50,
    List<Color>? colors,
    double explosionForce = 400,
    double gravity = 500,
    Duration duration = const Duration(seconds: 3),
    ConfettiPosition position = ConfettiPosition.center,
    Offset? customPosition,
    double minSize = 8,
    double maxSize = 12,
    bool useMultipleShapes = true,
    double spreadAngle = 2 * math.pi,
    double wind = 0,
    bool enableMetallic = false,
    double rotationVariation = 1.0,
    VoidCallback? onComplete,
  }) {
    // Remove any existing confetti
    hide();

    _overlayEntry = OverlayEntry(
      builder: (context) => _ConfettiOverlay(
        particleCount: particleCount,
        colors: colors,
        explosionForce: explosionForce,
        gravity: gravity,
        duration: duration,
        position: position,
        customPosition: customPosition,
        minSize: minSize,
        maxSize: maxSize,
        useMultipleShapes: useMultipleShapes,
        spreadAngle: spreadAngle,
        wind: wind,
        enableMetallic: enableMetallic,
        rotationVariation: rotationVariation,
        onComplete: () {
          hide();
          onComplete?.call();
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Hide any active confetti
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

/// Internal overlay widget for confetti
class _ConfettiOverlay extends StatefulWidget {
  final int particleCount;
  final List<Color>? colors;
  final double explosionForce;
  final double gravity;
  final Duration duration;
  final ConfettiPosition position;
  final Offset? customPosition;
  final double minSize;
  final double maxSize;
  final bool useMultipleShapes;
  final double spreadAngle;
  final double wind;
  final bool enableMetallic;
  final double rotationVariation;
  final VoidCallback? onComplete;

  const _ConfettiOverlay({
    required this.particleCount,
    this.colors,
    required this.explosionForce,
    required this.gravity,
    required this.duration,
    required this.position,
    this.customPosition,
    required this.minSize,
    required this.maxSize,
    required this.useMultipleShapes,
    required this.spreadAngle,
    required this.wind,
    required this.enableMetallic,
    required this.rotationVariation,
    this.onComplete,
  });

  @override
  State<_ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<_ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<ConfettiParticle> _particles;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _particles = [];
    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_particles.isEmpty) {
      _initializeParticles();
    }
  }

  void _initializeParticles() {
    final colors = widget.colors ??
        [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
          Colors.pink,
        ];

    final centerAngle = -math.pi / 2;

    for (int i = 0; i < widget.particleCount; i++) {
      final angle = centerAngle +
          (-widget.spreadAngle / 2) +
          (_random.nextDouble() * widget.spreadAngle);
      final velocity =
          widget.explosionForce * (0.5 + _random.nextDouble() * 0.5);
      final rotationSpeed = widget.rotationVariation > 0
          ? ((-2 + _random.nextDouble() * 4) * widget.rotationVariation)
              .toDouble()
          : 0.0;

      _particles.add(
        ConfettiParticle(
          color: colors[_random.nextInt(colors.length)],
          initialX: 0,
          initialY: 0,
          velocityX: math.cos(angle) * velocity,
          velocityY: math.sin(angle) * velocity,
          size: widget.minSize +
              _random.nextDouble() * (widget.maxSize - widget.minSize),
          rotation: _random.nextDouble() * 2 * math.pi,
          rotationSpeed: rotationSpeed,
          shape: widget.useMultipleShapes
              ? ConfettiShape
                  .values[_random.nextInt(ConfettiShape.values.length)]
              : ConfettiShape.rectangle,
          isMetallic: widget.enableMetallic,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _getPositionOffset(ConfettiPosition position, Size size) {
    switch (position) {
      case ConfettiPosition.topLeft:
        return Offset(size.width * 0.1, size.height * 0.1);
      case ConfettiPosition.topCenter:
        return Offset(size.width * 0.5, 0);
      case ConfettiPosition.topRight:
        return Offset(size.width * 0.9, size.height * 0.1);
      case ConfettiPosition.center:
        return Offset(size.width * 0.5, size.height * 0.5);
      case ConfettiPosition.bottomLeft:
        return Offset(size.width * 0.1, size.height * 0.9);
      case ConfettiPosition.bottomCenter:
        return Offset(size.width * 0.5, size.height);
      case ConfettiPosition.bottomRight:
        return Offset(size.width * 0.9, size.height * 0.9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final emissionPoint = widget.customPosition ??
              _getPositionOffset(
                widget.position,
                Size(constraints.maxWidth, constraints.maxHeight),
              );

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
      ),
    );
  }
}

/// Represents a single confetti particle
class ConfettiParticle {
  final Color color;
  final double initialX;
  final double initialY;
  final double velocityX;
  final double velocityY;
  final double size;
  final double rotation;
  final double rotationSpeed;
  final ConfettiShape shape;
  final bool isMetallic;

  ConfettiParticle({
    required this.color,
    required this.initialX,
    required this.initialY,
    required this.velocityX,
    required this.velocityY,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.shape,
    required this.isMetallic,
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
    for (var particle in particles) {
      final time = progress * 3;
      final x = emissionPoint.dx +
          particle.initialX +
          (particle.velocityX * time) +
          (wind * time * time);
      final y = emissionPoint.dy +
          particle.initialY +
          (particle.velocityY * time) +
          (0.5 * gravity * time * time);

      if (x < -50 || x > size.width + 50 || y > size.height + 50) continue;

      final opacity = (1 - progress).clamp(0.0, 1.0);
      final baseColor = particle.isMetallic
          ? Color.lerp(particle.color, Colors.white, 0.3 + (progress * 0.2))!
          : particle.color;

      final paint = Paint()
        ..color = baseColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas
          .rotate(particle.rotation + (particle.rotationSpeed * progress * 6));

      _drawShape(canvas, particle, paint);
      canvas.restore();
    }
  }

  void _drawShape(Canvas canvas, ConfettiParticle particle, Paint paint) {
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
        _drawStar(canvas, particle.size, paint);
        break;
      case ConfettiShape.triangle:
        _drawTriangle(canvas, particle.size, paint);
        break;
    }
  }

  void _drawStar(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final outerRadius = size / 2;
    final innerRadius = size / 4;

    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 2 * math.pi / 5) - math.pi / 2;
      final innerAngle = outerAngle + math.pi / 5;

      if (i == 0) {
        path.moveTo(
          math.cos(outerAngle) * outerRadius,
          math.sin(outerAngle) * outerRadius,
        );
      } else {
        path.lineTo(
          math.cos(outerAngle) * outerRadius,
          math.sin(outerAngle) * outerRadius,
        );
      }

      path.lineTo(
        math.cos(innerAngle) * innerRadius,
        math.sin(innerAngle) * innerRadius,
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawTriangle(Canvas canvas, double size, Paint paint) {
    final path = Path()
      ..moveTo(0, -size / 2)
      ..lineTo(size / 2, size / 2)
      ..lineTo(-size / 2, size / 2)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
