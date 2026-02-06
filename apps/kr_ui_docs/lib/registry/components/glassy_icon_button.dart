import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiGlassyIconButtonInfo = ComponentInfo(
  id: 'glassy-icon-button',
  name: 'KruiGlassyIconButton',
  displayName: 'Glassy Icon Button (Liquid Glass)',
  description:
      'A beautiful glassmorphic icon button with frosted blur and haptics. Icon-only actions with the same premium liquid glass style as Glassy Button.',
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
      name: 'icon',
      type: 'IconData',
      defaultValue: 'required',
      description: 'Icon to display',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'iconSize',
      type: 'double?',
      defaultValue: '24',
      description: 'Icon size in logical pixels',
    ),
    const PropertyInfo(
      name: 'iconColor',
      type: 'Color?',
      defaultValue: 'null',
      description: 'Icon color (defaults from enabled state)',
    ),
    const PropertyInfo(
      name: 'tooltip',
      type: 'String?',
      defaultValue: 'null',
      description: 'Tooltip text when long-pressing',
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
      name: 'pressedOpacity',
      type: 'double',
      defaultValue: '0.25',
      description: 'Glass opacity when pressed',
    ),
    const PropertyInfo(
      name: 'color',
      type: 'Color',
      defaultValue: 'Colors.white',
      description: 'Glass tint color',
    ),
    const PropertyInfo(
      name: 'size',
      type: 'double',
      defaultValue: '48',
      description: 'Button tap target size',
    ),
    const PropertyInfo(
      name: 'borderRadius',
      type: 'BorderRadius?',
      defaultValue: 'BorderRadius.circular(12)',
      description: 'Corner radius',
    ),
    const PropertyInfo(
      name: 'enableHaptics',
      type: 'bool',
      defaultValue: 'true',
      description: 'Enable haptic feedback',
    ),
  ],
  basicExample: '''KruiGlassyIconButton(
  onPressed: () => print('Tapped'),
  icon: Icons.favorite_border,
)''',
  advancedExample: '''KruiGlassyIconButton(
  onPressed: () {},
  icon: Icons.settings,
  iconSize: 22,
  tooltip: 'Settings',
  blur: 12,
  opacity: 0.2,
  size: 52,
)''',
  presets: [
    PresetInfo(
      name: 'Default',
      description: 'Standard liquid glass icon button',
      code: '''KruiGlassyIconButton(
  onPressed: () {},
  icon: Icons.add,
)''',
      builder: () => KruiGlassyIconButton(
        onPressed: () {},
        icon: Icons.add,
      ),
    ),
    PresetInfo(
      name: 'With tooltip',
      description: 'Icon button with tooltip for accessibility',
      code: '''KruiGlassyIconButton(
  onPressed: () {},
  icon: Icons.settings,
  tooltip: 'Settings',
)''',
      builder: () => KruiGlassyIconButton(
        onPressed: () {},
        icon: Icons.settings,
        tooltip: 'Settings',
      ),
    ),
    PresetInfo(
      name: 'Tinted',
      description: 'Colored glass tint',
      code: '''KruiGlassyIconButton(
  onPressed: () {},
  icon: Icons.favorite,
  color: Color(0xFFFF3B30),
  opacity: 0.25,
)''',
      builder: () => KruiGlassyIconButton(
        onPressed: () {},
        icon: Icons.favorite,
        color: const Color(0xFFFF3B30),
        opacity: 0.25,
      ),
    ),
    PresetInfo(
      name: 'Row of actions',
      description: 'Multiple glassy icon buttons',
      code: '''Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    KruiGlassyIconButton(onPressed: () {}, icon: Icons.share, tooltip: 'Share'),
    SizedBox(width: 8),
    KruiGlassyIconButton(onPressed: () {}, icon: Icons.edit, tooltip: 'Edit'),
    SizedBox(width: 8),
    KruiGlassyIconButton(onPressed: () {}, icon: Icons.delete_outline, tooltip: 'Delete'),
  ],
)''',
      builder: () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          KruiGlassyIconButton(
            onPressed: () {},
            icon: Icons.share,
            tooltip: 'Share',
          ),
          const SizedBox(width: 8),
          KruiGlassyIconButton(
            onPressed: () {},
            icon: Icons.edit,
            tooltip: 'Edit',
          ),
          const SizedBox(width: 8),
          KruiGlassyIconButton(
            onPressed: () {},
            icon: Icons.delete_outline,
            tooltip: 'Delete',
          ),
        ],
      ),
    ),
  ],
  demoBuilder: () => Center(
    child: KruiGlassyIconButton(
      onPressed: () {
        KruiToast.show(
          message: 'Glassy icon button tapped!',
          icon: Icons.touch_app_outlined,
          color: const Color(0xFF007AFF),
        );
      },
      icon: Icons.auto_awesome,
      tooltip: 'Tap me',
      blur: 12,
      opacity: 0.2,
      size: 56,
    ),
  ),
);
