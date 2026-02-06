import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiFormInfo = ComponentInfo(
  id: 'form',
  name: 'KruiForm',
  displayName: 'Form',
  description:
      'Form container with KruiFormController: single source of truth for initial values, current state, and errors. Link fields by a shared key: use the same string in initialValues, in KruiTextField name/id, and in getValue/setValue/validate. Text fields bind automatically via name or id; other controls wire value and onChanged from the controller.',
  category: 'Forms',
  icon: Icons.edit_note_outlined,
  properties: [
    const PropertyInfo(
      name: 'controller',
      type: 'KruiFormController',
      defaultValue: 'required',
      description: 'Form state: values, errors, getTextController, validate, reset.',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'child',
      type: 'Widget',
      defaultValue: 'required',
      description: 'Form content (fields and buttons).',
      isRequired: true,
    ),
  ],
  basicExample: '''// 1. Same key everywhere: initialValues, name/id, getValue, validate
final controller = KruiFormController(
  initialValues: {'email': '', 'country': 'us'},
);

KruiForm(
  controller: controller,
  child: Column(
    children: [
      KruiTextField(name: 'email', label: 'Email'),
      KruiSelect<String>(
        label: 'Country',
        value: controller.getValue('country'),
        onChanged: (v) => controller.setValue('country', v),
        options: [KruiSelectOption(value: 'us', label: 'US'), ...],
      ),
      ElevatedButton(
        onPressed: () {
          if (controller.validate({'email': (v) => (v as String?)?.isEmpty == true ? 'Required' : null})) {
            print(controller.values);
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
)''',
  advancedExample: '''// Linking: use one key per field (name or id). Same key in:
// - initialValues['email'], validate({'email': ...})
// - KruiTextField(name: 'email') or KruiTextField(id: 'email')
// - controller.getValue('email'), controller.setValue('email', v)

final controller = KruiFormController(initialValues: {
  'email': 'user@example.com',
  'country': 'us',
  'terms': false,
});

if (controller.validate({
  'email': (v) => (v as String?)?.isEmpty == true ? 'Required' : null,
  'terms': (v) => v != true ? 'You must accept terms' : null,
})) {
  final data = controller.values;
  await api.submit(data);
}
controller.reset();''',
  presets: [
    PresetInfo(
      name: 'Link by name or id',
      description: 'Use name or id as the form field key; same key in initialValues and validate',
      code: '''// Field key = id ?? name. Use the same key everywhere.
final c = KruiFormController(initialValues: {'email': '', 'fullName': ''});

KruiForm(
  controller: c,
  child: Column(
    children: [
      KruiTextField(name: 'email', label: 'Email'),
      KruiTextField(id: 'fullName', label: 'Full name'),
      ElevatedButton(
        onPressed: () {
          if (c.validate({
            'email': (v) => (v as String?)?.isEmpty == true ? 'Required' : null,
            'fullName': (v) => (v as String?)?.isEmpty == true ? 'Required' : null,
          })) print(c.values);
        },
        child: Text('Submit'),
      ),
    ],
  ),
)''',
      builder: () => const _LinkByNameOrIdDemo(),
    ),
    PresetInfo(
      name: 'Sign-up (real-world)',
      description: 'Initial values, validation, submit and reset',
      code: '''final controller = KruiFormController(initialValues: {
  'email': '',
  'password': '',
  'country': 'us',
  'terms': false,
});

KruiForm(
  controller: controller,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      KruiTextField(name: 'email', label: 'Email', validation: KruiTextFieldValidation.email),
      KruiTextField(name: 'password', label: 'Password', obscureText: true),
      KruiSelect<String>(
        label: 'Country',
        value: controller.getValue('country'),
        onChanged: (v) => controller.setValue('country', v),
        options: [KruiSelectOption(value: 'us', label: 'United States'), ...],
      ),
      KruiCheckbox(
        value: controller.getValue('terms') == true,
        onChanged: (v) => controller.setValue('terms', v),
        label: 'I agree to the Terms',
      ),
      SizedBox(height: 16),
      Row(
        children: [
          Expanded(child: OutlinedButton(onPressed: () => controller.reset(), child: Text('Reset'))),
          SizedBox(width: 12),
          Expanded(child: ElevatedButton(
            onPressed: () {
              if (controller.validate({
                'email': (v) => (v as String?)?.isEmpty == true ? 'Required' : null,
                'terms': (v) => v != true ? 'Accept terms' : null,
              })) {
                // submit: use controller.values
              }
            },
            child: Text('Submit'),
          )),
        ],
      ),
    ],
  ),
)''',
      builder: () => const _SignUpFormDemo(),
    ),
    PresetInfo(
      name: 'Initial values only',
      description: 'Pre-filled form with controller',
      code: '''final controller = KruiFormController(initialValues: {
  'email': 'hello@example.com',
  'name': 'Jane',
});

KruiForm(
  controller: controller,
  child: Column(
    children: [
      KruiTextField(name: 'email', label: 'Email'),
      KruiTextField(name: 'name', label: 'Name'),
    ],
  ),
)''',
      builder: () => const _InitialValuesFormDemo(),
    ),
  ],
  demoBuilder: () => const _SignUpFormDemo(),
);

