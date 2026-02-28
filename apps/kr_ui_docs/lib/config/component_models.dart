import 'package:flutter/material.dart';

/// Metadata for a single component property
class PropertyInfo {
  final String name;
  final String type;
  final String defaultValue;
  final String description;
  final bool isRequired;

  const PropertyInfo({
    required this.name,
    required this.type,
    required this.defaultValue,
    required this.description,
    this.isRequired = false,
  });
}

/// Metadata for a component preset
class PresetInfo {
  final String name;
  final String description;
  final String code;
  final Widget Function() builder;

  const PresetInfo({
    required this.name,
    required this.description,
    required this.code,
    required this.builder,
  });
}

/// Metadata for a kr_ui component
class ComponentInfo {
  final String id;
  final String name;
  final String displayName;
  final String description;
  final String category;
  final IconData icon;
  final List<PropertyInfo> properties;
  final List<PropertyInfo>? itemProperties;
  final String basicExample;
  final String advancedExample;
  final List<PresetInfo> presets;
  final Widget Function() demoBuilder;
  final String? videoUrl;

  const ComponentInfo({
    required this.id,
    required this.name,
    required this.displayName,
    required this.description,
    required this.category,
    required this.icon,
    required this.properties,
    this.itemProperties,
    required this.basicExample,
    required this.advancedExample,
    required this.presets,
    required this.demoBuilder,
    this.videoUrl,
  });
}
