import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final ComponentInfo kruiFloatingDockInfo = ComponentInfo(
  id: 'floating-dock',
  name: 'KruiFloatingDock',
  displayName: 'Floating Dock',
  description:
      'macOS/iOS-style floating dock with spring physics, magnetic scaling, and tooltips on hover.',
  category: 'Navigation',
  icon: Icons.dock,
  properties: const [
    PropertyInfo(
      name: 'items',
      type: 'List<KruiFloatingDockItem>',
      defaultValue: 'required',
      description: 'List of dock items to display.',
    ),
    PropertyInfo(
      name: 'position',
      type: 'FloatingDockPosition',
      defaultValue: 'bottom',
      description: 'Dock position on screen (top, bottom, left, right).',
    ),
    PropertyInfo(
      name: 'height',
      type: 'double',
      defaultValue: '70',
      description: 'Dock height.',
    ),
    PropertyInfo(
      name: 'spacing',
      type: 'double',
      defaultValue: '12',
      description: 'Spacing between icons.',
    ),
    PropertyInfo(
      name: 'iconSize',
      type: 'double',
      defaultValue: '28',
      description: 'Base icon size before scaling.',
    ),
    PropertyInfo(
      name: 'maxScale',
      type: 'double',
      defaultValue: '1.4',
      description: 'Maximum scale factor on hover.',
    ),
    PropertyInfo(
      name: 'usePositioning',
      type: 'bool',
      defaultValue: 'false',
      description: 'Wrap in Positioned (true for Stack, false for Scaffold).',
    ),
    PropertyInfo(
      name: 'blurIntensity',
      type: 'double',
      defaultValue: '10',
      description: 'Background blur intensity.',
    ),
  ],
  itemProperties: const [
    PropertyInfo(
      name: 'icon',
      type: 'IconData',
      defaultValue: 'required',
      description: 'Icon to display in the dock.',
    ),
    PropertyInfo(
      name: 'label',
      type: 'String?',
      defaultValue: 'null',
      description: 'Tooltip text shown on hover (uses Flutter Tooltip).',
    ),
    PropertyInfo(
      name: 'onTap',
      type: 'VoidCallback?',
      defaultValue: 'null',
      description: 'Callback when item is tapped.',
    ),
    PropertyInfo(
      name: 'backgroundColor',
      type: 'Color?',
      defaultValue: 'null',
      description: 'Background color for this item.',
    ),
    PropertyInfo(
      name: 'iconColor',
      type: 'Color?',
      defaultValue: 'null',
      description: 'Icon color override.',
    ),
    PropertyInfo(
      name: 'showBorder',
      type: 'bool',
      defaultValue: 'false',
      description: 'Whether to show a border around the item.',
    ),
  ],
  basicExample: '''KruiFloatingDock(
  items: [
    KruiFloatingDockItem(icon: Icons.home, onTap: () {}),
    KruiFloatingDockItem(icon: Icons.search, onTap: () {}),
    KruiFloatingDockItem(icon: Icons.favorite, onTap: () {}),
  ],
)''',
  advancedExample: '''KruiFloatingDock(
  position: FloatingDockPosition.bottom,
  height: 80,
  spacing: 16,
  maxScale: 1.6,
  blurIntensity: 15,
  items: [
    KruiFloatingDockItem(
      icon: Icons.home,
      backgroundColor: Colors.blue.withValues(alpha: 0.2),
      onTap: () => navigate('/'),
    ),
    KruiFloatingDockItem(
      icon: Icons.search,
      showBorder: true,
      onTap: () => openSearch(),
    ),
    KruiFloatingDockItem(
      icon: Icons.settings,
      iconColor: Colors.purple,
      onTap: () => openSettings(),
    ),
  ],
)''',
  presets: [
    PresetInfo(
      name: 'Quick Actions',
      description: 'Bottom dock with common actions',
      code: '''KruiFloatingDock(
  items: [
    KruiFloatingDockItem(icon: Icons.home, onTap: () {}),
    KruiFloatingDockItem(icon: Icons.search, onTap: () {}),
    KruiFloatingDockItem(icon: Icons.add_circle, onTap: () {}),
    KruiFloatingDockItem(icon: Icons.notifications, onTap: () {}),
    KruiFloatingDockItem(icon: Icons.person, onTap: () {}),
  ],
);''',
      builder: () {
        return Center(
          child: Container(
            height: 300,
            width: double.infinity,
            color: Colors.grey.shade900,
            child: Stack(
              children: [
                const Center(
                  child: Text(
                    'Your App Content',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                KruiFloatingDock(
                  usePositioning: true,
                  items: [
                    KruiFloatingDockItem(
                      icon: Icons.home,
                      label: 'Home',
                      onTap: () {},
                    ),
                    KruiFloatingDockItem(
                      icon: Icons.search,
                      label: 'Search',
                      onTap: () {},
                    ),
                    KruiFloatingDockItem(
                      icon: Icons.add_circle,
                      label: 'Create',
                      onTap: () {},
                    ),
                    KruiFloatingDockItem(
                      icon: Icons.notifications,
                      label: 'Alerts',
                      onTap: () {},
                    ),
                    KruiFloatingDockItem(
                      icon: Icons.person,
                      label: 'Profile',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
    PresetInfo(
      name: 'Social Media',
      description: 'Colorful dock with social actions',
      code: '''KruiFloatingDock(
  maxScale: 1.6,
  items: [
    KruiFloatingDockItem(icon: Icons.home, onTap: () {}),
    KruiFloatingDockItem(icon: Icons.favorite, onTap: () {}),
    KruiFloatingDockItem(icon: Icons.camera_alt, onTap: () {}),
    KruiFloatingDockItem(icon: Icons.message, onTap: () {}),
  ],
);''',
      builder: () {
        return Center(
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade800, Colors.blue.shade800],
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Text(
                    'Feed',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                KruiFloatingDock(
                  usePositioning: true,
                  maxScale: 1.6,
                  items: [
                    KruiFloatingDockItem(
                      icon: Icons.home,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      onTap: () {},
                    ),
                    KruiFloatingDockItem(
                      icon: Icons.favorite,
                      backgroundColor: Colors.red.withValues(alpha: 0.2),
                      iconColor: Colors.red.shade300,
                      onTap: () {},
                    ),
                    KruiFloatingDockItem(
                      icon: Icons.camera_alt,
                      backgroundColor: Colors.blue.withValues(alpha: 0.2),
                      onTap: () {},
                    ),
                    KruiFloatingDockItem(
                      icon: Icons.message,
                      backgroundColor: Colors.green.withValues(alpha: 0.2),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
    PresetInfo(
      name: 'Side Dock',
      description: 'Right-side positioned dock',
      code: '''KruiFloatingDock(
  position: FloatingDockPosition.right,
  height: 60,
  items: [
    KruiFloatingDockItem(icon: Icons.dashboard, onTap: () {}),
    KruiFloatingDockItem(icon: Icons.folder, onTap: () {}),
    KruiFloatingDockItem(icon: Icons.settings, onTap: () {}),
  ],
);''',
      builder: () {
        return Center(
          child: Container(
            height: 400,
            width: double.infinity,
            color: Colors.blueGrey.shade900,
            child: Stack(
              children: [
                const Center(
                  child: Text(
                    'Desktop App',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                KruiFloatingDock(
                  position: FloatingDockPosition.right,
                  height: 60,
                  usePositioning: true,
                  items: [
                    KruiFloatingDockItem(icon: Icons.dashboard, onTap: () {}),
                    KruiFloatingDockItem(icon: Icons.folder, onTap: () {}),
                    KruiFloatingDockItem(icon: Icons.settings, onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
    PresetInfo(
      name: 'Scaffold Integration',
      description:
          'Use in Scaffold floatingActionButton (usePositioning: false)',
      code: '''// In Scaffold, set usePositioning: false (default)
Scaffold(
  appBar: AppBar(title: Text('App')),
  floatingActionButton: KruiFloatingDock(
    items: [
      KruiFloatingDockItem(icon: Icons.home, onTap: () {}),
      KruiFloatingDockItem(icon: Icons.add, onTap: () {}),
      KruiFloatingDockItem(icon: Icons.person, onTap: () {}),
    ],
  ),
);

// In Stack, set usePositioning: true
Stack(
  children: [
    YourContent(),
    KruiFloatingDock(
      usePositioning: true,
      items: [...],
    ),
  ],
);''',
      builder: () {
        return Container(
          height: 300,
          width: double.infinity,
          color: Colors.grey.shade900,
          child: Stack(
            children: [
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.widgets, size: 64, color: Colors.white24),
                    SizedBox(height: 16),
                    Text(
                      'Content Area',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'In Scaffold: usePositioning = false (default)',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                    Text(
                      'In Stack: usePositioning = true',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Demo with Stack (usePositioning: true)
              KruiFloatingDock(
                usePositioning: true,
                items: [
                  KruiFloatingDockItem(
                    icon: Icons.home,
                    label: 'Home',
                    onTap: () {},
                  ),
                  KruiFloatingDockItem(
                    icon: Icons.add_circle,
                    label: 'Add',
                    onTap: () {},
                  ),
                  KruiFloatingDockItem(
                    icon: Icons.person,
                    label: 'Profile',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  ],
  demoBuilder: () {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo.shade900, Colors.purple.shade900],
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.apps, size: 64, color: Colors.white24),
                SizedBox(height: 16),
                Text(
                  'Tap the dock icons',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          KruiFloatingDock(
            usePositioning: true,
            items: [
              KruiFloatingDockItem(
                icon: Icons.home,
                label: 'Home',
                onTap: () {},
              ),
              KruiFloatingDockItem(
                icon: Icons.explore,
                label: 'Explore',
                onTap: () {},
              ),
              KruiFloatingDockItem(
                icon: Icons.favorite,
                label: 'Favorites',
                onTap: () {},
              ),
              KruiFloatingDockItem(
                icon: Icons.person,
                label: 'Profile',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  },
);
