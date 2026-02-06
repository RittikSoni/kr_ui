import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiSimpleSheetInfo = ComponentInfo(
  id: 'simple-sheet',
  name: 'showKruiSimpleSheet',
  displayName: 'Simple Sheet',
  description:
      'A simple (non-glass) sheet that slides in from bottom, top, left, or right. Use position to choose the edge. Solid background, no blur.',
  category: 'Overlays',
  icon: Icons.call_to_action_outlined,
  properties: [
    const PropertyInfo(
      name: 'context',
      type: 'BuildContext',
      defaultValue: 'required',
      description: 'Build context',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'child',
      type: 'Widget',
      defaultValue: 'required',
      description: 'Sheet content',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'position',
      type: 'KruiSheetPosition',
      defaultValue: 'KruiSheetPosition.bottom',
      description: 'Edge: bottom, top, left, right',
    ),
    const PropertyInfo(
      name: 'height',
      type: 'double?',
      defaultValue: 'null',
      description: 'Height for bottom/top (fraction 0–1 or pixels)',
    ),
    const PropertyInfo(
      name: 'width',
      type: 'double?',
      defaultValue: 'null',
      description: 'Width for left/right (fraction 0–1 or pixels)',
    ),
    const PropertyInfo(
      name: 'barrierDismissible',
      type: 'bool',
      defaultValue: 'true',
      description: 'Tap outside to close',
    ),
    const PropertyInfo(
      name: 'backgroundColor',
      type: 'Color?',
      defaultValue: 'Theme.colorScheme.surface',
      description: 'Panel background color',
    ),
    const PropertyInfo(
      name: 'borderRadius',
      type: 'BorderRadius?',
      defaultValue: 'BorderRadius.circular(20)',
      description: 'Corner radius',
    ),
    const PropertyInfo(
      name: 'elevation',
      type: 'double',
      defaultValue: '8',
      description: 'Material elevation',
    ),
  ],
  basicExample: '''showKruiSimpleSheet(
  context,
  position: KruiSheetPosition.bottom,
  height: 0.4,
  child: Padding(
    padding: EdgeInsets.all(24),
    child: Text('Simple sheet'),
  ),
);''',
  advancedExample: '''showKruiSimpleSheet(
  context,
  position: KruiSheetPosition.right,
  width: 0.7,
  backgroundColor: Colors.white,
  elevation: 12,
  child: YourContent(),
);''',
  presets: [
    PresetInfo(
      name: 'From bottom',
      description: 'Classic bottom sheet, solid style',
      code: '''showKruiSimpleSheet(
  context,
  position: KruiSheetPosition.bottom,
  height: 0.4,
  child: Padding(padding: EdgeInsets.all(24), child: Text('Bottom sheet')),
);''',
      builder: () => _SimpleSheetDemo(
        position: KruiSheetPosition.bottom,
        height: 0.4,
      ),
    ),
    PresetInfo(
      name: 'From top',
      description: 'Sheet slides down from top',
      code: '''showKruiSimpleSheet(
  context,
  position: KruiSheetPosition.top,
  height: 200,
  child: Padding(padding: EdgeInsets.all(24), child: Text('Top sheet')),
);''',
      builder: () => _SimpleSheetDemo(
        position: KruiSheetPosition.top,
        height: 200,
      ),
    ),
    PresetInfo(
      name: 'From left',
      description: 'Sheet slides in from left',
      code: '''showKruiSimpleSheet(
  context,
  position: KruiSheetPosition.left,
  width: 280,
  child: Padding(padding: EdgeInsets.all(24), child: Text('Left sheet')),
);''',
      builder: () => _SimpleSheetDemo(
        position: KruiSheetPosition.left,
        width: 280,
      ),
    ),
    PresetInfo(
      name: 'From right',
      description: 'Sheet slides in from right',
      code: '''showKruiSimpleSheet(
  context,
  position: KruiSheetPosition.right,
  width: 0.6,
  child: Padding(padding: EdgeInsets.all(24), child: Text('Right sheet')),
);''',
      builder: () => _SimpleSheetDemo(
        position: KruiSheetPosition.right,
        width: 0.6,
      ),
    ),
  ],
  demoBuilder: () => _SimpleSheetDemo(
    position: KruiSheetPosition.bottom,
    height: 0.35,
  ),
);

class _SimpleSheetDemo extends StatelessWidget {
  final KruiSheetPosition position;
  final double? height;
  final double? width;

  const _SimpleSheetDemo({
    required this.position,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: KruiSimpleButton(
        onPressed: () {
          showKruiSimpleSheet(
            context,
            position: position,
            height: height,
            width: width,
            child: _SimpleSheetContent(position: position),
          );
        },
        child: Text('Open Simple Sheet (${position.name})'),
      ),
    );
  }
}

class _SimpleSheetContent extends StatelessWidget {
  final KruiSheetPosition position;

  const _SimpleSheetContent({required this.position});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Use this context (sheet overlay) so Close pops the sheet, not the page.
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${position.name[0].toUpperCase()}${position.name.substring(1)} sheet',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              KruiSimpleIconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icons.close,
                size: 36,
                color: theme.colorScheme.surfaceContainerHighest,
                iconColor: theme.colorScheme.onSurface,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Tap outside or close to dismiss. Position: ${position.name}.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
