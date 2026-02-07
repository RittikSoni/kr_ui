import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final ComponentInfo kruiConfettiInfo = ComponentInfo(
  id: 'confetti',
  name: 'KruiConfetti',
  displayName: 'Confetti',
  description:
      'Realistic confetti explosion with physics simulation. Use KruiConfettiController.show() for easy callable confetti like toast!',
  category: 'Animation',
  icon: Icons.celebration,
  properties: const [
    PropertyInfo(
      name: 'particleCount',
      type: 'int',
      defaultValue: '50',
      description: 'Number of confetti pieces.',
    ),
    PropertyInfo(
      name: 'colors',
      type: 'List<Color>?',
      defaultValue: 'null (default palette)',
      description: 'List of colors for random selection.',
    ),
    PropertyInfo(
      name: 'explosionForce',
      type: 'double',
      defaultValue: '400',
      description: 'Initial velocity of particles.',
    ),
    PropertyInfo(
      name: 'gravity',
      type: 'double',
      defaultValue: '500',
      description: 'Gravity strength pulling pieces down.',
    ),
    PropertyInfo(
      name: 'duration',
      type: 'Duration',
      defaultValue: '3 seconds',
      description: 'Total animation duration.',
    ),
    PropertyInfo(
      name: 'emissionPoint',
      type: 'Offset?',
      defaultValue: 'null (center)',
      description: 'Where explosion starts from.',
    ),
    PropertyInfo(
      name: 'useMultipleShapes',
      type: 'bool',
      defaultValue: 'true',
      description: 'Use all shapes (rect, circle, star, triangle).',
    ),
    PropertyInfo(
      name: 'spreadAngle',
      type: 'double',
      defaultValue: '2*pi (360°)',
      description: 'Emission spread angle in radians.',
    ),
    PropertyInfo(
      name: 'wind',
      type: 'double',
      defaultValue: '0',
      description: 'Horizontal wind drift effect.',
    ),
    PropertyInfo(
      name: 'enableMetallic',
      type: 'bool',
      defaultValue: 'false',
      description: 'Add metallic shimmer effect to confetti.',
    ),
    PropertyInfo(
      name: 'rotationVariation',
      type: 'double',
      defaultValue: '1.0',
      description: 'Rotation randomness (0=none, 1=full).',
    ),
    PropertyInfo(
      name: 'position',
      type: 'ConfettiPosition?',
      defaultValue: 'null',
      description:
          'Preset position (topLeft, topCenter, topRight, center, bottomLeft, bottomCenter, bottomRight).',
    ),
  ],
  basicExample: '''// Easy callable API (Recommended)
KruiConfettiController.show(
  context,
  position: ConfettiPosition.topCenter,
  particleCount: 60,
);''',
  advancedExample: '''// Widget-based approach
Stack(
  children: [
    YourContent(),
    if (celebrate)
      KruiConfetti(
        particleCount: 80,
        position: ConfettiPosition.topCenter,
        colors: [Colors.gold, Colors.orange, Colors.yellow],
        explosionForce: 600,
        enableMetallic: true,
        wind: 50,
        onComplete: () => setState(() => celebrate = false),
      ),
  ],
);

// Or use the controller for more control
KruiConfettiController.show(
  context,
  position: ConfettiPosition.center,
  particleCount: 80,
  colors: [Colors.gold, Colors.orange],
  explosionForce: 600,
  enableMetallic: true,
  wind: 50,
  onComplete: () => print('Done!'),
);''',
  presets: [
    PresetInfo(
      name: 'Controller API',
      description: 'Tap button - uses callable API',
      code: '''KruiConfettiController.show(
  context,
  position: ConfettiPosition.topCenter,
  particleCount: 70,
  colors: [Colors.amber, Colors.orange],
  enableMetallic: true,
);''',
      builder: () => const _ControllerApiDemo(),
    ),
    PresetInfo(
      name: 'Corner Burst',
      description: 'Confetti from top-left corner',
      code: '''KruiConfettiController.show(
  context,
  position: ConfettiPosition.topLeft,
  particleCount: 60,
  spreadAngle: pi,
);''',
      builder: () => const _CornerConfettiDemo(),
    ),
    PresetInfo(
      name: 'Center Explosion',
      description: 'Classic center burst',
      code: '''KruiConfettiController.show(
  context,
  position: ConfettiPosition.center,
  particleCount: 80,
  explosionForce: 600,
);''',
      builder: () => const _CenterConfettiDemo(),
    ),
  ],
  demoBuilder: () => const _ConfettiDemo(),
);

