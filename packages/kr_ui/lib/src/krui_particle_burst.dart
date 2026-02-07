import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A celebratory particle explosion animation.
///
/// Creates a burst of particles radiating outward from the center with a
/// fade-out effect. Perfect for success states, achievements, gamification,
/// and like animations.
///
/// Example:
/// ```dart
/// KruiParticleBurst(
///   color: Colors.amber,
///   particleCount: 40,
///   onComplete: () => print('Animation complete!'),
/// )
/// ```
class KruiParticleBurst extends StatefulWidget {
  /// Callback triggered when animation completes
  final VoidCallback? onComplete;

  /// Color of the particles
  final Color color;

  /// Number of particles to generate
  final int particleCount;

  /// Size of the animation area
  final double size;

  const KruiParticleBurst({
    super.key,
    this.onComplete,
    this.color = Colors.amber,
    this.particleCount = 30,
    this.size = 200,
  });

  @override
  State<KruiParticleBurst> createState() => _KruiParticleBurstState();
}

class _KruiParticleBurstState extends State<KruiParticleBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    particles = List.generate(
      widget.particleCount,
      (index) => _Particle(
        angle: (index * 360 / widget.particleCount) * math.pi / 180,
        speed: 50 + (index % 5) * 20,
      ),
    );

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ParticlePainter(
              particles: particles,
              progress: _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _Particle {
  final double angle;
  final double speed;

  _Particle({required this.angle, required this.speed});
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);

    for (var particle in particles) {
      final distance = particle.speed * progress;
      final x = center.dx + distance * math.cos(particle.angle);
      final y = center.dy + distance * math.sin(particle.angle);

      final opacity = 1.0 - progress;
      final particleSize = 4 * (1.0 - progress) + 1;

      paint.color = color.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}
