import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiMultiSelectInfo = ComponentInfo(
  id: 'multi-select',
  name: 'KruiMultiSelect',
  displayName: 'Multi Select',
  description:
      'Multiple selection dropdown with optional search and categorizable options. Show selected as chips or count.',
  category: 'Forms',
  icon: Icons.checklist_outlined,
  properties: [
    const PropertyInfo(
        name: 'value',
        type: 'List<T>',
        defaultValue: '[]',
        description: 'Selected values'),
    const PropertyInfo(
        name: 'options',
        type: 'List<KruiSelectOption<T>>',
        defaultValue: 'required',
        description: 'Options list',
        isRequired: true),
    const PropertyInfo(
        name: 'onChanged',
        type: 'ValueChanged<List<T>>',
        defaultValue: 'required',
        description: 'Selection callback',
        isRequired: true),
    const PropertyInfo(
        name: 'showChips',
        type: 'bool',
        defaultValue: 'false',
        description: 'Show selected as chips'),
    const PropertyInfo(
        name: 'searchable',
        type: 'bool',
        defaultValue: 'false',
        description: 'Show search input'),
  ],
  basicExample: '''KruiMultiSelect<String>(
  label: 'Tags',
  options: [
    KruiSelectOption(value: 'flutter', label: 'Flutter'),
    KruiSelectOption(value: 'dart', label: 'Dart'),
  ],
  value: selected,
  onChanged: (v) => setState(() => selected = v),
)''',
  advancedExample: '''KruiMultiSelect<String>(
  label: 'Tags',
  showChips: true,
  searchable: true,
  options: [...],
  value: selected,
  onChanged: (v) => setState(() => selected = v),
)''',
  presets: [
    PresetInfo(
      name: 'Basic',
      description: 'Multiple selection',
      code: '''KruiMultiSelect<String>(
  label: 'Tags',
  options: [...],
  value: [],
  onChanged: (v) {},
)''',
      builder: () => KruiMultiSelect<String>(
        label: 'Tags',
        options: const [
          KruiSelectOption(value: 'flutter', label: 'Flutter'),
          KruiSelectOption(value: 'dart', label: 'Dart'),
          KruiSelectOption(value: 'ui', label: 'UI'),
        ],
        value: const [],
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'With chips',
      description: 'Selected items as chips',
      code: '''KruiMultiSelect<String>(
  label: 'Tags',
  showChips: true,
  options: [...],
  value: selected,
  onChanged: (v) => setState(() => selected = v),
)''',
      builder: () => KruiMultiSelect<String>(
        label: 'Tags',
        showChips: true,
        options: const [
          KruiSelectOption(value: 'flutter', label: 'Flutter'),
          KruiSelectOption(value: 'dart', label: 'Dart'),
          KruiSelectOption(value: 'ui', label: 'UI'),
        ],
        value: const ['flutter'],
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'Searchable',
      description: 'Filter options by typing',
      code: '''KruiMultiSelect<String>(
  label: 'Tags',
  searchable: true,
  showChips: true,
  options: [...],
  value: selected,
  onChanged: (v) => setState(() => selected = v),
)''',
      builder: () => KruiMultiSelect<String>(
        label: 'Tags',
        searchable: true,
        showChips: true,
        searchHint: 'Search tags...',
        options: const [
          KruiSelectOption(value: 'flutter', label: 'Flutter'),
          KruiSelectOption(value: 'dart', label: 'Dart'),
          KruiSelectOption(value: 'ui', label: 'UI'),
          KruiSelectOption(value: 'widgets', label: 'Widgets'),
        ],
        value: const [],
        onChanged: (_) {},
      ),
    ),
  ],
  demoBuilder: () => KruiMultiSelect<String>(
    label: 'Tags',
    searchable: true,
    showChips: true,
    options: const [
      KruiSelectOption(value: 'flutter', label: 'Flutter'),
      KruiSelectOption(value: 'dart', label: 'Dart'),
    ],
    value: const [],
    onChanged: (_) {},
  ),
);
