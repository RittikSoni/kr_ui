import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiAnimatedGradientBackgroundInfo = ComponentInfo(
  id: 'animated-gradient-background',
  name: 'KruiAnimatedGradientBackground',
  displayName: 'Animated Gradient Background',
  description:
      'Smooth, mesmerizing gradient animation that continuously transitions through colors. Perfect for hero sections, login screens, and premium app backgrounds.',
  category: 'Visual',
  icon: Icons.gradient_outlined,
  properties: [
    const PropertyInfo(
      name: 'colors',
      type: 'List<Color>',
      defaultValue: 'required',
      description: 'List of colors to animate through.',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'duration',
      type: 'Duration',
      defaultValue: 'Duration(seconds: 4)',
      description: 'Duration of one complete animation cycle.',
    ),
    const PropertyInfo(
      name: 'animationDirection',
      type: 'GradientAnimationDirection',
      defaultValue: 'GradientAnimationDirection.rotate',
      description:
          'Animation type: rotate (alignment), slide (color stops), or pulse (opacity).',
    ),
    const PropertyInfo(
      name: 'begin',
      type: 'Alignment',
      defaultValue: 'Alignment.topLeft',
      description: 'Gradient begin alignment.',
    ),
    const PropertyInfo(
      name: 'end',
      type: 'Alignment',
      defaultValue: 'Alignment.bottomRight',
      description: 'Gradient end alignment.',
    ),
    const PropertyInfo(
      name: 'curve',
      type: 'Curve',
      defaultValue: 'Curves.easeInOut',
      description: 'Animation curve/easing function.',
    ),
    const PropertyInfo(
      name: 'reverse',
      type: 'bool',
      defaultValue: 'true',
      description: 'Whether to reverse the animation (continuous loop).',
    ),
    const PropertyInfo(
      name: 'child',
      type: 'Widget?',
      defaultValue: 'null',
      description: 'Optional child widget to overlay on the gradient.',
    ),
  ],
  basicExample: '''KruiAnimatedGradientBackground(
  colors: [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFFF093FB),
  ],
  child: Center(
    child: Text(
      'Beautiful!',
      style: TextStyle(color: Colors.white, fontSize: 32),
    ),
  ),
);''',
  advancedExample: '''KruiAnimatedGradientBackground(
  colors: [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFFF093FB),
    Color(0xFF4FACFE),
  ],
  duration: Duration(seconds: 6),
  child: SafeArea(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Premium Experience',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    ),
  ),
);''',
  presets: [
    PresetInfo(
      name: 'Rotate Direction',
      description: 'Rotating gradient alignment animation',
      code: '''KruiAnimatedGradientBackground(
  colors: [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFFF093FB),
  ],
  animationDirection: GradientAnimationDirection.rotate,
  duration: Duration(seconds: 4),
  child: Center(child: Text('Rotate')),
);''',
      builder: () => SizedBox(
        height: 200,
        child: KruiAnimatedGradientBackground(
          colors: const [
            Color(0xFF667eea),
            Color(0xFF764ba2),
            Color(0xFFF093FB),
          ],
          animationDirection: GradientAnimationDirection.rotate,
          duration: const Duration(seconds: 4),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rotate_right, size: 48, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Rotate Animation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Slide Direction',
      description: 'Sliding color stops animation',
      code: '''KruiAnimatedGradientBackground(
  colors: [
    Color(0xFFFA709A),
    Color(0xFFFEE140),
    Color(0xFFFF6B6B),
  ],
  animationDirection: GradientAnimationDirection.slide,
  duration: Duration(seconds: 5),
  curve: Curves.easeInOut,
  child: Center(child: Text('Slide')),
);''',
      builder: () => SizedBox(
        height: 200,
        child: KruiAnimatedGradientBackground(
          colors: const [
            Color(0xFFFA709A),
            Color(0xFFFEE140),
            Color(0xFFFF6B6B),
          ],
          animationDirection: GradientAnimationDirection.slide,
          duration: const Duration(seconds: 5),
          curve: Curves.easeInOut,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.swipe_right, size: 48, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Slide Animation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Pulse Direction',
      description: 'Pulsing opacity animation',
      code: '''KruiAnimatedGradientBackground(
  colors: [
    Color(0xFF2E3192),
    Color(0xFF1BFFFF),
    Color(0xFF00C9FF),
  ],
  animationDirection: GradientAnimationDirection.pulse,
  duration: Duration(seconds: 3),
  curve: Curves.easeInOutSine,
  child: Center(child: Text('Pulse')),
);''',
      builder: () => SizedBox(
        height: 200,
        child: KruiAnimatedGradientBackground(
          colors: const [
            Color(0xFF2E3192),
            Color(0xFF1BFFFF),
            Color(0xFF00C9FF),
          ],
          animationDirection: GradientAnimationDirection.pulse,
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOutSine,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lens_blur, size: 48, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Pulse Animation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Custom Alignment',
      description: 'Rotate with custom alignment and curve',
      code: '''KruiAnimatedGradientBackground(
  colors: [
    Color(0xFFFF6B6B),
    Color(0xFFFFD93D),
    Color(0xFF6BCF7F),
  ],
  animationDirection: GradientAnimationDirection.rotate,
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  curve: Curves.elasticInOut,
  duration: Duration(seconds: 6),
  child: Center(child: Text('Custom')),
);''',
      builder: () => SizedBox(
        height: 200,
        child: KruiAnimatedGradientBackground(
          colors: const [
            Color(0xFFFF6B6B),
            Color(0xFFFFD93D),
            Color(0xFF6BCF7F),
          ],
          animationDirection: GradientAnimationDirection.rotate,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          curve: Curves.elasticInOut,
          duration: const Duration(seconds: 6),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.tune, size: 48, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Custom Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ],
  demoBuilder: () => SizedBox(
    height: 300,
    child: KruiAnimatedGradientBackground(
      colors: const [
        Color(0xFF667eea),
        Color(0xFF764ba2),
        Color(0xFFF093FB),
      ],
      duration: const Duration(seconds: 5),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mesmerizing',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Gradient Animation',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
      ),
    ),
  ),
);
