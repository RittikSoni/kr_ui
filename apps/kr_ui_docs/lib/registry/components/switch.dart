import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiSwitchInfo = ComponentInfo(
  id: 'switch',
  name: 'KruiSwitch',
  displayName: 'Switch',
  description:
      'Toggle switch with optional label and subtitle, position (leading/trailing), and colors (active/inactive track and thumb).',
  category: 'Forms',
  icon: Icons.toggle_on_outlined,
  properties: [
    const PropertyInfo(
        name: 'value',
        type: 'bool',
        defaultValue: 'required',
        description: 'On/off state',
        isRequired: true),
    const PropertyInfo(
        name: 'onChanged',
        type: 'ValueChanged<bool>',
        defaultValue: 'required',
        description: 'Callback when toggled',
        isRequired: true),
    const PropertyInfo(
        name: 'label',
        type: 'String?',
        defaultValue: 'null',
        description: 'Label text'),
    const PropertyInfo(
        name: 'subtitle',
        type: 'String?',
        defaultValue: 'null',
        description: 'Secondary text'),
    const PropertyInfo(
        name: 'switchPosition',
        type: 'KruiSwitchPosition',
        defaultValue: 'trailing',
        description: 'leading or trailing'),
    const PropertyInfo(
        name: 'activeTrackColor',
        type: 'Color?',
        defaultValue: 'null',
        description: 'Track color when on'),
    const PropertyInfo(
        name: 'activeThumbColor',
        type: 'Color?',
        defaultValue: 'null',
        description: 'Thumb color when on'),
    const PropertyInfo(
        name: 'inactiveTrackColor',
        type: 'Color?',
        defaultValue: 'null',
        description: 'Track color when off'),
    const PropertyInfo(
        name: 'inactiveThumbColor',
        type: 'Color?',
        defaultValue: 'null',
        description: 'Thumb color when off'),
  ],
  basicExample: '''KruiSwitch(
  label: 'Notifications',
  value: on,
  onChanged: (v) => setState(() => on = v),
)''',
  advancedExample: '''KruiSwitch(
  label: 'Dark mode',
  switchPosition: KruiSwitchPosition.leading,
  activeTrackColor: Colors.indigo.withValues(alpha:0.5),
  activeThumbColor: Colors.indigo,
  value: on,
  onChanged: (v) => setState(() => on = v),
)''',
  presets: [
    PresetInfo(
      name: 'Basic',
      description: 'Label only',
      code: '''KruiSwitch(
  label: 'Notifications',
  value: true,
  onChanged: (v) {},
)''',
      builder: () => KruiSwitch(
        label: 'Notifications',
        value: true,
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'With subtitle',
      description: 'Label and subtitle',
      code: '''KruiSwitch(
  label: 'Notifications',
  subtitle: 'Receive push notifications',
  value: true,
  onChanged: (v) {},
)''',
      builder: () => KruiSwitch(
        label: 'Notifications',
        subtitle: 'Receive push notifications',
        value: true,
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'Leading',
      description: 'Switch on the left',
      code: '''KruiSwitch(
  label: 'Enabled',
  switchPosition: KruiSwitchPosition.leading,
  value: true,
  onChanged: (v) {},
)''',
      builder: () => KruiSwitch(
        label: 'Enabled',
        switchPosition: KruiSwitchPosition.leading,
        value: true,
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'Custom colors',
      description: 'Custom active track and thumb colors',
      code: '''KruiSwitch(
  label: 'Dark mode',
  activeTrackColor: Colors.indigo.withValues(alpha:0.5),
  activeThumbColor: Colors.indigo,
  value: true,
  onChanged: (v) {},
)''',
      builder: () => KruiSwitch(
        label: 'Dark mode',
        activeTrackColor: Colors.indigo.withValues(alpha: 0.5),
        activeThumbColor: Colors.indigo,
        value: true,
        onChanged: (_) {},
      ),
    ),
  ],
  demoBuilder: () => KruiSwitch(
    label: 'Notifications',
    value: true,
    onChanged: (_) {},
  ),
);
