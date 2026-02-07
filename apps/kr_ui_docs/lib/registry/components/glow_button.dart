import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiGlowButtonInfo = ComponentInfo(
  id: 'glow-button',
  name: 'KruiGlowButton',
  displayName: 'Glow Button',
  description:
      'Pulsing glow effect button with neon aesthetic. Multi-layered shadows create a mesmerizing premium look. Perfect for premium CTAs, notifications, and highlight actions.',
  category: 'Buttons',
  icon: Icons.lightbulb_outline,
  properties: [
    const PropertyInfo(
      name: 'text',
      type: 'String',
      defaultValue: 'required',
      description: 'Text to display on the button.',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'onTap',
      type: 'VoidCallback',
      defaultValue: 'required',
      description: 'Callback triggered when button is tapped.',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'glowColor',
      type: 'Color',
      defaultValue: 'Color(0xFF00F5FF)',
      description: 'Color of the glow effect.',
    ),
    const PropertyInfo(
      name: 'textColor',
      type: 'Color',
      defaultValue: 'Colors.white',
      description: 'Color of the text.',
    ),
    const PropertyInfo(
      name: 'width',
      type: 'double',
      defaultValue: '200',
      description: 'Button width.',
    ),
    const PropertyInfo(
      name: 'height',
      type: 'double',
      defaultValue: '56',
      description: 'Button height.',
    ),
    const PropertyInfo(
      name: 'isPulsing',
      type: 'bool',
      defaultValue: 'true',
      description: 'Whether the glow should pulse.',
    ),
  ],
  basicExample: '''KruiGlowButton(
  text: 'Get Started',
  onTap: () => print('Tapped!'),
);''',
  advancedExample: '''KruiGlowButton(
  text: 'Premium Action',
  onTap: () {
    print('Premium action triggered!');
  },
  glowColor: Color(0xFFFF00FF),
  textColor: Colors.white,
  width: 250,
  height: 60,
  isPulsing: true,
);''',
  presets: [
    PresetInfo(
      name: 'Neon Cyan',
      description: 'Electric cyan glow effect',
      code: '''KruiGlowButton(
  text: 'Neon Cyan',
  onTap: () {},
  glowColor: Color(0xFF00F5FF),
);''',
      builder: () => KruiGlowButton(
        text: 'Neon Cyan',
        onTap: () => KruiToast.show(message: 'Cyan glow activated!'),
        glowColor: const Color(0xFF00F5FF),
      ),
    ),
    PresetInfo(
      name: 'Electric Purple',
      description: 'Vibrant purple glow',
      code: '''KruiGlowButton(
  text: 'Electric Purple',
  onTap: () {},
  glowColor: Color(0xFFBF40BF),
);''',
      builder: () => KruiGlowButton(
        text: 'Electric Purple',
        onTap: () => KruiToast.show(message: 'Purple glow activated!'),
        glowColor: const Color(0xFFBF40BF),
      ),
    ),
    PresetInfo(
      name: 'Danger Red',
      description: 'Warning/danger state with no pulsing',
      code: '''KruiGlowButton(
  text: 'Danger',
  onTap: () {},
  glowColor: Color(0xFFFF0040),
  isPulsing: false,
);''',
      builder: () => KruiGlowButton(
        text: 'Danger',
        onTap: () => KruiToast.show(
          message: 'Warning!',
          icon: Icons.warning_amber_outlined,
          color: Colors.red,
        ),
        glowColor: const Color(0xFFFF0040),
        isPulsing: false,
      ),
    ),
  ],
  demoBuilder: () => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        KruiGlowButton(
          text: 'Get Started',
          onTap: () => KruiToast.show(
            message: 'Premium experience activated!',
            icon: Icons.auto_awesome,
          ),
          glowColor: const Color(0xFF00F5FF),
        ),
        const SizedBox(height: 24),
        KruiGlowButton(
          text: 'No Pulse',
          onTap: () => KruiToast.show(message: 'Static glow'),
          glowColor: const Color(0xFFBF40BF),
          isPulsing: false,
        ),
      ],
    ),
  ),
);
