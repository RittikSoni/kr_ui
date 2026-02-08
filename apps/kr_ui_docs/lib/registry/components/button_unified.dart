import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final ComponentInfo kruiButtonInfo = ComponentInfo(
  id: 'button',
  name: 'KruiButton',
  displayName: 'Button',
  description:
      'Universal button component with multiple variants (Primary, Secondary, Destructive, Outline, Ghost, Link, Gradient, Glassy, Glowy), icon support with leading/trailing positioning, loading states, optional ripple effects, and customizable gradient colors',
  category: 'Actions',
  icon: Icons.smart_button_outlined,
  properties: [
    const PropertyInfo(
      name: 'variant',
      type: 'KruiButtonVariant',
      defaultValue: 'KruiButtonVariant.primary',
      description: 'Button style variant (defaults to primary)',
    ),
    const PropertyInfo(
      name: 'onPressed',
      type: 'VoidCallback?',
      defaultValue: 'null',
      description: 'Callback when button is pressed',
    ),
    const PropertyInfo(
      name: 'label',
      type: 'String?',
      defaultValue: 'null',
      description: 'Button label text',
    ),
    const PropertyInfo(
      name: 'child',
      type: 'Widget?',
      defaultValue: 'null',
      description: 'Custom child widget (overrides label)',
    ),
    const PropertyInfo(
      name: 'icon',
      type: 'IconData?',
      defaultValue: 'null',
      description: 'Optional icon to display',
    ),
    const PropertyInfo(
      name: 'iconPosition',
      type: 'KruiButtonIconPosition',
      defaultValue: 'KruiButtonIconPosition.leading',
      description: 'Icon position (leading/trailing)',
    ),
    const PropertyInfo(
      name: 'isLoading',
      type: 'bool',
      defaultValue: 'false',
      description: 'Whether button is in loading state',
    ),
    const PropertyInfo(
      name: 'enableRipple',
      type: 'bool',
      defaultValue: 'true',
      description: 'Enable ripple animation effect',
    ),
    const PropertyInfo(
      name: 'enableHaptics',
      type: 'bool',
      defaultValue: 'true',
      description: 'Enable haptic feedback on press',
    ),
    const PropertyInfo(
      name: 'backgroundColor',
      type: 'Color?',
      defaultValue: 'null',
      description: 'Custom background color',
    ),
    const PropertyInfo(
      name: 'foregroundColor',
      type: 'Color?',
      defaultValue: 'null',
      description: 'Custom text/icon color',
    ),
    const PropertyInfo(
      name: 'borderRadius',
      type: 'BorderRadius?',
      defaultValue: 'BorderRadius.circular(12)',
      description: 'Custom border radius',
    ),
    const PropertyInfo(
      name: 'elevation',
      type: 'double',
      defaultValue: '2',
      description: 'Shadow intensity (0-10)',
    ),
    const PropertyInfo(
      name: 'gradientColors',
      type: 'List<Color>?',
      defaultValue: 'null',
      description:
          'Custom gradient colors for gradient variant (defaults to Purple → Pink → Indigo)',
    ),
  ],
  basicExample: '''KruiButton(
  variant: KruiButtonVariant.primary,
  label: 'Click Me',
  onPressed: () => print('Pressed'),
)''',
  advancedExample: '''KruiButton(
  variant: KruiButtonVariant.gradient,
  label: 'Gradient Button',
  icon: Icons.auto_awesome,
  iconPosition: KruiButtonIconPosition.leading,
  gradientColors: [
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFFEC4899),
  ],
  elevation: 4,
  enableRipple: true,
  onPressed: () => print('Tapped'),
)''',
  presets: [
    PresetInfo(
      name: 'Primary',
      description: 'Solid background for primary actions',
      code: '''KruiButton(
  variant: KruiButtonVariant.primary,
  label: 'Primary',
  onPressed: () {},
)''',
      builder: () => KruiButton(
        variant: KruiButtonVariant.primary,
        label: 'Primary',
        onPressed: () {},
      ),
    ),
    PresetInfo(
      name: 'Secondary',
      description: 'Muted background for secondary actions',
      code: '''KruiButton(
  variant: KruiButtonVariant.secondary,
  label: 'Secondary',
  onPressed: () {},
)''',
      builder: () => KruiButton(
        variant: KruiButtonVariant.secondary,
        label: 'Secondary',
        onPressed: () {},
      ),
    ),
    PresetInfo(
      name: 'Destructive',
      description: 'Red styling for dangerous actions',
      code: '''KruiButton(
  variant: KruiButtonVariant.destructive,
  label: 'Delete',
  icon: Icons.delete,
  onPressed: () {},
)''',
      builder: () => KruiButton(
        variant: KruiButtonVariant.destructive,
        label: 'Delete',
        icon: Icons.delete,
        onPressed: () {},
      ),
    ),
    PresetInfo(
      name: 'Outline',
      description: 'Border only with transparent background',
      code: '''KruiButton(
  variant: KruiButtonVariant.outline,
  label: 'Outline',
  onPressed: () {},
)''',
      builder: () => KruiButton(
        variant: KruiButtonVariant.outline,
        label: 'Outline',
        onPressed: () {},
      ),
    ),
    PresetInfo(
      name: 'Ghost',
      description: 'Minimal styling with hover states',
      code: '''KruiButton(
  variant: KruiButtonVariant.ghost,
  label: 'Ghost',
  onPressed: () {},
)''',
      builder: () => KruiButton(
        variant: KruiButtonVariant.ghost,
        label: 'Ghost',
        onPressed: () {},
      ),
    ),
    PresetInfo(
      name: 'Link',
      description: 'Text-only with underline on hover',
      code: '''KruiButton(
  variant: KruiButtonVariant.link,
  label: 'Learn More',
  icon: Icons.arrow_forward,
  iconPosition: KruiButtonIconPosition.trailing,
  onPressed: () {},
)''',
      builder: () => KruiButton(
        variant: KruiButtonVariant.link,
        label: 'Learn More',
        icon: Icons.arrow_forward,
        iconPosition: KruiButtonIconPosition.trailing,
        onPressed: () {},
      ),
    ),
    PresetInfo(
      name: 'Gradient',
      description: 'Multi-color gradient with shadow',
      code: '''KruiButton(
  variant: KruiButtonVariant.gradient,
  label: 'Gradient',
  icon: Icons.auto_awesome,
  elevation: 4,
  onPressed: () {},
)''',
      builder: () => KruiButton(
        variant: KruiButtonVariant.gradient,
        label: 'Gradient',
        icon: Icons.auto_awesome,
        elevation: 4,
        onPressed: () {},
      ),
    ),
    PresetInfo(
      name: 'Custom Gradient',
      description: 'Gradient with custom colors via gradientColors',
      code: '''KruiButton(
  variant: KruiButtonVariant.gradient,
  label: 'Custom',
  icon: Icons.color_lens,
  gradientColors: const [
    Color(0xFFFF6B6B), // Red
    Color(0xFFFFD93D), // Yellow
    Color(0xFF6BCF7F), // Green
  ],
  onPressed: () {},
)''',
      builder: () => KruiButton(
        variant: KruiButtonVariant.gradient,
        label: 'Custom',
        icon: Icons.color_lens,
        gradientColors: const [
          Color(0xFFFF6B6B),
          Color(0xFFFFD93D),
          Color(0xFF6BCF7F),
        ],
        onPressed: () {},
      ),
    ),
    PresetInfo(
      name: 'With Icon',
      description: 'Button with leading icon',
      code: '''KruiButton(
  variant: KruiButtonVariant.primary,
  label: 'Settings',
  icon: Icons.settings,
  iconPosition: KruiButtonIconPosition.leading,
  onPressed: () {},
)''',
      builder: () => KruiButton(
        variant: KruiButtonVariant.primary,
        label: 'Settings',
        icon: Icons.settings,
        iconPosition: KruiButtonIconPosition.leading,
        onPressed: () {},
      ),
    ),
    PresetInfo(
      name: 'Loading',
      description: 'Button in loading state',
      code: '''KruiButton(
  variant: KruiButtonVariant.primary,
  label: 'Loading',
  isLoading: true,
  onPressed: () {},
)''',
      builder: () => KruiButton(
        variant: KruiButtonVariant.primary,
        label: 'Loading',
        isLoading: true,
        onPressed: () {},
      ),
    ),
    PresetInfo(
      name: 'Glassy',
      description: 'Glassmorphic design with blur effect',
      code: '''KruiButton(
  variant: KruiButtonVariant.glassy,
  label: 'Glassy',
  icon: Icons.blur_on,
  onPressed: () {},
)''',
      builder: () => KruiButton(
        variant: KruiButtonVariant.glassy,
        label: 'Glassy',
        icon: Icons.blur_on,
        onPressed: () {},
      ),
    ),
    PresetInfo(
      name: 'Glowy',
      description: 'Pulsing glow effect with animated shadows',
      code: '''KruiButton(
  variant: KruiButtonVariant.glowy,
  label: 'Glowy',
  icon: Icons.star,
  onPressed: () {},
)''',
      builder: () => KruiButton(
        variant: KruiButtonVariant.glowy,
        label: 'Glowy',
        icon: Icons.star,
        onPressed: () {},
      ),
    ),
  ],
  demoBuilder: () => Builder(
    builder: (context) => KruiButton(
      variant: KruiButtonVariant.glassy,
      label: 'Tap Me',
      icon: Icons.touch_app,
      onPressed: () {
        KruiToast.show(
          message: 'Button Tapped!',
          icon: Icons.check_circle,
          color: const Color(0xFF10B981),
        );
      },
    ),
  ),
);
