import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiSimpleIconButtonInfo = ComponentInfo(
  id: 'simple-icon-button',
  name: 'KruiSimpleIconButton',
  displayName: 'Simple Icon Button',
  description:
      'A premium minimalist icon button without glass effects. Clean solid or tinted background with haptics and scale animation, matching Simple Button style.',
  category: 'Buttons',
  icon: Icons.touch_app_outlined,
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
      defaultValue: 'Colors.white',
      description: 'Icon color (defaults to white on dark background)',
    ),
    const PropertyInfo(
      name: 'tooltip',
      type: 'String?',
      defaultValue: 'null',
      description: 'Tooltip text when long-pressing',
    ),
    const PropertyInfo(
      name: 'color',
      type: 'Color',
      defaultValue: 'Colors.black',
      description: 'Background color',
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
      defaultValue: 'BorderRadius.circular(14)',
      description: 'Corner radius',
    ),
    const PropertyInfo(
      name: 'enableHaptics',
      type: 'bool',
      defaultValue: 'true',
      description: 'Enable haptic feedback',
    ),
  ],
  basicExample: '''KruiSimpleIconButton(
  onPressed: () => print('Tapped'),
  icon: Icons.add,
)''',
  advancedExample: '''KruiSimpleIconButton(
  onPressed: () {},
  icon: Icons.settings,
  iconSize: 22,
  tooltip: 'Settings',
  color: Colors.blue,
  iconColor: Colors.white,
  size: 52,
)''',
  presets: [
    PresetInfo(
      name: 'Default',
      description: 'Classic minimalist black icon button',
      code: '''KruiSimpleIconButton(
  onPressed: () {},
  icon: Icons.add,
)''',
      builder: () => KruiSimpleIconButton(
        onPressed: () {},
        icon: Icons.add,
      ),
    ),
    PresetInfo(
      name: 'With tooltip',
      description: 'Icon button with tooltip',
      code: '''KruiSimpleIconButton(
  onPressed: () {},
  icon: Icons.settings,
  tooltip: 'Settings',
)''',
      builder: () => KruiSimpleIconButton(
        onPressed: () {},
        icon: Icons.settings,
        tooltip: 'Settings',
      ),
    ),
    PresetInfo(
      name: 'Light',
      description: 'White/light background',
      code: '''KruiSimpleIconButton(
  onPressed: () {},
  icon: Icons.add,
  color: Colors.white,
  iconColor: Colors.black,
)''',
      builder: () => KruiSimpleIconButton(
        onPressed: () {},
        icon: Icons.add,
        color: Colors.white,
        iconColor: Colors.black,
      ),
    ),
    PresetInfo(
      name: 'Row of actions',
      description: 'Multiple simple icon buttons',
      code: '''Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    KruiSimpleIconButton(onPressed: () {}, icon: Icons.share, tooltip: 'Share'),
    SizedBox(width: 8),
    KruiSimpleIconButton(onPressed: () {}, icon: Icons.edit, tooltip: 'Edit', color: Color(0xFF007AFF)),
    SizedBox(width: 8),
    KruiSimpleIconButton(onPressed: () {}, icon: Icons.delete_outline, tooltip: 'Delete', color: Color(0xFFFF3B30)),
  ],
)''',
      builder: () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          KruiSimpleIconButton(
            onPressed: () {},
            icon: Icons.share,
            tooltip: 'Share',
          ),
          const SizedBox(width: 8),
          KruiSimpleIconButton(
            onPressed: () {},
            icon: Icons.edit,
            tooltip: 'Edit',
            color: const Color(0xFF007AFF),
          ),
          const SizedBox(width: 8),
          KruiSimpleIconButton(
            onPressed: () {},
            icon: Icons.delete_outline,
            tooltip: 'Delete',
            color: const Color(0xFFFF3B30),
          ),
        ],
      ),
    ),
  ],
  demoBuilder: () => Center(
    child: KruiSimpleIconButton(
      onPressed: () {
        KruiToast.show(
          message: 'Simple icon button tapped!',
          icon: Icons.touch_app_outlined,
          color: Colors.black,
        );
      },
      icon: Icons.touch_app,
      tooltip: 'Tap me',
      size: 56,
    ),
  ),
);
