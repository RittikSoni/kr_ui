import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiGlassyButtonInfo = ComponentInfo(
  id: 'glassy-button',
  name: 'KruiGlassyButton',
  displayName: 'Glassy Button',
  description:
      'A beautiful glassmorphic button with customizable effects and interactions. Features haptic feedback, press states, and full customization of glass effects.',
  category: 'Buttons',
  icon: Icons.smart_button_outlined,
  properties: [
    const PropertyInfo(
      name: 'onPressed',
      type: 'VoidCallback?',
      defaultValue: 'required',
      description: 'Callback when button is tapped',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'child',
      type: 'Widget',
      defaultValue: 'required',
      description: 'The widget to display inside the button',
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
      description: 'Glass opacity when not pressed (0.0-1.0)',
    ),
    const PropertyInfo(
      name: 'pressedOpacity',
      type: 'double',
      defaultValue: '0.25',
      description: 'Glass opacity when pressed (0.0-1.0)',
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
      defaultValue: 'BorderRadius.circular(12)',
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
      defaultValue: 'EdgeInsets.symmetric(h:16, v:12)',
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
      name: 'enableHaptics',
      type: 'bool',
      defaultValue: 'true',
      description: 'Enable haptic feedback on press',
    ),
    const PropertyInfo(
      name: 'hapticType',
      type: 'HapticType',
      defaultValue: 'HapticType.light',
      description: 'Type of haptic feedback',
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
      defaultValue: '15',
      description: 'Shadow blur radius',
    ),
    const PropertyInfo(
      name: 'enableShadow',
      type: 'bool',
      defaultValue: 'true',
      description: 'Enable/disable shadow',
    ),
    const PropertyInfo(
      name: 'animationDuration',
      type: 'Duration',
      defaultValue: 'Duration(milliseconds: 150)',
      description: 'Press animation duration',
    ),
    const PropertyInfo(
      name: 'isLoading',
      type: 'bool',
      defaultValue: 'false',
      description: 'Whether to show a loading indicator.',
    ),
    const PropertyInfo(
      name: 'alignment',
      type: 'AlignmentGeometry',
      defaultValue: 'Alignment.center',
      description: 'Child alignment within button',
    ),
  ],
  basicExample: '''KruiGlassyButton(
  onPressed: () => print('Tapped!'),
  child: Text('Click Me'),
)''',
  advancedExample: '''KruiGlassyButton(
  onPressed: () => print('Tapped!'),
  blur: 15,
  opacity: 0.2,
  color: Colors.blue,
  borderRadius: BorderRadius.circular(16),
  padding: EdgeInsets.symmetric(
    horizontal: 32,
    vertical: 16,
  ),
  enableHaptics: true,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.favorite),
      SizedBox(width: 8),
      Text('Premium Action'),
    ],
  ),
)''',
  presets: [
    PresetInfo(
      name: 'Primary',
      description: 'Primary action button with strong visual presence',
      code: '''GlassyButtonPresets.primary(
  onPressed: () {},
  child: Text('Primary'),
)''',
      builder: () => GlassyButtonPresets.primary(
        onPressed: () {},
        child: const Text('Primary', style: TextStyle(color: Colors.white)),
      ),
    ),
    PresetInfo(
      name: 'Secondary',
      description: 'Secondary action button with subtle appearance',
      code: '''GlassyButtonPresets.secondary(
  onPressed: () {},
  child: Text('Secondary'),
)''',
      builder: () => GlassyButtonPresets.secondary(
        onPressed: () {},
        child: const Text('Secondary'),
      ),
    ),
    PresetInfo(
      name: 'Destructive',
      description: 'Danger/destructive action button with red tint',
      code: '''GlassyButtonPresets.danger(
  onPressed: () {},
  child: Text('Delete'),
)''',
      builder: () => GlassyButtonPresets.danger(
        onPressed: () {},
        child: const Text('Delete', style: TextStyle(color: Colors.white)),
      ),
    ),
    PresetInfo(
      name: 'Outline',
      description: 'Transparent with a prominent border',
      code: '''GlassyButtonPresets.outline(
  onPressed: () {},
  child: Text('Outline'),
  color: Colors.blue,
)''',
      builder: () => GlassyButtonPresets.outline(
        onPressed: () {},
        color: const Color(0xFF007AFF),
        child:
            const Text('Outline', style: TextStyle(color: Color(0xFF007AFF))),
      ),
    ),
    PresetInfo(
      name: 'Ghost',
      description: 'Subtle background, no border',
      code: '''GlassyButtonPresets.ghost(
  onPressed: () {},
  child: Text('Ghost'),
)''',
      builder: () => GlassyButtonPresets.ghost(
        onPressed: () {},
        child: const Text('Ghost'),
      ),
    ),
    PresetInfo(
      name: 'Link',
      description: 'Minimal text link style',
      code: '''GlassyButtonPresets.link(
  onPressed: () {},
  child: Text('Click Here'),
)''',
      builder: () => GlassyButtonPresets.link(
        onPressed: () {},
        child: const Text('Click Here',
            style: TextStyle(
                color: Color(0xFF007AFF),
                decoration: TextDecoration.underline)),
      ),
    ),
    PresetInfo(
      name: 'Text and Icon',
      description: 'Button combining label and iconography',
      code: '''KruiGlassyButton(
  onPressed: () {},
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.add, size: 18),
      SizedBox(width: 8),
      Text('Add Item'),
    ],
  ),
)''',
      builder: () => KruiGlassyButton(
        onPressed: () {},
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 18),
            SizedBox(width: 8),
            Text('Add Item'),
          ],
        ),
      ),
    ),
    PresetInfo(
      name: 'Loading',
      description: 'Button in loading state with progress indicator',
      code: '''KruiGlassyButton(
  onPressed: () {},
  isLoading: true,
  child: Text('Loading'),
)''',
      builder: () => const KruiGlassyButton(
        onPressed: null,
        isLoading: true,
        child: Text('Loading'),
      ),
    ),
    PresetInfo(
      name: 'Gradient and Shadow',
      description: 'Vibrant gradient with matching glow',
      code: '''GlassyButtonPresets.gradient(
  onPressed: () {},
  colors: [Colors.purple, Colors.blue],
  child: Text('Gradient'),
)''',
      builder: () => GlassyButtonPresets.gradient(
        onPressed: () {},
        colors: [Colors.purple, Colors.blue],
        child: const Text('Gradient', style: TextStyle(color: Colors.white)),
      ),
    ),
  ],
  demoBuilder: () => Builder(
    builder: (context) => KruiGlassyButton(
      onPressed: () {
        KruiToast.show(
          message: 'Glassy Button Tapped!',
          icon: Icons.touch_app_outlined,
          color: const Color(0xFF007AFF),
        );
      },
      blur: 15,
      opacity: 0.2,
      color: const Color(0xFF007AFF),
      child: const Text(
        'Tap for Toast',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  ),
);