/// Demo: link fields by name or id; same key in initialValues and validate.
class _LinkByNameOrIdDemo extends StatefulWidget {
  const _LinkByNameOrIdDemo();

  @override
  State<_LinkByNameOrIdDemo> createState() => _LinkByNameOrIdDemoState();
}

class _LinkByNameOrIdDemoState extends State<_LinkByNameOrIdDemo> {
  late final KruiFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = KruiFormController(initialValues: {'email': '', 'fullName': ''});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KruiForm(
      controller: _controller,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              KruiTextField(name: 'email', label: 'Email'),
              const SizedBox(height: 16),
              KruiTextField(id: 'fullName', label: 'Full name'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_controller.validate({
                    'email': (v) => (v as String?)?.isEmpty == true ? 'Required' : null,
                    'fullName': (v) => (v as String?)?.isEmpty == true ? 'Required' : null,
                  })) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Values: ${_controller.values}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Real-world sign-up form: initial values, validation, submit, reset.
class _SignUpFormDemo extends StatefulWidget {
  const _SignUpFormDemo();

  @override
  State<_SignUpFormDemo> createState() => _SignUpFormDemoState();
}

class _SignUpFormDemoState extends State<_SignUpFormDemo> {
  late final KruiFormController _controller;

  static const _countryOptions = [
    KruiSelectOption(value: 'us', label: 'United States'),
    KruiSelectOption(value: 'uk', label: 'United Kingdom'),
    KruiSelectOption(value: 'de', label: 'Germany'),
    KruiSelectOption(value: 'in', label: 'India'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = KruiFormController(initialValues: {
      'email': '',
      'password': '',
      'country': 'us',
      'terms': false,
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final validators = <String, KruiFormValidator>{
      'email': (v) {
        final s = v as String?;
        if (s == null || s.trim().isEmpty) return 'Email is required';
        if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(s)) return 'Enter a valid email';
        return null;
      },
      'password': (v) {
        final s = v as String?;
        if (s == null || s.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
      'terms': (v) => v == true ? null : 'You must accept the terms',
    };
    if (_controller.validate(validators)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Submitted: ${_controller.values}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KruiForm(
      controller: _controller,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                KruiTextField(
                  name: 'email',
                  label: 'Email',
                  hint: 'you@example.com',
                  validation: KruiTextFieldValidation.email,
                ),
                const SizedBox(height: 16),
                KruiTextField(
                  name: 'password',
                  label: 'Password',
                  hint: 'Min 6 characters',
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                KruiSelect<String>(
                  label: 'Country',
                  value: _controller.getValue('country') as String?,
                  onChanged: (v) => _controller.setValue('country', v),
                  options: _countryOptions,
                ),
                const SizedBox(height: 12),
                KruiCheckbox(
                  value: _controller.getValue('terms') == true,
                  onChanged: (v) => _controller.setValue('terms', v),
                  label: 'I agree to the Terms & Conditions',
                  labelLinkText: 'Terms & Conditions',
                  onLabelLinkTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Open T&C'), behavior: SnackBarBehavior.floating),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _controller.reset(),
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Minimal form with initial values only.
class _InitialValuesFormDemo extends StatefulWidget {
  const _InitialValuesFormDemo();

  @override
  State<_InitialValuesFormDemo> createState() => _InitialValuesFormDemoState();
}

class _InitialValuesFormDemoState extends State<_InitialValuesFormDemo> {
  late final KruiFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = KruiFormController(initialValues: {
      'email': 'hello@example.com',
      'name': 'Jane',
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KruiForm(
      controller: _controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          KruiTextField(name: 'email', label: 'Email'),
          const SizedBox(height: 16),
          KruiTextField(name: 'name', label: 'Name'),
          const SizedBox(height: 12),
          Text(
            'Current: ${_controller.values}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
