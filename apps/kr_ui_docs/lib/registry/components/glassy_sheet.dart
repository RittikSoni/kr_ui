import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiGlassySheetInfo = ComponentInfo(
  id: 'glassy-sheet',
  name: 'showKruiGlassySheet',
  displayName: 'Glassy Sheet (Liquid Glass)',
  description:
      'A glassmorphic sheet that slides in from bottom, top, left, or right. Use position to choose the edge. Optional height/width (fraction 0–1 or pixels).',
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
      name: 'blur',
      type: 'double',
      defaultValue: '16',
      description: 'Backdrop blur',
    ),
    const PropertyInfo(
      name: 'opacity',
      type: 'double',
      defaultValue: '0.18',
      description: 'Glass opacity',
    ),
    const PropertyInfo(
      name: 'color',
      type: 'Color',
      defaultValue: 'Colors.white',
      description: 'Glass tint color',
    ),
    const PropertyInfo(
      name: 'borderRadius',
      type: 'BorderRadius?',
      defaultValue: 'BorderRadius.circular(20)',
      description: 'Corner radius',
    ),
  ],
  basicExample: '''showKruiGlassySheet(
  context,
  position: KruiSheetPosition.bottom,
  height: 0.4,
  child: Padding(
    padding: EdgeInsets.all(24),
    child: Text('Liquid glass sheet'),
  ),
);''',
  advancedExample: '''showKruiGlassySheet(
  context,
  position: KruiSheetPosition.right,
  width: 0.7,
  blur: 20,
  opacity: 0.2,
  child: YourContent(),
);''',
  presets: [
    PresetInfo(
      name: 'From bottom',
      description: 'Classic bottom sheet with liquid glass',
      code: '''showKruiGlassySheet(
  context,
  position: KruiSheetPosition.bottom,
  height: 0.4,
  child: Padding(padding: EdgeInsets.all(24), child: Text('Bottom sheet')),
);''',
      builder: () => _SheetDemo(
        position: KruiSheetPosition.bottom,
        isGlassy: true,
        height: 0.4,
      ),
    ),
    PresetInfo(
      name: 'From top',
      description: 'Sheet slides down from top',
      code: '''showKruiGlassySheet(
  context,
  position: KruiSheetPosition.top,
  height: 200,
  child: Padding(padding: EdgeInsets.all(24), child: Text('Top sheet')),
);''',
      builder: () => _SheetDemo(
        position: KruiSheetPosition.top,
        isGlassy: true,
        height: 200,
      ),
    ),
    PresetInfo(
      name: 'From left',
      description: 'Sheet slides in from left',
      code: '''showKruiGlassySheet(
  context,
  position: KruiSheetPosition.left,
  width: 280,
  child: Padding(padding: EdgeInsets.all(24), child: Text('Left sheet')),
);''',
      builder: () => _SheetDemo(
        position: KruiSheetPosition.left,
        isGlassy: true,
        width: 280,
      ),
    ),
    PresetInfo(
      name: 'From right',
      description: 'Sheet slides in from right',
      code: '''showKruiGlassySheet(
  context,
  position: KruiSheetPosition.right,
  width: 0.6,
  child: Padding(padding: EdgeInsets.all(24), child: Text('Right sheet')),
);''',
      builder: () => _SheetDemo(
        position: KruiSheetPosition.right,
        isGlassy: true,
        width: 0.6,
      ),
    ),
    PresetInfo(
      name: 'Half screen bottom',
      description: 'Bottom sheet at 50% height',
      code: '''showKruiGlassySheet(
  context,
  position: KruiSheetPosition.bottom,
  height: 0.5,
  child: ...,
);''',
      builder: () => _SheetDemo(
        position: KruiSheetPosition.bottom,
        isGlassy: true,
        height: 0.5,
      ),
    ),
  ],
  demoBuilder: () => _SheetDemo(
    position: KruiSheetPosition.bottom,
    isGlassy: true,
    height: 0.35,
  ),
);

class _SheetDemo extends StatelessWidget {
  final KruiSheetPosition position;
  final bool isGlassy;
  final double? height;
  final double? width;

  const _SheetDemo({
    required this.position,
    required this.isGlassy,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: KruiGlassyButton(
        onPressed: () {
          if (isGlassy) {
            showKruiGlassySheet(
              context,
              position: position,
              height: height,
              width: width,
              child: _SheetContent(position: position),
            );
          } else {
            showKruiSimpleSheet(
              context,
              position: position,
              height: height,
              width: width,
              child: _SheetContent(position: position),
            );
          }
        },
        child: Text(
          'Open ${isGlassy ? 'Glassy' : 'Simple'} Sheet (${position.name})',
        ),
      ),
    );
  }
}

class _SheetContent extends StatelessWidget {
  final KruiSheetPosition position;

  const _SheetContent({required this.position});

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
