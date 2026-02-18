import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

// Helper to wrap examples in a dark gradient container for visibility
Widget _wrap(Widget child) {
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1A1040), Color(0xFF0D2137), Color(0xFF0E3B2F)],
      ),
    ),
    padding: const EdgeInsets.all(24),
    child: Center(child: child),
  );
}

final kruiChipGroupInfo = ComponentInfo(
  id: 'chip-group',
  name: 'KruiChipGroup',
  displayName: 'Chip Group',
  description:
      'A flexible chip group component supporting single/multi selection, custom layouts, and various visual styles. Perfect for filters, tags, and choices.',
  category: 'Selection',
  icon: Icons.sell_outlined,
  properties: [
    const PropertyInfo(
      name: 'chips',
      type: 'List<KruiTagChipData>',
      defaultValue: 'required',
      description: 'List of chip data objects',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'variant',
      type: 'KruiChipVariant',
      defaultValue: 'KruiChipVariant.glassy',
      description: 'Visual style variant (glassy, simple, outline)',
    ),
    const PropertyInfo(
      name: 'selectionMode',
      type: 'KruiChipGroupSelectionMode',
      defaultValue: 'multi',
      description: 'Selection behavior (none, single, multi)',
    ),
    const PropertyInfo(
      name: 'layout',
      type: 'KruiChipGroupLayout',
      defaultValue: 'wrap',
      description: 'Layout mode (wrap, scrollableRow)',
    ),
    const PropertyInfo(
      name: 'size',
      type: 'KruiChipSize',
      defaultValue: 'medium',
      description: 'Size of the chips',
    ),
    const PropertyInfo(
      name: 'accentColor',
      type: 'Color?',
      defaultValue: 'null',
      description: 'Primary accent color for selection state',
    ),
    const PropertyInfo(
      name: 'onSelectionChanged',
      type: 'ValueChanged<Set<String>>?',
      defaultValue: 'null',
      description: 'Callback when selection changes',
    ),
    const PropertyInfo(
      name: 'onChipDeleted',
      type: 'ValueChanged<String>?',
      defaultValue: 'null',
      description: 'Callback when a chip is deleted',
    ),
  ],
  basicExample: '''KruiChipGroup(
  variant: KruiChipVariant.glassy,
  initialSelectedIds: {'flutter'},
  chips: [
    KruiTagChipData(id: 'flutter', label: 'Flutter'),
    KruiTagChipData(id: 'dart', label: 'Dart'),
    KruiTagChipData(id: 'firebase', label: 'Firebase'),
  ],
  onSelectionChanged: (ids) => print('Selected: \$ids'),
)''',
  advancedExample: '''KruiTagChip(
  label: 'Rich Content',
  variant: KruiChipVariant.glassy,
  accentColor: Colors.amber,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.rocket_launch, size: 14, color: Colors.amber),
      SizedBox(width: 6),
      Text('Launch', style: TextStyle(fontWeight: FontWeight.bold)),
    ],
  ),
)''',
  presets: [
    PresetInfo(
      name: '1. Standalone Chip',
      description: 'Single interactive chip examples',
      code: '''Wrap(
  spacing: 10,
  runSpacing: 10,
  children: [
    KruiTagChip(
      label: 'Toggle me',
      icon: Icons.auto_awesome,
      variant: KruiChipVariant.glassy,
      isSelected: _selected,
      onTap: () => setState(() => _selected = !_selected),
    ),
    KruiTagChip(
      label: 'Display only',
      variant: KruiChipVariant.simple,
      accentColor: Color(0xFF00BFA5),
    ),
    KruiTagChip(
      label: 'Disabled',
      icon: Icons.block,
      isDisabled: true,
      variant: KruiChipVariant.glassy,
    ),
  ],
)''',
      builder: () => _wrap(StatefulBuilder(
        builder: (context, setState) {
          bool selected = false;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              KruiTagChip(
                label: 'Toggle me',
                icon: Icons.auto_awesome,
                isSelected: selected,
                variant: KruiChipVariant.glassy,
                onTap: () => setState(() => selected = !selected),
              ),
              const KruiTagChip(
                label: 'Display only',
                variant: KruiChipVariant.simple,
                accentColor: Color(0xFF00BFA5),
              ),
              const KruiTagChip(
                label: 'Disabled',
                icon: Icons.block,
                isDisabled: true,
                variant: KruiChipVariant.glassy,
              ),
            ],
          );
        },
      )),
    ),
    PresetInfo(
      name: '2. Glassy Multi-Select',
      description: 'Glassmorphic selection group',
      code: '''KruiChipGroup(
  variant: KruiChipVariant.glassy,
  selectionMode: KruiChipGroupSelectionMode.multi,
  initialSelectedIds: const {'flutter', 'dart'},
  chips: const [
    KruiTagChipData(id: 'flutter', label: 'Flutter', icon: Icons.flutter_dash),
    KruiTagChipData(id: 'dart', label: 'Dart', icon: Icons.code),
    KruiTagChipData(id: 'firebase', label: 'Firebase', icon: Icons.local_fire_department),
    KruiTagChipData(id: 'supabase', label: 'Supabase', icon: Icons.storage),
    KruiTagChipData(id: 'riverpod', label: 'Riverpod', icon: Icons.bolt),
  ],
)''',
      builder: () => _wrap(KruiChipGroup(
        variant: KruiChipVariant.glassy,
        selectionMode: KruiChipGroupSelectionMode.multi,
        initialSelectedIds: const {'flutter', 'dart'},
        chips: const [
          KruiTagChipData(
              id: 'flutter', label: 'Flutter', icon: Icons.flutter_dash),
          KruiTagChipData(id: 'dart', label: 'Dart', icon: Icons.code),
          KruiTagChipData(
              id: 'firebase',
              label: 'Firebase',
              icon: Icons.local_fire_department),
          KruiTagChipData(
              id: 'supabase', label: 'Supabase', icon: Icons.storage),
          KruiTagChipData(id: 'riverpod', label: 'Riverpod', icon: Icons.bolt),
        ],
        onSelectionChanged: (ids) {},
      )),
    ),
    PresetInfo(
      name: '3. Simple Flat Group',
      description: 'Clean flat style for minimal designs',
      code: '''KruiChipGroup(
  variant: KruiChipVariant.simple,
  selectionMode: KruiChipGroupSelectionMode.multi,
  accentColor: Color(0xFF00BFA5),
  chips: const [
    KruiTagChipData(id: 'ux', label: 'UX Design'),
    KruiTagChipData(id: 'ui', label: 'UI'),
    KruiTagChipData(id: 'branding', label: 'Branding'),
    KruiTagChipData(id: 'motion', label: 'Motion'),
    KruiTagChipData(id: 'typography', label: 'Typography'),
    KruiTagChipData(id: 'color', label: 'Colour Theory'),
  ],
)''',
      builder: () => _wrap(const KruiChipGroup(
        variant: KruiChipVariant.simple,
        selectionMode: KruiChipGroupSelectionMode.multi,
        accentColor: Color(0xFF00BFA5),
        chips: [
          KruiTagChipData(id: 'ux', label: 'UX Design'),
          KruiTagChipData(id: 'ui', label: 'UI'),
          KruiTagChipData(id: 'branding', label: 'Branding'),
          KruiTagChipData(id: 'motion', label: 'Motion'),
          KruiTagChipData(id: 'typography', label: 'Typography'),
          KruiTagChipData(id: 'color', label: 'Colour Theory'),
        ],
      )),
    ),
    PresetInfo(
      name: '4. Single Select (Radio)',
      description: 'Radio-button behavior for exclusive choices',
      code: '''KruiChipGroup(
  variant: KruiChipVariant.glassy,
  selectionMode: KruiChipGroupSelectionMode.single,
  accentColor: Color(0xFFFF6584),
  chips: const [
    KruiTagChipData(id: 'xs', label: 'XS'),
    KruiTagChipData(id: 's', label: 'S'),
    KruiTagChipData(id: 'm', label: 'M'),
    KruiTagChipData(id: 'l', label: 'L'),
    KruiTagChipData(id: 'xl', label: 'XL'),
    KruiTagChipData(id: 'xxl', label: 'XXL'),
  ],
)''',
      builder: () => _wrap(StatefulBuilder(builder: (context, setState) {
        String selected = '';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            KruiChipGroup(
              variant: KruiChipVariant.glassy,
              selectionMode: KruiChipGroupSelectionMode.single,
              accentColor: const Color(0xFFFF6584),
              chips: const [
                KruiTagChipData(id: 'xs', label: 'XS'),
                KruiTagChipData(id: 's', label: 'S'),
                KruiTagChipData(id: 'm', label: 'M'),
                KruiTagChipData(id: 'l', label: 'L'),
                KruiTagChipData(id: 'xl', label: 'XL'),
                KruiTagChipData(id: 'xxl', label: 'XXL'),
              ],
              onSelectionChanged: (ids) =>
                  setState(() => selected = ids.isEmpty ? '' : ids.first),
            ),
            if (selected.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Selected: \$selected',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        );
      })),
    ),
    PresetInfo(
      name: '5. Deletable Chips',
      description: 'Chips that can be removed by the user',
      code: '''KruiChipGroup(
  variant: KruiChipVariant.glassy,
  onChipDeleted: (id) => removeChip(id),
  chips: [
    KruiTagChipData(id: 'react', label: 'React'),
    KruiTagChipData(id: 'vue', label: 'Vue'),
    KruiTagChipData(id: 'svelte', label: 'Svelte'),
  ],
)''',
      builder: () => _wrap(StatefulBuilder(
        builder: (context, setState) {
          final tags = [
            const KruiTagChipData(id: 'react', label: 'React'),
            const KruiTagChipData(id: 'vue', label: 'Vue'),
            const KruiTagChipData(id: 'svelte', label: 'Svelte'),
            const KruiTagChipData(id: 'angular', label: 'Angular'),
          ];
          return tags.isEmpty
              ? const Text(
                  'All chips removed. Rebuild to reset.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                )
              : KruiChipGroup(
                  key: ValueKey(tags.length),
                  chips: tags,
                  variant: KruiChipVariant.glassy,
                  selectionMode: KruiChipGroupSelectionMode.none,
                  onChipDeleted: (id) {
                    // This is just a visual demo
                  },
                );
        },
      )),
    ),
    PresetInfo(
      name: '6. Sizes',
      description: 'Small, Medium, and Large sizes',
      code: '''Column(
  children: [
    KruiChipGroup(size: KruiChipSize.small, ...),
    KruiChipGroup(size: KruiChipSize.medium, ...),
    KruiChipGroup(size: KruiChipSize.large, ...),
  ],
)''',
      builder: () => _wrap(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final size in KruiChipSize.values) ...[
            KruiChipGroup(
              chips: const [
                KruiTagChipData(id: 'a', label: 'Small chip', icon: Icons.star),
                KruiTagChipData(id: 'b', label: 'Chip'),
              ],
              variant: KruiChipVariant.glassy,
              size: size,
              selectionMode: KruiChipGroupSelectionMode.none,
            ),
            const SizedBox(height: 8),
          ],
        ],
      )),
    ),
    PresetInfo(
      name: '7. Scrollable Row',
      description: 'Horizontal scrolling for many items',
      code: '''KruiChipGroup(
  layout: KruiChipGroupLayout.scrollableRow,
  variant: KruiChipVariant.glassy,
  chips: List.generate(12, (i) => 
    KruiTagChipData(id: 'tag_\$i', label: 'Tag \${i + 1}')
  ),
)''',
      builder: () => _wrap(KruiChipGroup(
        layout: KruiChipGroupLayout.scrollableRow,
        variant: KruiChipVariant.glassy,
        selectionMode: KruiChipGroupSelectionMode.multi,
        chips: List.generate(
          12,
          (i) => KruiTagChipData(id: 'tag_\$i', label: 'Tag \${i + 1}'),
        ),
      )),
    ),
    PresetInfo(
      name: '8. Avatar Chips',
      description: 'Chips with leading avatar widgets',
      code: '''KruiChipGroup(
  variant: KruiChipVariant.simple,
  chips: [
    KruiTagChipData(id: 'red', label: 'Red', avatar: CircleAvatar(backgroundColor: Colors.red, radius: 8)),
    KruiTagChipData(id: 'blue', label: 'Blue', avatar: CircleAvatar(backgroundColor: Colors.blue, radius: 8)),
  ],
)''',
      builder: () => _wrap(KruiChipGroup(
        variant: KruiChipVariant.simple,
        selectionMode: KruiChipGroupSelectionMode.multi,
        chips: [
          KruiTagChipData(
              id: 'red',
              label: 'Red',
              avatar: const CircleAvatar(
                  backgroundColor: Colors.redAccent, radius: 8)),
          KruiTagChipData(
              id: 'green',
              label: 'Green',
              avatar: const CircleAvatar(
                  backgroundColor: Colors.greenAccent, radius: 8)),
          KruiTagChipData(
              id: 'blue',
              label: 'Blue',
              avatar: const CircleAvatar(
                  backgroundColor: Colors.blueAccent, radius: 8)),
          KruiTagChipData(
              id: 'purple',
              label: 'Purple',
              avatar: const CircleAvatar(
                  backgroundColor: Colors.purpleAccent, radius: 8)),
          KruiTagChipData(
              id: 'amber',
              label: 'Amber',
              avatar: const CircleAvatar(
                  backgroundColor: Colors.amberAccent, radius: 8)),
        ],
        accentColor: const Color(0xFF6C63FF),
      )),
    ),
    PresetInfo(
      name: '9. Disabled & Edge Cases',
      description: 'Disabled state, empty label, long text',
      code: '''KruiChipGroup(
  chips: [
    KruiTagChipData(id: 'active', label: 'Active'),
    KruiTagChipData(id: 'disabled', label: 'Disabled', isDisabled: true),
    KruiTagChipData(id: 'long', label: 'Very long label...'),
  ],
)''',
      builder: () => _wrap(const KruiChipGroup(
        variant: KruiChipVariant.glassy,
        selectionMode: KruiChipGroupSelectionMode.multi,
        chips: [
          KruiTagChipData(id: 'active', label: 'Active'),
          KruiTagChipData(id: 'disabled', label: 'Disabled', isDisabled: true),
          KruiTagChipData(id: 'empty', label: ''),
          KruiTagChipData(
            id: 'long',
            label: 'This is a very long chip label that should truncate',
          ),
        ],
        chipMaxWidth: 180,
      )),
    ),
    PresetInfo(
      name: '10. Custom Colors',
      description: 'Per-chip color overrides',
      code: '''KruiChipGroup(
  variant: KruiChipVariant.glassy,
  chips: [
    KruiTagChipData(id: 'c1', label: 'Violet', accentColor: Color(0xFF6C63FF)),
    KruiTagChipData(id: 'c2', label: 'Teal', accentColor: Color(0xFF00BFA5)),
    KruiTagChipData(id: 'c3', label: 'Rose', accentColor: Color(0xFFFF6584)),
  ],
)''',
      builder: () => _wrap(const KruiChipGroup(
        variant: KruiChipVariant.glassy,
        selectionMode: KruiChipGroupSelectionMode.multi,
        initialSelectedIds: {'c1', 'c3'},
        chips: [
          KruiTagChipData(
              id: 'c1', label: 'Violet', accentColor: Color(0xFF6C63FF)),
          KruiTagChipData(
              id: 'c2', label: 'Teal', accentColor: Color(0xFF00BFA5)),
          KruiTagChipData(
              id: 'c3', label: 'Rose', accentColor: Color(0xFFFF6584)),
          KruiTagChipData(
              id: 'c4', label: 'Amber', accentColor: Color(0xFFFFAB40)),
          KruiTagChipData(
              id: 'c5', label: 'Sky', accentColor: Color(0xFF29B6F6)),
        ],
      )),
    ),
    PresetInfo(
      name: '11. Custom Widgets',
      description: 'Fully custom content inside standalone chips',
      code: '''KruiTagChip(
  label: 'Rich Content',
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.rocket_launch, size: 14, color: Colors.amber),
      Text('Launch'),
    ],
  ),
)''',
      builder: () => _wrap(StatefulBuilder(builder: (context, setState) {
        final Set<String> selected = {};
        void toggle(String id) => setState(() =>
            selected.contains(id) ? selected.remove(id) : selected.add(id));

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            KruiTagChip(
              label: 'Bold text chip',
              isSelected: selected.contains('a'),
              onTap: () => toggle('a'),
              variant: KruiChipVariant.glassy,
              child: const Text(
                'Bold  ·  14sp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            KruiTagChip(
              label: 'Gradient',
              isSelected: selected.contains('c'),
              onTap: () => toggle('c'),
              variant: KruiChipVariant.glassy,
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFF6584), Color(0xFFFFAB40)],
                ).createShader(bounds),
                child: const Text(
                  '✦ Premium',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            KruiTagChip(
              label: 'Badge chip',
              isSelected: selected.contains('d'),
              onTap: () => toggle('d'),
              variant: KruiChipVariant.glassy,
              accentColor: const Color(0xFFFF6584),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications_rounded,
                          size: 15, color: Colors.white),
                      SizedBox(width: 5),
                      Text('Alerts',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                  Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6584),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      })),
    ),
    PresetInfo(
      name: '12. Rich Content Group',
      description: 'Managed group with custom children',
      code: '''KruiChipGroup(
  variant: KruiChipVariant.glassy,
  chips: [
    KruiTagChipData(
      id: 'en',
      label: 'English',
      customChild: Row(children: [Text('🇺🇸'), Text('English')]),
    ),
  ],
)''',
      builder: () => _wrap(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          KruiChipGroup(
            variant: KruiChipVariant.glassy,
            selectionMode: KruiChipGroupSelectionMode.single,
            accentColor: const Color(0xFF29B6F6),
            initialSelectedIds: const {'en'},
            chips: [
              KruiTagChipData(
                  id: 'en',
                  label: 'English',
                  customChild: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('🇺🇸', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 6),
                      Text('English',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                    ],
                  )),
              KruiTagChipData(
                  id: 'jp',
                  label: 'Japanese',
                  customChild: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('🇯🇵', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 6),
                      Text('日本語',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                    ],
                  )),
            ],
            onSelectionChanged: (ids) {},
          ),
          const SizedBox(height: 14),
          KruiChipGroup(
            variant: KruiChipVariant.glassy,
            selectionMode: KruiChipGroupSelectionMode.none,
            chips: [
              KruiTagChipData(
                id: 's1',
                label: '4.9k stars',
                customChild: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('4.9k',
                        style: TextStyle(
                            color: Color(0xFFFFAB40),
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: 1),
                    Text('Stars',
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                            letterSpacing: 0.3)),
                  ],
                ),
              ),
            ],
          ),
        ],
      )),
    ),
    PresetInfo(
      name: '13. Full Bleed Image',
      description: 'Chips with images filling the content area',
      code: '''KruiTagChip(
  label: 'User',
  applyPaddingToChild: false,
  child: SizedBox(
    height: 36,
    child: Padding(
      padding: EdgeInsets.all(4),
      child: Row(...), // Custom content
    ),
  ),
)''',
      builder: () => _wrap(
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            KruiTagChip(
              label: 'Image chip',
              variant: KruiChipVariant.glassy,
              borderRadius: BorderRadius.circular(10),
              applyPaddingToChild: false,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.network(
                  'https://picsum.photos/seed/chip/56/56',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    color: Colors.white12,
                    child: const Icon(Icons.image, color: Colors.white38),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
  demoBuilder: () => _wrap(Builder(
    builder: (context) => KruiChipGroup(
      variant: KruiChipVariant.glassy,
      selectionMode: KruiChipGroupSelectionMode.multi,
      initialSelectedIds: const {'flutter', 'dart'},
      chips: const [
        KruiTagChipData(
            id: 'flutter', label: 'Flutter', icon: Icons.flutter_dash),
        KruiTagChipData(id: 'dart', label: 'Dart', icon: Icons.code),
        KruiTagChipData(
            id: 'firebase',
            label: 'Firebase',
            icon: Icons.local_fire_department),
        KruiTagChipData(id: 'design', label: 'Design', icon: Icons.brush),
        KruiTagChipData(id: 'mobile', label: 'Mobile', icon: Icons.smartphone),
      ],
      onSelectionChanged: (ids) {},
    ),
  )),
);
