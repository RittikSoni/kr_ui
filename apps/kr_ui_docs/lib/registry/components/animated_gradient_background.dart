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
      name: 'Sunset Theme',
      description: 'Warm sunset colors',
      code: '''KruiAnimatedGradientBackground(
  colors: [
    Color(0xFFFA709A),
    Color(0xFFFEE140),
    Color(0xFFFF6B6B),
  ],
  duration: Duration(seconds: 5),
);''',
      builder: () => SizedBox(
        height: 200,
        child: KruiAnimatedGradientBackground(
          colors: const [
            Color(0xFFFA709A),
            Color(0xFFFEE140),
            Color(0xFFFF6B6B),
          ],
          duration: const Duration(seconds: 5),
          child: const Center(
            child: Text(
              'Sunset',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Ocean Theme',
      description: 'Cool ocean blues',
      code: '''KruiAnimatedGradientBackground(
  colors: [
    Color(0xFF2E3192),
    Color(0xFF1BFFFF),
    Color(0xFF00C9FF),
  ],
  duration: Duration(seconds: 5),
);''',
      builder: () => SizedBox(
        height: 200,
        child: KruiAnimatedGradientBackground(
          colors: const [
            Color(0xFF2E3192),
            Color(0xFF1BFFFF),
            Color(0xFF00C9FF),
          ],
          duration: const Duration(seconds: 5),
          child: const Center(
            child: Text(
              'Ocean',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Aurora Theme',
      description: 'Vibrant aurora borealis',
      code: '''KruiAnimatedGradientBackground(
  colors: [
    Color(0xFF667eea),
    Color(0xFF764ba2),
    Color(0xFFF093FB),
    Color(0xFF4FACFE),
  ],
  duration: Duration(seconds: 6),
);''',
      builder: () => SizedBox(
        height: 200,
        child: KruiAnimatedGradientBackground(
          colors: const [
            Color(0xFF667eea),
            Color(0xFF764ba2),
            Color(0xFFF093FB),
            Color(0xFF4FACFE),
          ],
          duration: const Duration(seconds: 6),
          child: const Center(
            child: Text(
              'Aurora',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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
