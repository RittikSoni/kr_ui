import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiTimePickerInfo = ComponentInfo(
  id: 'time-picker',
  name: 'KruiTimePicker',
  displayName: 'Time Picker',
  description:
      'Trigger that opens the platform time picker. Optional label and hint.',
  category: 'Forms',
  icon: Icons.schedule_outlined,
  properties: [
    const PropertyInfo(name: 'value', type: 'TimeOfDay?', defaultValue: 'null', description: 'Selected time'),
    const PropertyInfo(name: 'onTimeChanged', type: 'ValueChanged<TimeOfDay>', defaultValue: 'required', description: 'Callback with picked time', isRequired: true),
    const PropertyInfo(name: 'label', type: 'String?', defaultValue: 'null', description: 'Label above field'),
    const PropertyInfo(name: 'hint', type: 'String?', defaultValue: 'null', description: 'Placeholder when empty'),
  ],
  basicExample: '''KruiTimePicker(
  label: 'Meeting time',
  value: time,
  onTimeChanged: (t) => setState(() => time = t),
)''',
  advancedExample: '''KruiTimePicker(
  label: 'Meeting time',
  hint: 'Select time',
  value: time,
  onTimeChanged: (t) => setState(() => time = t),
)''',
  presets: [
    PresetInfo(
      name: 'Basic',
      description: 'Default time picker',
      code: '''KruiTimePicker(
  label: 'Meeting time',
  value: time,
  onTimeChanged: (t) => setState(() => time = t),
)''',
      builder: () => KruiTimePicker(
        label: 'Meeting time',
        value: const TimeOfDay(hour: 14, minute: 30),
        onTimeChanged: (_) {},
      ),
    ),
  ],
  demoBuilder: () => KruiTimePicker(
    label: 'Meeting time',
    value: const TimeOfDay(hour: 14, minute: 30),
    onTimeChanged: (_) {},
  ),
);
