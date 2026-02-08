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
      name: 'icon',
      type: 'IconData',
      defaultValue: 'Icons.arrow_forward_ios',
      description: 'Icon displayed in the drag handle.',
    ),
    const PropertyInfo(
      name: 'completionIcon',
      type: 'IconData',
      defaultValue: 'Icons.check',
      description: 'Icon displayed when swipe is completed.',
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
      name: 'dragHandleSize',
      type: 'double?',
      defaultValue: 'null (button height)',
      description: 'Custom size for the drag handle.',
    ),
    const PropertyInfo(
      name: 'dragHandleColor',
      type: 'Color?',
      defaultValue: 'null (white)',
      description: 'Custom color for the drag handle.',
    ),
    const PropertyInfo(
      name: 'backgroundGradientColors',
      type: 'List<Color>?',
      defaultValue: 'null',
      description:
          'Custom gradient colors (overrides primaryColor/accentColor).',
    ),
    const PropertyInfo(
      name: 'minDragDistance',
      type: 'double',
      defaultValue: '5.0',
      description: 'Minimum pixels to drag before slider moves.',
    ),
    const PropertyInfo(
      name: 'fillAnimationDuration',
      type: 'int',
      defaultValue: '200',
      description: 'Animation duration for fill effect (milliseconds).',
    ),
    const PropertyInfo(
      name: 'resetAnimationDuration',
      type: 'int',
      defaultValue: '300',
      description: 'Animation duration for reset (milliseconds).',
    ),
  ],
  basicExample: '''KruiLiquidSwipeButton(
  text: 'Swipe to Confirm',
  onComplete: () => print('Confirmed!'),
  icon: Icons.arrow_forward_rounded,
);''',
  advancedExample: '''KruiLiquidSwipeButton(
  text: 'Swipe to Unlock',
  icon: Icons.lock_outline,
  completionIcon: Icons.lock_open,
  dragHandleColor: Colors.amber,
  dragHandleSize: 70,
  backgroundGradientColors: [
    Color(0xFFFF6B6B),
    Color(0xFFFFD93D),
    Color(0xFF6BCF7F),
  ],
  gradientBegin: Alignment.topLeft,
  gradientEnd: Alignment.bottomRight,
  fillAnimationDuration: 300,
  resetAnimationDuration: 400,
  completionCurve: Curves.elasticOut,
  onComplete: () => print('Unlocked!'),
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
      description: 'Destructive action with red gradient and custom icon',
      code: '''KruiLiquidSwipeButton(
  text: 'Swipe to Delete',
  icon: Icons.delete_outline,
  completionIcon: Icons.check,
  onComplete: () {},
  primaryColor: Color(0xFFFF3B30),
  accentColor: Color(0xFFFF6B6B),
);''',
      builder: () => KruiLiquidSwipeButton(
        text: 'Swipe to Delete',
        icon: Icons.delete_outline,
        completionIcon: Icons.check,
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
      name: 'Unlock',
      description: 'Unlock action with custom handle color',
      code: '''KruiLiquidSwipeButton(
  text: 'Slide to Unlock',
  icon: Icons.lock_outline,
  completionIcon: Icons.lock_open,
  dragHandleColor: Colors.amber,
  onComplete: () {},
  backgroundGradientColors: [
    Color(0xFFFFD700),
    Color(0xFFFFA500),
  ],
);''',
      builder: () => KruiLiquidSwipeButton(
        text: 'Slide to Unlock',
        icon: Icons.lock_outline,
        completionIcon: Icons.lock_open,
        dragHandleColor: Colors.amber,
        onComplete: () => KruiToast.show(
          message: 'Unlocked!',
          icon: Icons.lock_open,
          color: Colors.amber,
        ),
        backgroundGradientColors: const [
          Color(0xFFFFD700),
          Color(0xFFFFA500),
        ],
      ),
    ),
    PresetInfo(
      name: 'Send Message',
      description: 'Send action with custom animations',
      code: '''KruiLiquidSwipeButton(
  text: 'Swipe to Send',
  icon: Icons.send_rounded,
  completionIcon: Icons.check_circle,
  fillAnimationDuration: 150,
  resetAnimationDuration: 250,
  onComplete: () {},
  primaryColor: Color(0xFF007AFF),
  accentColor: Color(0xFF5AC8FA),
);''',
      builder: () => KruiLiquidSwipeButton(
        text: 'Swipe to Send',
        icon: Icons.send_rounded,
        completionIcon: Icons.check_circle,
        fillAnimationDuration: 150,
        resetAnimationDuration: 250,
        onComplete: () => KruiToast.show(
          message: 'Message Sent!',
          icon: Icons.check_circle_outline,
          color: Colors.blue,
        ),
        primaryColor: const Color(0xFF007AFF),
        accentColor: const Color(0xFF5AC8FA),
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