// Main demo - tap button to celebrate
class _ConfettiDemo extends StatefulWidget {
  const _ConfettiDemo();

  @override
  State<_ConfettiDemo> createState() => _ConfettiDemoState();
}

class _ConfettiDemoState extends State<_ConfettiDemo> {
  bool _showConfetti = false;

  void _triggerConfetti() {
    setState(() => _showConfetti = true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade700, Colors.blue.shade700],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: ElevatedButton.icon(
              onPressed: _triggerConfetti,
              icon: const Icon(Icons.celebration),
              label: const Text('Tap to Celebrate!'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (_showConfetti)
            KruiConfetti(
              particleCount: 60,
              onComplete: () => setState(() => _showConfetti = false),
            ),
        ],
      ),
    );
  }
}

// Controller API demo - shows the new callable approach
class _ControllerApiDemo extends StatelessWidget {
  const _ControllerApiDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade800, Colors.amber.shade600],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, size: 80, color: Colors.white),
            const SizedBox(height: 16),
            const Text(
              'Callable Confetti API',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No widget mounting needed!',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                KruiConfettiController.show(
                  context,
                  position: ConfettiPosition.topCenter,
                  particleCount: 70,
                  colors: const [Colors.amber, Colors.orange, Colors.yellow],
                  enableMetallic: true,
                );
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Trigger Confetti'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange.shade800,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Top confetti demo
class _TopConfettiDemo extends StatefulWidget {
  const _TopConfettiDemo();

  @override
  State<_TopConfettiDemo> createState() => _TopConfettiDemoState();
}

class _TopConfettiDemoState extends State<_TopConfettiDemo> {
  bool _showConfetti = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showConfetti = true),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade800, Colors.amber.shade600],
          ),
        ),
        child: Stack(
          children: [
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, size: 80, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Achievement Unlocked!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap anywhere',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            if (_showConfetti)
              KruiConfetti(
                position: ConfettiPosition.topCenter,
                particleCount: 70,
                colors: const [Colors.amber, Colors.orange, Colors.yellow],
                enableMetallic: true,
                onComplete: () => setState(() => _showConfetti = false),
              ),
          ],
        ),
      ),
    );
  }
}

// Corner confetti demo
class _CornerConfettiDemo extends StatefulWidget {
  const _CornerConfettiDemo();

  @override
  State<_CornerConfettiDemo> createState() => _CornerConfettiDemoState();
}

class _CornerConfettiDemoState extends State<_CornerConfettiDemo> {
  bool _showConfetti = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showConfetti = true),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple.shade700, Colors.indigo.shade900],
          ),
        ),
        child: Stack(
          children: [
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.stars, size: 80, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Corner Burst!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'From top-left',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            if (_showConfetti)
              KruiConfetti(
                position: ConfettiPosition.topLeft,
                particleCount: 60,
                spreadAngle: 3.14, // pi
                onComplete: () => setState(() => _showConfetti = false),
              ),
          ],
        ),
      ),
    );
  }
}

// Center confetti demo
class _CenterConfettiDemo extends StatefulWidget {
  const _CenterConfettiDemo();

  @override
  State<_CenterConfettiDemo> createState() => _CenterConfettiDemoState();
}

class _CenterConfettiDemoState extends State<_CenterConfettiDemo> {
  bool _showConfetti = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade700, Colors.cyan.shade800],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.celebration, size: 80, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'Center Explosion!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() => _showConfetti = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.teal.shade700,
                  ),
                  child: const Text('Trigger'),
                ),
              ],
            ),
          ),
          if (_showConfetti)
            KruiConfetti(
              position: ConfettiPosition.center,
              particleCount: 80,
              explosionForce: 600,
              onComplete: () => setState(() => _showConfetti = false),
            ),
        ],
      ),
    );
  }
}
