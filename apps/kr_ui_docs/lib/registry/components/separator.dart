import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiSeparatorInfo = ComponentInfo(
  id: 'separator',
  name: 'KruiSeparator',
  displayName: 'Modern Separator',
  description:
      'A flexible divider component supporting horizontal and vertical orientations, custom line styles (solid, dashed, dotted), and centered content like text or icons.',
  category: 'Layout',
  icon: Icons.horizontal_rule,
  properties: [
    const PropertyInfo(
      name: 'axis',
      type: 'Axis',
      defaultValue: 'Axis.horizontal',
      description: 'Orientation of the separator.',
    ),
    const PropertyInfo(
      name: 'style',
      type: 'SeparatorStyle',
      defaultValue: 'SeparatorStyle.solid',
      description: 'Line style: solid, dashed, or dotted.',
    ),
    const PropertyInfo(
      name: 'text',
      type: 'String?',
      defaultValue: 'null',
      description: 'Optional text to display in the center.',
    ),
    const PropertyInfo(
      name: 'icon',
      type: 'IconData?',
      defaultValue: 'null',
      description: 'Optional icon to display in the center.',
    ),
    const PropertyInfo(
      name: 'color',
      type: 'Color?',
      defaultValue: 'Theme.dividerColor',
      description: 'Color of the line and content.',
    ),
    const PropertyInfo(
      name: 'thickness',
      type: 'double',
      defaultValue: '1.0',
      description: 'Thickness of the line.',
    ),
  ],
  basicExample: '''KruiSeparator.horizontal(
  text: 'OR',
  style: SeparatorStyle.dashed,
)''',
  advancedExample: '''Row(
  children: [
    Expanded(child: Text('Left Content')),
    KruiSeparator.vertical(
      height: 50,
      color: Colors.blue,
      thickness: 2,
    ),
    Expanded(child: Text('Right Content')),
  ],
)''',
  presets: [
    PresetInfo(
      name: 'Standard Divider',
      description: 'Simple horizontal line',
      code: '''KruiSeparator.horizontal()''',
      builder: () => const SizedBox(
        width: 300,
        child: KruiSeparator.horizontal(),
      ),
    ),
    PresetInfo(
      name: 'Dashed with Text',
      description: 'Dashed line with centered text',
      code: '''KruiSeparator.horizontal(
  text: 'SECTION',
  style: SeparatorStyle.dashed,
)''',
      builder: () => const SizedBox(
        width: 300,
        child: KruiSeparator.horizontal(
          text: 'SECTION',
          style: SeparatorStyle.dashed,
        ),
      ),
    ),
    PresetInfo(
      name: 'Dotted with Icon',
      description: 'Dotted line with centered icon',
      code: '''KruiSeparator.horizontal(
  icon: Icons.star,
  iconSize: 16,
  style: SeparatorStyle.dotted,
  color: Colors.amber,
)''',
      builder: () => const SizedBox(
        width: 300,
        child: KruiSeparator.horizontal(
          icon: Icons.star,
          iconSize: 16,
          style: SeparatorStyle.dotted,
          color: Colors.amber,
        ),
      ),
    ),
  ],
  demoBuilder: () => Center(
    child: Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Section A'),
          KruiSeparator.horizontal(text: 'OR'),
          Text('Section B'),
          KruiSeparator.horizontal(
            style: SeparatorStyle.dashed,
            color: Colors.blue,
            thickness: 2,
          ),
          Text('Section C'),
        ],
      ),
    ),
  ),
);
