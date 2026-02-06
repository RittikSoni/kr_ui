import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiGlassyCardInfo = ComponentInfo(
  id: 'glassy-card',
  name: 'KruiGlassyCard',
  displayName: 'Glassy Card',
  description:
      'A beautiful glassmorphic card widget with customizable frosted glass effects. Perfect for creating modern iOS-style interfaces with depth and elegance.',
  category: 'Cards',
  icon: Icons.layers_outlined,
  properties: [
    const PropertyInfo(
      name: 'child',
      type: 'Widget',
      defaultValue: 'required',
      description: 'The widget to display inside the glass card',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'blur',
      type: 'double',
      defaultValue: '10',
      description: 'Blur intensity (0-30)',
    ),
    const PropertyInfo(
      name: 'opacity',
      type: 'double',
      defaultValue: '0.15',
      description: 'Glass opacity (0.0-1.0)',
    ),
    const PropertyInfo(
      name: 'color',
      type: 'Color',
      defaultValue: 'Colors.white',
      description: 'Glass tint color',
    ),
    const PropertyInfo(
      name: 'borderRadius',
      type: 'BorderRadius?',
      defaultValue: 'BorderRadius.circular(16)',
      description: 'Corner radius',
    ),
    const PropertyInfo(
      name: 'border',
      type: 'Border?',
      defaultValue: 'subtle white border',
      description: 'Custom border',
    ),
    const PropertyInfo(
      name: 'padding',
      type: 'EdgeInsets?',
      defaultValue: 'EdgeInsets.all(16)',
      description: 'Internal padding',
    ),
    const PropertyInfo(
      name: 'margin',
      type: 'EdgeInsets?',
      defaultValue: 'null',
      description: 'External margin',
    ),
    const PropertyInfo(
      name: 'width',
      type: 'double?',
      defaultValue: 'null',
      description: 'Fixed width (auto if null)',
    ),
    const PropertyInfo(
      name: 'height',
      type: 'double?',
      defaultValue: 'null',
      description: 'Fixed height (auto if null)',
    ),
    const PropertyInfo(
      name: 'shadowColor',
      type: 'Color?',
      defaultValue: 'Colors.black.withValues(alpha:0.1)',
      description: 'Shadow color',
    ),
    const PropertyInfo(
      name: 'shadowBlur',
      type: 'double',
      defaultValue: '20',
      description: 'Shadow blur radius',
    ),
    const PropertyInfo(
      name: 'shadowOffset',
      type: 'Offset',
      defaultValue: 'Offset(0, 10)',
      description: 'Shadow position offset',
    ),
    const PropertyInfo(
      name: 'enableShadow',
      type: 'bool',
      defaultValue: 'true',
      description: 'Enable/disable shadow',
    ),
    const PropertyInfo(
      name: 'alignment',
      type: 'AlignmentGeometry?',
      defaultValue: 'null',
      description: 'Child alignment within card',
    ),
  ],
  basicExample: '''KruiGlassyCard(
  child: Text('Beautiful Glass Effect'),
)''',
  advancedExample: '''KruiGlassyCard(
  blur: 15,
  opacity: 0.2,
  color: Colors.white,
  borderRadius: BorderRadius.circular(24),
  border: Border.all(
    color: Colors.white.withValues(alpha:0.3),
    width: 2,
  ),
  padding: EdgeInsets.all(24),
  child: Column(
    children: [
      Icon(Icons.favorite, size: 48),
      SizedBox(height: 8),
      Text('Premium Design'),
    ],
  ),
)''',
  presets: [
    PresetInfo(
      name: 'Subtle',
      description: 'Minimal blur and low opacity for subtle effects',
      code: '''GlassyCardPresets.subtle(
  child: Text('Subtle Glass'),
)''',
      builder: () => Container(
        width: 200,
        height: 100,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?q=80&w=2000',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: GlassyCardPresets.subtle(
            child: const Text('Subtle Glass',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Standard',
      description: 'Balanced blur and opacity for most use cases',
      code: '''GlassyCardPresets.standard(
  child: Text('Standard Glass'),
)''',
      builder: () => Container(
        width: 200,
        height: 100,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?q=80&w=2000',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: GlassyCardPresets.standard(
            child: const Text('Standard Glass',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Strong',
      description: 'High blur and opacity for prominent glass effects',
      code: '''GlassyCardPresets.strong(
  child: Text('Strong Glass'),
)''',
      builder: () => Container(
        width: 200,
        height: 100,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?q=80&w=2000',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: GlassyCardPresets.strong(
            child: const Text('Strong Glass',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Dark',
      description: 'Dark tint with moderate blur for dark mode UIs',
      code: '''GlassyCardPresets.dark(
  child: Text('Dark Glass'),
)''',
      builder: () => Container(
        width: 200,
        height: 100,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?q=80&w=2000',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: GlassyCardPresets.dark(
            child:
                const Text('Dark Glass', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Colored',
      description: 'Custom color tint for branded glass effects',
      code: '''GlassyCardPresets.colored(
  color: Colors.blue,
  child: Text('Colored Glass'),
)''',
      builder: () => Container(
        width: 200,
        height: 100,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?q=80&w=2000',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: GlassyCardPresets.colored(
            color: const Color(0xFF007AFF),
            child: const Text('Colored Glass',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Elegant Light',
      description: 'Minimalist solid white aesthetic without glass blur',
      code: '''KruiGlassyCard(
  blur: 0,
  opacity: 1.0,
  color: Colors.white,
  child: Text('Elegant Light'),
)''',
      builder: () => const KruiGlassyCard(
        blur: 0,
        opacity: 1.0,
        color: Colors.white,
        child: Text('Elegant Light', style: TextStyle(color: Colors.black)),
      ),
    ),
    PresetInfo(
      name: 'Elegant Dark',
      description: 'Minimalist solid black aesthetic without glass blur',
      code: '''KruiGlassyCard(
  blur: 0,
  opacity: 1.0,
  color: Colors.black,
  child: Text('Elegant Dark'),
)''',
      builder: () => const KruiGlassyCard(
        blur: 0,
        opacity: 1.0,
        color: Colors.black,
        child: Text('Elegant Dark', style: TextStyle(color: Colors.white)),
      ),
    ),
  ],
  demoBuilder: () => Container(
    width: 300,
    height: 200,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
      ),
    ),
    child: const Center(
      child: KruiGlassyCard(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Glassmorphism',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  ),
);
