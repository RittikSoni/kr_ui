import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiDatePickerInfo = ComponentInfo(
  id: 'date-picker',
  name: 'KruiDatePicker',
  displayName: 'Date Picker',
  description:
      'Trigger that opens the platform date picker. Optional label, hint, and custom display format via KruiDateFormat.',
  category: 'Forms',
  icon: Icons.calendar_today_outlined,
  properties: [
    const PropertyInfo(name: 'value', type: 'DateTime?', defaultValue: 'null', description: 'Selected date'),
    const PropertyInfo(name: 'onDateChanged', type: 'ValueChanged<DateTime>', defaultValue: 'required', description: 'Callback with picked date', isRequired: true),
    const PropertyInfo(name: 'firstDate', type: 'DateTime?', defaultValue: 'null', description: 'Earliest selectable date'),
    const PropertyInfo(name: 'lastDate', type: 'DateTime?', defaultValue: 'null', description: 'Latest selectable date'),
    const PropertyInfo(name: 'label', type: 'String?', defaultValue: 'null', description: 'Label above field'),
    const PropertyInfo(name: 'format', type: 'KruiDateFormat?', defaultValue: 'null', description: 'Display format (e.g. KruiDateFormat(\'yyyy-MM-dd\'))'),
  ],
  basicExample: '''KruiDatePicker(
  label: 'Birth date',
  value: date,
  onDateChanged: (d) => setState(() => date = d),
)''',
  advancedExample: '''KruiDatePicker(
  label: 'Birth date',
  value: date,
  firstDate: DateTime(1900),
  lastDate: DateTime.now(),
  format: KruiDateFormat('yyyy-MM-dd'),
  onDateChanged: (d) => setState(() => date = d),
)''',
  presets: [
    PresetInfo(
      name: 'Basic',
      description: 'Default date picker',
      code: '''KruiDatePicker(
  label: 'Birth date',
  value: date,
  onDateChanged: (d) => setState(() => date = d),
)''',
      builder: () => KruiDatePicker(
        label: 'Birth date',
        value: DateTime(2000, 5, 15),
        onDateChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'With format',
      description: 'Custom display format',
      code: '''KruiDatePicker(
  label: 'Date',
  value: date,
  format: KruiDateFormat('MM/dd/yyyy'),
  onDateChanged: (d) => setState(() => date = d),
)''',
      builder: () => KruiDatePicker(
        label: 'Date',
        value: DateTime(2000, 5, 15),
        format: const KruiDateFormat('MM/dd/yyyy'),
        onDateChanged: (_) {},
      ),
    ),
  ],
  demoBuilder: () => KruiDatePicker(
    label: 'Birth date',
    value: DateTime(2000, 5, 15),
    onDateChanged: (_) {},
  ),
);
