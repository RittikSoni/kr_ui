import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiLiquidSwipeButtonInfo = ComponentInfo(
  id: 'liquid-swipe-button',
  name: 'KruiLiquidSwipeButton',
  displayName: 'Liquid Swipe Button',
  description:
      'Animated button with liquid-like fill effect on press. Users drag from left to right to confirm actions. Perfect for CTAs, confirm actions, and premium interactions.',
  category: 'Buttons',
  icon: Icons.swipe_outlined,
  properties: [
    const PropertyInfo(
      name: 'text',
      type: 'String',
      defaultValue: 'required',
      description: 'The text to display on the button.',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'onComplete',
      type: 'VoidCallback',
      defaultValue: 'required',
      description:
          'Callback triggered when swipe is completed (95% threshold).',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'primaryColor',
      type: 'Color',
      defaultValue: 'Color(0xFF6C63FF)',
      description: 'Primary gradient color.',
    ),
    const PropertyInfo(
      name: 'accentColor',
      type: 'Color',
      defaultValue: 'Color(0xFF4ECDC4)',
      description: 'Accent gradient color.',
    ),
    const PropertyInfo(
      name: 'height',
      type: 'double',
      defaultValue: '60',
      description: 'Button height.',
    ),
    const PropertyInfo(
      name: 'width',
      type: 'double',
      defaultValue: '280',
      description: 'Button width.',
    ),
    const PropertyInfo(
      name: 'swipingText',
      type: 'String?',
      defaultValue: 'null ("Keep going...")',
      description:
          'Text displayed when actively dragging (after 20% progress).',
    ),
    const PropertyInfo(
      name: 'almostCompleteText',
      type: 'String?',
      defaultValue: 'null ("Release!")',
      description: 'Text displayed when almost complete (after 80% progress).',
    ),
  ],
  basicExample: '''KruiLiquidSwipeButton(
  text: 'Swipe to Confirm',
  onComplete: () => print('Confirmed!'),
);''',
  advancedExample: '''KruiLiquidSwipeButton(
  text: 'Swipe to Delete',
  swipingText: 'Deleting...',
  almostCompleteText: 'Let go to confirm',
  onComplete: () {
    // Perform delete action
    print('Item deleted!');
  },
  primaryColor: Color(0xFFFF3B30),
  accentColor: Color(0xFFFF6B6B),
  width: 300,
  height: 65,
);''',
  presets: [
    PresetInfo(
      name: 'Confirm Action',
      description: 'Standard confirmation with purple gradient',
      code: '''KruiLiquidSwipeButton(
  text: 'Swipe to Confirm',
  onComplete: () {},
  primaryColor: Color(0xFF6C63FF),
  accentColor: Color(0xFF4ECDC4),
);''',
      builder: () => KruiLiquidSwipeButton(
        text: 'Swipe to Confirm',
        onComplete: () => KruiToast.show(message: '✓ Confirmed!'),
        primaryColor: const Color(0xFF6C63FF),
        accentColor: const Color(0xFF4ECDC4),
      ),
    ),
    PresetInfo(
      name: 'Delete Action',
      description: 'Destructive action with red gradient',
      code: '''KruiLiquidSwipeButton(
  text: 'Swipe to Delete',
  onComplete: () {},
  primaryColor: Color(0xFFFF3B30),
  accentColor: Color(0xFFFF6B6B),
);''',
      builder: () => KruiLiquidSwipeButton(
        text: 'Swipe to Delete',
        onComplete: () => KruiToast.show(
          message: 'Deleted',
          icon: Icons.delete_outline,
          color: Colors.red,
        ),
        primaryColor: const Color(0xFFFF3B30),
        accentColor: const Color(0xFFFF6B6B),
      ),
    ),
    PresetInfo(
      name: 'Submit Action',
      description: 'Success action with green gradient',
      code: '''KruiLiquidSwipeButton(
  text: 'Swipe to Submit',
  onComplete: () {},
  primaryColor: Color(0xFF34C759),
  accentColor: Color(0xFF30D158),
);''',
      builder: () => KruiLiquidSwipeButton(
        text: 'Swipe to Submit',
        onComplete: () => KruiToast.show(
          message: 'Submitted Successfully!',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        ),
        primaryColor: const Color(0xFF34C759),
        accentColor: const Color(0xFF30D158),
      ),
    ),
  ],
  demoBuilder: () => Center(
    child: KruiLiquidSwipeButton(
      text: 'Swipe to Confirm',
      onComplete: () => KruiToast.show(
        message: 'Action Confirmed!',
        icon: Icons.check_circle_outline,
        color: Colors.green,
      ),
    ),
  ),
);
