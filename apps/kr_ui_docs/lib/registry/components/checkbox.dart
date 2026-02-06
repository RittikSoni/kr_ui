import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiCheckboxInfo = ComponentInfo(
  id: 'checkbox',
  name: 'KruiCheckbox',
  displayName: 'Checkbox',
  description:
      'Checkbox with optional label and subtitle, position (leading/trailing), and tappable link in text (e.g. "I agree to the T&C" with "T&C" as link).',
  category: 'Forms',
  icon: Icons.check_box_outlined,
  properties: [
    const PropertyInfo(
        name: 'value',
        type: 'bool',
        defaultValue: 'required',
        description: 'Checked state',
        isRequired: true),
    const PropertyInfo(
        name: 'onChanged',
        type: 'ValueChanged<bool?>',
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
        name: 'checkboxPosition',
        type: 'KruiCheckboxPosition',
        defaultValue: 'leading',
        description: 'leading or trailing'),
    const PropertyInfo(
        name: 'labelLinkText',
        type: 'String?',
        defaultValue: 'null',
        description: 'Substring in label to make tappable'),
    const PropertyInfo(
        name: 'onLabelLinkTap',
        type: 'VoidCallback?',
        defaultValue: 'null',
        description: 'Called when label link is tapped'),
    const PropertyInfo(
        name: 'activeColor',
        type: 'Color?',
        defaultValue: 'null',
        description: 'Checked color'),
  ],
  basicExample: '''KruiCheckbox(
  label: 'Accept terms',
  value: checked,
  onChanged: (v) => setState(() => checked = v ?? false),
)''',
  advancedExample: '''KruiCheckbox(
  label: 'I agree to the Terms & Conditions',
  labelLinkText: 'Terms & Conditions',
  onLabelLinkTap: () => openUrl('...'),
  value: checked,
  onChanged: (v) => setState(() => checked = v ?? false),
)''',
  presets: [
    PresetInfo(
      name: 'Basic',
      description: 'Label only',
      code: '''KruiCheckbox(
  label: 'Accept terms',
  value: false,
  onChanged: (v) {},
)''',
      builder: () => KruiCheckbox(
        label: 'Accept terms',
        value: false,
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'With subtitle',
      description: 'Label and subtitle',
      code: '''KruiCheckbox(
  label: 'Accept terms',
  subtitle: 'I agree to the terms of service',
  value: false,
  onChanged: (v) {},
)''',
      builder: () => KruiCheckbox(
        label: 'Accept terms',
        subtitle: 'I agree to the terms of service',
        value: false,
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'With link (T&C)',
      description: 'Tappable link in label, e.g. I agree to T&C',
      code: '''KruiCheckbox(
  label: 'I agree to the Terms & Conditions',
  labelLinkText: 'Terms & Conditions',
  onLabelLinkTap: () => launchUrl(termsUrl),
  value: false,
  onChanged: (v) {},
)''',
      builder: () => KruiCheckbox(
        label: 'I agree to the Terms & Conditions',
        labelLinkText: 'Terms & Conditions',
        onLabelLinkTap: () {},
        value: false,
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'Trailing',
      description: 'Checkbox on the right',
      code: '''KruiCheckbox(
  label: 'Accept',
  checkboxPosition: KruiCheckboxPosition.trailing,
  value: false,
  onChanged: (v) {},
)''',
      builder: () => KruiCheckbox(
        label: 'Accept',
        checkboxPosition: KruiCheckboxPosition.trailing,
        value: false,
        onChanged: (_) {},
      ),
    ),
  ],
  demoBuilder: () => KruiCheckbox(
    label: 'I agree to the Terms & Conditions',
    labelLinkText: 'Terms & Conditions',
    onLabelLinkTap: () {},
    value: false,
    onChanged: (_) {},
  ),
);
