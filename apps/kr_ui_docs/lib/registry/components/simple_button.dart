import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiSimpleButtonInfo = ComponentInfo(
  id: 'simple-button',
  name: 'KruiSimpleButton',
  displayName: 'Simple Elegant Button',
  description:
      'A premium minimalist button without glass effects. It features modern aesthetics, haptic feedback, and smooth scale animations for a high-quality tactile feel.',
  category: 'Buttons',
  icon: Icons.rectangle_outlined,
  properties: [
    const PropertyInfo(
      name: 'onPressed',
      type: 'VoidCallback?',
      defaultValue: 'required',
      description: 'Callback when button is tapped.',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'child',
      type: 'Widget',
      defaultValue: 'required',
      description: 'The internal widget (usually Text or Icon).',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'color',
      type: 'Color',
      defaultValue: 'Colors.black',
      description: 'The background color of the button.',
    ),
    const PropertyInfo(
      name: 'textColor',
      type: 'Color',
      defaultValue: 'Colors.white',
      description: 'The color of the internal text/icons.',
    ),
    const PropertyInfo(
      name: 'borderRadius',
      type: 'BorderRadius?',
      defaultValue: 'BorderRadius.circular(14)',
      description: 'The corner radius of the button.',
    ),
    const PropertyInfo(
      name: 'isLoading',
      type: 'bool',
      defaultValue: 'false',
      description: 'Whether to show a loading indicator.',
    ),
  ],
  basicExample: '''KruiSimpleButton(
  onPressed: () {},
  child: Text('Elegant Action'),
)''',
  advancedExample: '''KruiSimpleButton(
  onPressed: () {},
  color: Colors.blue,
  textColor: Colors.white,
  borderRadius: BorderRadius.circular(20),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.send, size: 16),
      SizedBox(width: 8),
      Text('Send Message'),
    ],
  ),
)''',
  presets: [
    PresetInfo(
      name: 'Elegant Dark',
      description: 'Classic minimalist black button',
      code: '''KruiSimpleButton(
  onPressed: () {},
  color: Colors.black,
  child: Text('Action'),
)''',
      builder: () => KruiSimpleButton(
        onPressed: () {},
        color: Colors.black,
        child: const Text('Action'),
      ),
    ),
    PresetInfo(
      name: 'Loading',
      description: 'Button in loading state',
      code: '''KruiSimpleButton(
  onPressed: () {},
  isLoading: true,
  child: Text('Loading'),
)''',
      builder: () => const KruiSimpleButton(
        onPressed: null,
        isLoading: true,
        child: Text('Loading'),
      ),
    ),
    PresetInfo(
      name: 'Elegant Light',
      description: 'Clean minimalist white button',
      code: '''KruiSimpleButton(
  onPressed: () {},
  color: Colors.white,
  textColor: Colors.black,
  child: Text('Action'),
)''',
      builder: () => KruiSimpleButton(
        onPressed: () {},
        color: Colors.white,
        textColor: Colors.black,
        child: const Text('Action'),
      ),
    ),
  ],
  demoBuilder: () => Center(
    child: KruiSimpleButton(
      onPressed: () {},
      child: const Text('Elegant Button'),
    ),
  ),
);
