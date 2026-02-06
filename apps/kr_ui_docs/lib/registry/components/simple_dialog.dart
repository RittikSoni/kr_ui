import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiSimpleDialogInfo = ComponentInfo(
  id: 'simple-dialog',
  name: 'showKruiSimpleDialog',
  displayName: 'Simple Dialog',
  description:
      'A clean, modern dialog without glass effects—refined solid surface and typography. Use showKruiSimpleDialog to display. Supports title, content, and action buttons.',
  category: 'Overlays',
  icon: Icons.checklist_rtl_outlined,
  properties: [
    const PropertyInfo(
      name: 'context',
      type: 'BuildContext',
      defaultValue: 'required',
      description: 'Build context for showing the dialog',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'title',
      type: 'Widget?',
      defaultValue: 'null',
      description: 'Optional dialog title. Use any widget (e.g. Text with custom style, color, size) for full control.',
    ),
    const PropertyInfo(
      name: 'content',
      type: 'Widget?',
      defaultValue: 'null',
      description: 'Dialog body widget',
    ),
    const PropertyInfo(
      name: 'actions',
      type: 'List<KruiSimpleDialogAction>?',
      defaultValue: 'null',
      description: 'Action buttons (e.g. Cancel, OK)',
    ),
    const PropertyInfo(
      name: 'child',
      type: 'Widget?',
      defaultValue: 'null',
      description: 'Custom full content (use instead of title/content/actions)',
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
      description: 'Panel corner radius',
    ),
    const PropertyInfo(
      name: 'elevation',
      type: 'double',
      defaultValue: '8',
      description: 'Material elevation (shadow)',
    ),
    const PropertyInfo(
      name: 'barrierDismissible',
      type: 'bool',
      defaultValue: 'true',
      description: 'Whether tapping outside closes the dialog',
    ),
    const PropertyInfo(
      name: 'width',
      type: 'double?',
      defaultValue: '340',
      description: 'Max width of the dialog panel',
    ),
  ],
  basicExample: '''showKruiSimpleDialog(
  context,
  title: Text('Confirm'),
  content: Text('Are you sure you want to continue?'),
  actions: [
    KruiSimpleDialogAction(label: 'Cancel', onPressed: (ctx) => Navigator.of(ctx).pop()),
    KruiSimpleDialogAction(label: 'OK', isPrimary: true, onPressed: (ctx) => Navigator.of(ctx).pop(true)),
  ],
);''',
  advancedExample: '''showKruiSimpleDialog(
  context,
  title: Text('Simple Dialog', style: TextStyle(fontSize: 22, color: Colors.indigo)),
  backgroundColor: Colors.white,
  borderRadius: BorderRadius.circular(24),
  elevation: 12,
  content: Text('Custom styling.'),
  actions: [
    KruiSimpleDialogAction(label: 'Cancel', onPressed: (ctx) => Navigator.of(ctx).pop()),
    KruiSimpleDialogAction(label: 'Confirm', isPrimary: true, onPressed: (ctx) => Navigator.of(ctx).pop(true)),
  ],
);''',
  presets: [
    PresetInfo(
      name: 'Confirm',
      description: 'Title, message, and Cancel/OK actions',
      code: '''showKruiSimpleDialog(
  context,
  title: Text('Confirm'),
  content: Text('Are you sure?'),
  actions: [
    KruiSimpleDialogAction(label: 'Cancel', onPressed: (ctx) => Navigator.of(ctx).pop()),
    KruiSimpleDialogAction(label: 'OK', isPrimary: true, onPressed: (ctx) => Navigator.of(ctx).pop(true)),
  ],
);''',
      builder: () => Builder(
        builder: (context) => Center(
          child: KruiSimpleButton(
            onPressed: () => showKruiSimpleDialog(
              context,
              title: const Text('Confirm'),
              content: const Text('Are you sure you want to continue?'),
              actions: [
                KruiSimpleDialogAction(
                  label: 'Cancel',
                  onPressed: (ctx) => Navigator.of(ctx).pop(),
                ),
                KruiSimpleDialogAction(
                  label: 'OK',
                  isPrimary: true,
                  onPressed: (ctx) => Navigator.of(ctx).pop(true),
                ),
              ],
            ),
            child: const Text('Open Simple Dialog'),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Barrier dismissible (default)',
      description: 'Tap outside the dialog to close. barrierDismissible: true.',
      code: '''showKruiSimpleDialog(
  context,
  barrierDismissible: true,
  title: Text('Tap outside to close'),
  content: Text('Tap the dimmed area or use a button to dismiss.'),
  actions: [
    KruiSimpleDialogAction(label: 'Close', isPrimary: true, onPressed: (ctx) => Navigator.of(ctx).pop()),
  ],
);''',
      builder: () => Builder(
        builder: (context) => Center(
          child: KruiSimpleButton(
            onPressed: () => showKruiSimpleDialog(
              context,
              barrierDismissible: true,
              title: const Text('Tap outside to close'),
              content: const Text(
                'Tap the dimmed area or use the button to dismiss.',
              ),
              actions: [
                KruiSimpleDialogAction(
                  label: 'Close',
                  isPrimary: true,
                  onPressed: (ctx) => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            child: const Text('Barrier dismissible'),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Barrier not dismissible',
      description: 'Tapping outside does nothing. Must use a button. barrierDismissible: false.',
      code: '''showKruiSimpleDialog(
  context,
  barrierDismissible: false,
  title: Text('Must use button'),
  content: Text('Tapping outside will not close this dialog.'),
  actions: [
    KruiSimpleDialogAction(label: 'OK', isPrimary: true, onPressed: (ctx) => Navigator.of(ctx).pop()),
  ],
);''',
      builder: () => Builder(
        builder: (context) => Center(
          child: KruiSimpleButton(
            onPressed: () => showKruiSimpleDialog(
              context,
              barrierDismissible: false,
              title: const Text('Must use button'),
              content: const Text(
                'Tapping outside will not close this dialog.',
              ),
              actions: [
                KruiSimpleDialogAction(
                  label: 'OK',
                  isPrimary: true,
                  onPressed: (ctx) => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            child: const Text('Barrier not dismissible'),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Custom title style',
      description: 'Title as Widget: custom color, size, or any layout',
      code: '''showKruiSimpleDialog(
  context,
  title: Text(
    'Custom Title',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
  ),
  content: Text('Control title color, size, and more with a Widget.'),
  actions: [
    KruiSimpleDialogAction(label: 'OK', isPrimary: true, onPressed: (ctx) => Navigator.of(ctx).pop()),
  ],
);''',
      builder: () => Builder(
        builder: (context) => Center(
          child: KruiSimpleButton(
            onPressed: () => showKruiSimpleDialog(
              context,
              title: Text(
                'Custom Title',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ) ?? const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              content: const Text(
                'Control title color, size, and more with a Widget.',
              ),
              actions: [
                KruiSimpleDialogAction(
                  label: 'OK',
                  isPrimary: true,
                  onPressed: (ctx) => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            child: const Text('Custom title'),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Custom content',
      description: 'Full custom child with solid panel',
      code: '''showKruiSimpleDialog(
  context,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
      SizedBox(height: 16),
      Text('Simple and clean', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    ],
  ),
);''',
      builder: () => Builder(
        builder: (context) => Center(
          child: KruiSimpleButton(
            onPressed: () => showKruiSimpleDialog(
              context,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 48, color: Colors.green),
                  const SizedBox(height: 16),
                  Text(
                    'Simple and clean',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ) ??
                        const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            child: const Text('Open Simple Dialog'),
          ),
        ),
      ),
    ),
  ],
  demoBuilder: () => Builder(
    builder: (context) => Center(
      child: KruiSimpleButton(
        onPressed: () => showKruiSimpleDialog(
          context,
          title: const Text('Simple Dialog'),
          content: const Text(
            'A clean dialog with solid surface and modern typography. Tap outside or use the buttons to close.',
          ),
          actions: [
            KruiSimpleDialogAction(
              label: 'Cancel',
              onPressed: (ctx) => Navigator.of(ctx).pop(),
            ),
            KruiSimpleDialogAction(
              label: 'OK',
              isPrimary: true,
              onPressed: (ctx) => Navigator.of(ctx).pop(true),
            ),
          ],
        ),
        child: const Text('Open Simple Dialog'),
      ),
    ),
  ),
);
