import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiParticleBurstInfo = ComponentInfo(
  id: 'particle-burst',
  name: 'KruiParticleBurst',
  displayName: 'Particle Burst',
  description:
      'Celebratory particle explosion effect that radiates outward from center with a fade-out. Perfect for success states, achievements, gamification, and likes.',
  category: 'Animation',
  icon: Icons.celebration_outlined,
  properties: [
    const PropertyInfo(
      name: 'color',
      type: 'Color',
      defaultValue: 'Colors.amber',
      description: 'Color of the particles.',
    ),
    const PropertyInfo(
      name: 'particleCount',
      type: 'int',
      defaultValue: '30',
      description: 'Number of particles to generate.',
    ),
    const PropertyInfo(
      name: 'size',
      type: 'double',
      defaultValue: '200',
      description: 'Size of the animation area.',
    ),
    const PropertyInfo(
      name: 'onComplete',
      type: 'VoidCallback?',
      defaultValue: 'null',
      description: 'Callback triggered when animation completes.',
    ),
  ],
  basicExample: '''bool showBurst = false;

// Trigger the burst
setState(() => showBurst = true);

// In your widget tree
if (showBurst)
  KruiParticleBurst(
    color: Colors.amber,
    onComplete: () => setState(() => showBurst = false),
  )''',
  advancedExample: '''// Use Stack to overlay on content
Stack(
  alignment: Alignment.center,
  children: [
    // Your content
    YourContentWidget(),
    
    // Particle burst overlay
    if (showCelebration)
      Positioned.fill(
        child: KruiParticleBurst(
          color: Colors.purple,
          particleCount: 50,
          size: 300,
          onComplete: () {
            setState(() => showCelebration = false);
          },
        ),
      ),
  ],
)''',
  presets: [
    PresetInfo(
      name: 'Like Animation',
      description: 'Red hearts for like actions',
      code: '''KruiParticleBurst(
  color: Colors.red,
  particleCount: 30,
  size: 150,
);''',
      builder: () => _ParticleBurstDemo(
        color: Colors.red,
        particleCount: 30,
        size: 150,
        label: 'Like!',
      ),
    ),
    PresetInfo(
      name: 'Achievement',
      description: 'Golden particles for achievements',
      code: '''KruiParticleBurst(
  color: Colors.amber,
  particleCount: 40,
  size: 200,
);''',
      builder: () => _ParticleBurstDemo(
        color: Colors.amber,
        particleCount: 40,
        size: 200,
        label: 'Achievement Unlocked!',
      ),
    ),
    PresetInfo(
      name: 'Success',
      description: 'Green particles for success states',
      code: '''KruiParticleBurst(
  color: Colors.green,
  particleCount: 35,
  size: 180,
);''',
      builder: () => _ParticleBurstDemo(
        color: Colors.green,
        particleCount: 35,
        size: 180,
        label: 'Success!',
      ),
    ),
  ],
  demoBuilder: () => _ParticleBurstDemo(
    color: Colors.amber,
    particleCount: 40,
    size: 200,
    label: 'Celebrate!',
  ),
);

/// Helper widget for particle burst demos
class _ParticleBurstDemo extends StatefulWidget {
  final Color color;
  final int particleCount;
  final double size;
  final String label;

  const _ParticleBurstDemo({
    required this.color,
    required this.particleCount,
    required this.size,
    required this.label,
  });

  @override
  State<_ParticleBurstDemo> createState() => _ParticleBurstDemoState();
}

class _ParticleBurstDemoState extends State<_ParticleBurstDemo> {
  bool _showBurst = false;

  void _trigger() {
    setState(() => _showBurst = true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          KruiGlassyButton(
            onPressed: _trigger,
            child: Text(widget.label),
          ),
          if (_showBurst)
            KruiParticleBurst(
              color: widget.color,
              particleCount: widget.particleCount,
              size: widget.size,
              onComplete: () {
                if (mounted) {
                  setState(() => _showBurst = false);
                }
              },
            ),
        ],
      ),
    );
  }
}
