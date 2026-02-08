import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiAvatarInfo = ComponentInfo(
  id: 'avatar',
  name: 'KruiAvatar',
  displayName: 'Avatar',
  description:
      'A versatile avatar component supporting images, initials, and icons. Features status badges, grouping capabilities, and extensive customization for size, shape, and borders.',
  category: 'Display',
  icon: Icons.account_circle,
  properties: [
    const PropertyInfo(
      name: 'image',
      type: 'ImageProvider?',
      defaultValue: 'null',
      description: 'Image to display.',
    ),
    const PropertyInfo(
      name: 'text',
      type: 'String?',
      defaultValue: 'null',
      description: 'Initials/text if image is null.',
    ),
    const PropertyInfo(
      name: 'icon',
      type: 'IconData?',
      defaultValue: 'Icons.person',
      description: 'Icon if image and text are null.',
    ),
    const PropertyInfo(
      name: 'size',
      type: 'double',
      defaultValue: '40.0',
      description: 'Diameter of the avatar.',
    ),
    const PropertyInfo(
      name: 'badgeColor',
      type: 'Color?',
      defaultValue: 'null',
      description: 'Color of the status badge.',
    ),
    const PropertyInfo(
      name: 'group',
      type: 'static method',
      defaultValue: 'null',
      description: 'Use KruiAvatar.group([...]) for stacking.',
    ),
  ],
  basicExample: '''KruiAvatar(
  image: NetworkImage('https://via.placeholder.com/150'),
  size: 50,
  badgeColor: Colors.green,
)''',
  advancedExample: '''KruiAvatar.group(
  children: [
    KruiAvatar(text: 'A', backgroundColor: Colors.blue),
    KruiAvatar(text: 'B', backgroundColor: Colors.red),
    KruiAvatar(text: 'C', backgroundColor: Colors.green),
  ],
  max: 3,
  size: 40,
)''',
  presets: [
    PresetInfo(
      name: 'Image Avatar',
      description: 'Avatar with network image',
      code: '''KruiAvatar(
  image: NetworkImage('https://avatars.githubusercontent.com/u/42760562?v=4'),
  size: 50,
)''',
      builder: () => const KruiAvatar(
        image: NetworkImage(
            'https://avatars.githubusercontent.com/u/42760562?v=4'),
        size: 50,
      ),
    ),
    PresetInfo(
      name: 'Profile with Badge',
      description: 'User avatar with online status',
      code: '''KruiAvatar(
  text: 'JD',
  backgroundColor: Colors.indigo,
  foregroundColor: Colors.white,
  badgeColor: Colors.green,
  size: 50,
)''',
      builder: () => const KruiAvatar(
        text: 'JD',
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        badgeColor: Colors.green,
        size: 50,
      ),
    ),
    PresetInfo(
      name: 'Avatar Group',
      description: 'Stacked avatars with overflow',
      code: '''KruiAvatar.group(
  children: [
    KruiAvatar(text: 'A', backgroundColor: Colors.blue),
    KruiAvatar(text: 'B', backgroundColor: Colors.red),
  ],
  size: 40,
)''',
      builder: () => KruiAvatar.group(
        children: [
          KruiAvatar(
              text: 'A',
              backgroundColor: Colors.blue.shade300,
              foregroundColor: Colors.white),
          KruiAvatar(
              text: 'B',
              backgroundColor: Colors.red.shade300,
              foregroundColor: Colors.white),
          KruiAvatar(
              text: 'C',
              backgroundColor: Colors.green.shade300,
              foregroundColor: Colors.white),
          KruiAvatar(
              text: 'D',
              backgroundColor: Colors.orange.shade300,
              foregroundColor: Colors.white),
        ],
        size: 40,
        max: 3,
      ),
    ),
  ],
  demoBuilder: () => Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const KruiAvatar(
          text: 'KS',
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          size: 60,
          badgeColor: Colors.green,
          badgeSize: 16,
        ),
        const SizedBox(width: 20),
        KruiAvatar.group(
          children: List.generate(
            5,
            (index) => KruiAvatar(
              text: String.fromCharCode(65 + index),
              backgroundColor:
                  Colors.primaries[index % Colors.primaries.length],
              foregroundColor: Colors.white,
            ),
          ),
          size: 40,
          max: 3,
        ),
      ],
    ),
  ),
);
