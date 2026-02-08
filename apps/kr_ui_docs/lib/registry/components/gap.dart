import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiGapInfo = ComponentInfo(
  id: 'gap',
  name: 'KruiGap',
  displayName: 'Gap Spacer',
  description:
      'A readable, semantic alternative to SizedBox for spacing. Improving code clarity by explicitly stating vertical or horizontal intent.',
  category: 'Layout',
  icon: Icons.space_bar,
  properties: [
    const PropertyInfo(
      name: 'vertical',
      type: 'double?',
      defaultValue: '16.0',
      description: 'Vertical space height.',
    ),
    const PropertyInfo(
      name: 'horizontal',
      type: 'double?',
      defaultValue: '16.0',
      description: 'Horizontal space width.',
    ),
  ],
  basicExample: '''Column(
  children: [
    Text('Item 1'),
    KruiGap.vertical(20),
    Text('Item 2'),
  ],
)''',
  advancedExample: '''Row(
  children: [
    Icon(Icons.star),
    KruiGap.horizontal(8),
    Text('Star Icon'),
    KruiGap.horizontal(32),
    Icon(Icons.favorite),
  ],
)''',
  presets: [
    PresetInfo(
      name: 'Vertical 16',
      description: 'Standard vertical spacing',
      code: '''KruiGap.vertical(16)''',
      builder: () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 20, width: 100, color: Colors.blue.shade200),
          const KruiGap.vertical(16),
          Container(height: 20, width: 100, color: Colors.blue.shade400),
        ],
      ),
    ),
    PresetInfo(
      name: 'Horizontal 16',
      description: 'Standard horizontal spacing',
      code: '''KruiGap.horizontal(16)''',
      builder: () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 40, width: 40, color: Colors.green.shade200),
          const KruiGap.horizontal(16),
          Container(height: 40, width: 40, color: Colors.green.shade400),
        ],
      ),
    ),
  ],
  demoBuilder: () => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(color: Colors.red, width: 50, height: 50),
            const KruiGap.horizontal(20),
            Container(color: Colors.blue, width: 50, height: 50),
          ],
        ),
        const KruiGap.vertical(20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(color: Colors.green, width: 50, height: 50),
            const KruiGap.horizontal(20),
            Container(color: Colors.orange, width: 50, height: 50),
          ],
        ),
      ],
    ),
  ),
);
