import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiSelectInfo = ComponentInfo(
  id: 'select',
  name: 'KruiSelect',
  displayName: 'Select',
  description:
      'Dropdown with optional search and categorizable options. Single selection, scrollable list, theme-aware.',
  category: 'Forms',
  icon: Icons.arrow_drop_down_circle_outlined,
  properties: [
    const PropertyInfo(name: 'value', type: 'T?', defaultValue: 'null', description: 'Selected value'),
    const PropertyInfo(name: 'options', type: 'List<KruiSelectOption<T>>', defaultValue: 'required', description: 'Options list', isRequired: true),
    const PropertyInfo(name: 'onChanged', type: 'ValueChanged<T?>', defaultValue: 'required', description: 'Selection callback', isRequired: true),
    const PropertyInfo(name: 'label', type: 'String?', defaultValue: 'null', description: 'Label above field'),
    const PropertyInfo(name: 'searchable', type: 'bool', defaultValue: 'false', description: 'Show search input'),
    const PropertyInfo(name: 'hint', type: 'String?', defaultValue: 'null', description: 'Placeholder when empty'),
  ],
  basicExample: '''KruiSelect<String>(
  label: 'Country',
  options: [
    KruiSelectOption(value: 'us', label: 'United States'),
    KruiSelectOption(value: 'uk', label: 'United Kingdom'),
  ],
  onChanged: (v) {},
)''',
  advancedExample: '''KruiSelect<String>(
  label: 'Fruit',
  searchable: true,
  options: [
    KruiSelectOption(value: 'a', label: 'Apple', category: 'Fruits'),
    KruiSelectOption(value: 'b', label: 'Broccoli', category: 'Vegetables'),
  ],
  onChanged: (v) {},
)''',
  presets: [
    PresetInfo(
      name: 'Basic',
      description: 'Simple dropdown',
      code: '''KruiSelect<String>(
  label: 'Country',
  options: [KruiSelectOption(value: 'us', label: 'United States'), ...],
  onChanged: (v) {},
)''',
      builder: () => KruiSelect<String>(
        label: 'Country',
        options: const [
          KruiSelectOption(value: 'us', label: 'United States'),
          KruiSelectOption(value: 'uk', label: 'United Kingdom'),
          KruiSelectOption(value: 'de', label: 'Germany'),
        ],
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'Searchable',
      description: 'Filter options by typing',
      code: '''KruiSelect<String>(
  label: 'Country',
  searchable: true,
  options: [...],
  onChanged: (v) {},
)''',
      builder: () => KruiSelect<String>(
        label: 'Country',
        searchable: true,
        hint: 'Select country',
        options: const [
          KruiSelectOption(value: 'us', label: 'United States'),
          KruiSelectOption(value: 'uk', label: 'United Kingdom'),
          KruiSelectOption(value: 'de', label: 'Germany'),
        ],
        onChanged: (_) {},
      ),
    ),
    PresetInfo(
      name: 'Categorizable',
      description: 'Options with category headers',
      code: '''KruiSelect<String>(
  label: 'Item',
  options: [
    KruiSelectOption(value: 'apple', label: 'Apple', category: 'Fruits'),
    KruiSelectOption(value: 'broccoli', label: 'Broccoli', category: 'Vegetables'),
  ],
  onChanged: (v) {},
)''',
      builder: () => KruiSelect<String>(
        label: 'Choose item',
        options: const [
          KruiSelectOption(value: 'apple', label: 'Apple', category: 'Fruits'),
          KruiSelectOption(value: 'banana', label: 'Banana', category: 'Fruits'),
          KruiSelectOption(value: 'broccoli', label: 'Broccoli', category: 'Vegetables'),
        ],
        onChanged: (_) {},
      ),
    ),
  ],
  demoBuilder: () => KruiSelect<String>(
    label: 'Country',
    searchable: true,
    options: const [
      KruiSelectOption(value: 'us', label: 'United States'),
      KruiSelectOption(value: 'uk', label: 'United Kingdom'),
    ],
    onChanged: (_) {},
  ),
);
