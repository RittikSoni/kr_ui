import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiRadioInfo = ComponentInfo(
  id: 'radio',
  name: 'KruiRadioGroup',
  displayName: 'Radio Group',
  description:
      'Single-choice radio group with optional label and subtitle per option. Vertical or horizontal layout.',
  category: 'Forms',
  icon: Icons.radio_button_checked_outlined,
  properties: [
    const PropertyInfo(
        name: 'value',
        type: 'T?',
        defaultValue: 'null',
        description: 'Selected value'),
    const PropertyInfo(
        name: 'options',
        type: 'List<KruiRadioOption<T>>',
        defaultValue: 'required',
        description: 'Options',
        isRequired: true),
    const PropertyInfo(
        name: 'onChanged',
        type: 'ValueChanged<T?>',
        defaultValue: 'required',
        description: 'Selection callback',
        isRequired: true),
    const PropertyInfo(
        name: 'label',
        type: 'String?',
        defaultValue: 'null',
        description: 'Group label'),
    const PropertyInfo(
        name: 'direction',
        type: 'Axis',
        defaultValue: 'Axis.vertical',
        description: 'vertical or horizontal'),
  ],
  basicExample: '''KruiRadioGroup<String>(
  label: 'Size',
  options: [
    KruiRadioOption(value: 's', label: 'Small'),
    KruiRadioOption(value: 'm', label: 'Medium'),
    KruiRadioOption(value: 'l', label: 'Large'),
  ],
  value: selected,
  onChanged: (v) => setState(() => selected = v),
)''',
  advancedExample: '''KruiRadioGroup<String>(
  label: 'Plan',
  options: [
    KruiRadioOption(value: 'basic', label: 'Basic', subtitle: '\$5/mo'),
    KruiRadioOption(value: 'pro', label: 'Pro', subtitle: '\$12/mo'),
  ],
  value: selected,
  onChanged: (v) => setState(() => selected = v),
)''',
  presets: [
    PresetInfo(
      name: 'Vertical',
      description: 'Stacked options',
      code: '''KruiRadioGroup<String>(
  label: 'Size',
  options: [
    KruiRadioOption(value: 's', label: 'Small'),
    KruiRadioOption(value: 'm', label: 'Medium'),
    KruiRadioOption(value: 'l', label: 'Large'),
  ],
  value: 'm',
  onChanged: (v) {},
)''',
      builder: () => KruiRadioGroup<String>(
        label: 'Size',
        options: const [
          KruiRadioOption(value: 's', label: 'Small'),
          KruiRadioOption(value: 'm', label: 'Medium'),
          KruiRadioOption(value: 'l', label: 'Large'),
        ],
        value: 'm',
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'With subtitle',
      description: 'Option with subtitle',
      code:
          '''KruiRadioOption(value: 'pro', label: 'Pro', subtitle: '\$12/mo')''',
      builder: () => KruiRadioGroup<String>(
        label: 'Plan',
        options: const [
          KruiRadioOption(value: 'basic', label: 'Basic', subtitle: '\$5/mo'),
          KruiRadioOption(value: 'pro', label: 'Pro', subtitle: '\$12/mo'),
        ],
        value: 'pro',
        onChanged: (_) {},
      ),
    ),
  ],
  demoBuilder: () => KruiRadioGroup<String>(
    label: 'Size',
    options: const [
      KruiRadioOption(value: 's', label: 'Small'),
      KruiRadioOption(value: 'm', label: 'Medium'),
      KruiRadioOption(value: 'l', label: 'Large'),
    ],
    value: 'm',
    onChanged: (_) {},
  ),
);
