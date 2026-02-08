import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiAppBarInfo = ComponentInfo(
  id: 'app-bar',
  name: 'KruiAppBar',
  displayName: 'Modern App Bar',
  description:
      'A sleek, glassmorphic app bar replacement. Features transparent backgrounds, blur effects, and seamless integration with other components like KruiAvatar.',
  category: 'Navigation',
  icon: Icons.web_asset,
  properties: [
    const PropertyInfo(
      name: 'title',
      type: 'Widget?',
      defaultValue: 'null',
      description: 'Title widget (usually Text).',
    ),
    const PropertyInfo(
      name: 'leading',
      type: 'Widget?',
      defaultValue: 'BackButton',
      description: 'Leading widget.',
    ),
    const PropertyInfo(
      name: 'actions',
      type: 'List<Widget>?',
      defaultValue: 'null',
      description: 'List of action widgets.',
    ),
    const PropertyInfo(
      name: 'glass',
      type: 'bool',
      defaultValue: 'true',
      description: 'Enable glassmorphic blur effect.',
    ),
    const PropertyInfo(
      name: 'blurIntensity',
      type: 'double',
      defaultValue: '10.0',
      description: 'Intensity of the blur.',
    ),
    const PropertyInfo(
      name: 'backgroundColor',
      type: 'Color?',
      defaultValue: 'transparent',
      description: 'Background color (overrides default glass tint).',
    ),
  ],
  basicExample: '''Scaffold(
  appBar: KruiAppBar(
    title: Text('Home'),
    actions: [
      IconButton(icon: Icon(Icons.search), onPressed: () {}),
      KruiAvatar(text: 'JD', size: 32),
    ],
  ),
  body: Container(),
)''',
  advancedExample: '''KruiAppBar(
  title: Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
  centerTitle: false,
  glass: true,
  blurIntensity: 15,
  backgroundColor: Colors.black.withValues(alpha: 0.2),
  leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
  actions: [
    KruiSimpleIconButton(icon: Icons.notifications, onPressed: () {}),
    SizedBox(width: 16),
    KruiAvatar(
      image: NetworkImage('https://via.placeholder.com/150'),
      size: 36,
      badgeColor: Colors.green,
    ),
    SizedBox(width: 16),
  ],
)''',
  presets: [
    PresetInfo(
      name: 'Glass Header',
      description: 'Standard glassmorphic app bar',
      code: '''KruiAppBar(
  title: Text('Glass Header'),
  glass: true,
)''',
      builder: () => SizedBox(
        height: 300,
        child: Scaffold(
          appBar: const KruiAppBar(
            title: Text('Glass Header'),
            glass: true,
          ),
          body: Container(color: Colors.blue.shade50),
        ),
      ),
    ),
    PresetInfo(
      name: 'Profile Nav',
      description: 'App bar with user profile action',
      code: '''KruiAppBar(
  title: Text('Welcome Back'),
  actions: [
    KruiAvatar(text: 'US', size: 32, backgroundColor: Colors.purple),
    SizedBox(width: 16),
  ],
)''',
      builder: () => SizedBox(
        height: 300,
        child: Scaffold(
          appBar: KruiAppBar(
            title: const Text('Welcome Back'),
            actions: [
              const KruiAvatar(
                text: 'US',
                size: 32,
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Container(color: Colors.grey.shade100),
        ),
      ),
    ),
  ],
  demoBuilder: () => Container(
    height: 300,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(
            'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?q=80&w=1000'),
        fit: BoxFit.cover,
      ),
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: KruiAppBar(
        title: const Text('Glass AppBar'),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          const KruiAvatar(
            text: 'JD',
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            size: 36,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: const Center(
        child: Text(
          'Scroll me!',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    ),
  ),
);
