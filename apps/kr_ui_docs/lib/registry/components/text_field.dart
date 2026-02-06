import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiTextFieldInfo = ComponentInfo(
  id: 'text-field',
  name: 'KruiTextField',
  displayName: 'Text Field',
  description:
      'Modern text input with label, hint, error, and built-in validation. Inside KruiForm, use name or id to link to the form (same key as in initialValues and validate). Optional colors and prefix/suffix.',
  category: 'Forms',
  icon: Icons.text_fields_outlined,
  properties: [
    const PropertyInfo(
        name: 'name',
        type: 'String?',
        defaultValue: 'null',
        description:
            'Form field key when inside KruiForm (links to controller)'),
    const PropertyInfo(
        name: 'id',
        type: 'String?',
        defaultValue: 'null',
        description: 'Form field key alias; if set, used instead of name'),
    const PropertyInfo(
        name: 'label',
        type: 'String?',
        defaultValue: 'null',
        description: 'Label above the field'),
    const PropertyInfo(
        name: 'hint',
        type: 'String?',
        defaultValue: 'null',
        description: 'Placeholder text'),
    const PropertyInfo(
        name: 'errorText',
        type: 'String?',
        defaultValue: 'null',
        description: 'Error message (overrides validator result)'),
    const PropertyInfo(
        name: 'validator',
        type: 'String? Function(String?)?',
        defaultValue: 'null',
        description: 'Custom validator; return error string or null'),
    const PropertyInfo(
        name: 'autovalidate',
        type: 'bool',
        defaultValue: 'true',
        description: 'Run validator on every change when validator is set'),
    const PropertyInfo(
        name: 'validation',
        type: 'KruiTextFieldValidation',
        defaultValue: 'none',
        description: 'email, password, url, number, phone, custom'),
    const PropertyInfo(
        name: 'obscureText',
        type: 'bool',
        defaultValue: 'false',
        description: 'Hide text (password)'),
    const PropertyInfo(
        name: 'labelColor',
        type: 'Color?',
        defaultValue: 'null',
        description: 'Label text color'),
    const PropertyInfo(
        name: 'fillColor',
        type: 'Color?',
        defaultValue: 'null',
        description: 'Background color'),
    const PropertyInfo(
        name: 'focusBorderColor',
        type: 'Color?',
        defaultValue: 'null',
        description: 'Border color when focused'),
  ],
  basicExample: '''KruiTextField(
  label: 'Email',
  hint: 'you@example.com',
  validation: KruiTextFieldValidation.email,
  onChanged: (v) {},
)''',
  advancedExample: '''KruiTextField(
  label: 'Email',
  validation: KruiTextFieldValidation.email,
  validator: (v) => v?.isEmpty == true ? 'Required' : null,
  autovalidate: true,
  onChanged: (v) {},
)''',
  presets: [
    PresetInfo(
      name: 'Email',
      description: 'Email validation',
      code: '''KruiTextField(
  label: 'Email',
  validation: KruiTextFieldValidation.email,
  onChanged: (v) {},
)''',
      builder: () => KruiTextField(
        label: 'Email',
        hint: 'you@example.com',
        validation: KruiTextFieldValidation.email,
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'Password',
      description: 'Obscured with visibility toggle',
      code: '''KruiTextField(
  label: 'Password',
  obscureText: true,
  onChanged: (v) {},
)''',
      builder: () => KruiTextField(
        label: 'Password',
        obscureText: true,
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'With error',
      description: 'Error state',
      code: '''KruiTextField(
  label: 'Email',
  errorText: 'Enter a valid email',
  onChanged: (v) {},
)''',
      builder: () => KruiTextField(
        label: 'Email',
        errorText: 'Enter a valid email',
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'Custom validator',
      description: 'Validator runs on change, shows error automatically',
      code: '''KruiTextField(
  label: 'Username',
  hint: 'Min 3 characters',
  validator: (v) => v != null && v.length < 3 ? 'Min 3 characters' : null,
  autovalidate: true,
  onChanged: (v) {},
)''',
      builder: () => KruiTextField(
        label: 'Username',
        hint: 'Min 3 characters',
        validator: (v) => v != null && v.length < 3 ? 'Min 3 characters' : null,
        autovalidate: true,
        onChanged: (_) {},
      ),
    ),
  ],
  demoBuilder: () => KruiTextField(
    label: 'Email',
    hint: 'you@example.com',
    validation: KruiTextFieldValidation.email,
    onChanged: (_) {},
  ),
);
