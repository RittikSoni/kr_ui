import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiAccordionInfo = ComponentInfo(
  id: 'accordion',
  name: 'KruiAccordion',
  displayName: 'Accordion',
  description:
      'A premium glassmorphic accordion component that provides a smooth, animated way to show and hide content.',
  category: 'Structure',
  icon: Icons.expand_more,
  properties: [
    const PropertyInfo(
      name: 'title',
      type: 'Widget',
      defaultValue: 'required',
      description: 'The main header text or widget for the accordion.',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'content',
      type: 'Widget',
      defaultValue: 'required',
      description: 'The expanded content widget.',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'leading',
      type: 'Widget',
      defaultValue: 'null',
      description: 'Optional widget to display before the title.',
    ),
    const PropertyInfo(
      name: 'trailing',
      type: 'Widget',
      defaultValue: 'null',
      description: 'Optional widget to replace the default expand icon.',
    ),
    const PropertyInfo(
      name: 'blur',
      type: 'double',
      defaultValue: '10',
      description: 'The intensity of the glassmorphic blur.',
    ),
    const PropertyInfo(
      name: 'opacity',
      type: 'double',
      defaultValue: '0.1',
      description: 'The opacity of the background layer.',
    ),
  ],
  basicExample: '''KruiAccordion(
  title: Text('What is kr_ui?'),
  content: Text('kr_ui is a premium glassmorphic UI kit for Flutter.'),
)''',
  advancedExample: '''KruiAccordion(
  title: Text('Premium Features'),
  leading: Icon(Icons.star, color: Colors.amber),
  blur: 20,
  opacity: 0.15,
  content: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('• Isolate-based performance'),
      Text('• Smooth animations'),
      Text('• Theme adaptivity'),
    ],
  ),
)''',
  presets: [
    PresetInfo(
      name: 'Basic',
      description: 'Standard glassmorphic accordion item.',
      code: '''KruiAccordion(
  title: Text('Basic Accordion'),
  content: Text('This is the content.'),
)''',
      builder: () => const KruiAccordion(
        title: Text('Basic Accordion'),
        content: Text('This is the content.'),
      ),
    ),
    PresetInfo(
      name: 'Modern Glass',
      description: 'High blur and subtle colors for a premium feel.',
      code: '''KruiAccordion(
  title: Text('Modern Glass'),
  blur: 20,
  opacity: 0.15,
  content: Text('High blur content.'),
)''',
      builder: () => const KruiAccordion(
        title: Text('Modern Glass'),
        blur: 20,
        opacity: 0.15,
        content: Text('High blur content.'),
      ),
    ),
    PresetInfo(
      name: 'Elegant Light',
      description: 'Simple elegant white accordion',
      code: '''KruiAccordion(
  title: Text('Elegant Light'),
  blur: 0,
  opacity: 1.0,
  color: Colors.white,
  content: Text('Minimalist content.'),
)''',
      builder: () => const KruiAccordion(
        title: Text('Elegant Light', style: TextStyle(color: Colors.black)),
        blur: 0,
        opacity: 1.0,
        color: Colors.white,
        content: Text('Minimalist content.',
            style: TextStyle(color: Colors.black87)),
      ),
    ),
    PresetInfo(
      name: 'Elegant Dark',
      description: 'Simple elegant black accordion',
      code: '''KruiAccordion(
  title: Text('Elegant Dark'),
  blur: 0,
  opacity: 1.0,
  color: Colors.black,
  content: Text('Minimalist content.'),
)''',
      builder: () => const KruiAccordion(
        title: Text('Elegant Dark', style: TextStyle(color: Colors.white)),
        blur: 0,
        opacity: 1.0,
        color: Colors.black,
        content: Text('Minimalist content.',
            style: TextStyle(color: Colors.white70)),
      ),
    ),
  ],
  demoBuilder: () => Column(
    children: const [
      KruiAccordion(
        title: Text('Frequently Asked Questions'),
        leading: Icon(Icons.help_outline, size: 20),
        content: Text(
          'This accordion demonstrates the premium glassmorphic effect and smooth expansion animations provided by the kr_ui library.',
        ),
      ),
      KruiAccordion(
        title: Text('Customization'),
        leading: Icon(Icons.tune, size: 20),
        content: Text(
          'You can customize the blur, opacity, border radius, and colors to match your application branding perfectly.',
        ),
      ),
    ],
  ),
);
