import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiGlassyDialogInfo = ComponentInfo(
  id: 'glassy-dialog',
  name: 'showKruiGlassyDialog',
  displayName: 'Glassy Dialog (Liquid Glass)',
  description:
      'A beautiful glassmorphic dialog with frosted blur and modern styling. Use showKruiGlassyDialog to display. Supports title, content, and action buttons with full customization.',
  category: 'Overlays',
  icon: Icons.dashboard_customize_outlined,
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
      description:
          'Optional dialog title. Use any widget (e.g. Text, or Text with custom style, color, size) for full control.',
    ),
    const PropertyInfo(
      name: 'content',
      type: 'Widget?',
      defaultValue: 'null',
      description: 'Dialog body widget',
    ),
    const PropertyInfo(
      name: 'actions',
      type: 'List<KruiGlassyDialogAction>?',
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
      name: 'blur',
      type: 'double',
      defaultValue: '16',
      description: 'Backdrop blur intensity',
    ),
    const PropertyInfo(
      name: 'opacity',
      type: 'double',
      defaultValue: '0.18',
      description: 'Glass panel opacity (0.0-1.0)',
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
      description: 'Panel corner radius',
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
  basicExample: '''showKruiGlassyDialog(
  context,
  title: Text('Confirm'),
  content: Text('Are you sure you want to continue?'),
  actions: [
    KruiGlassyDialogAction(
      label: 'Cancel',
      onPressed: (ctx) => Navigator.of(ctx).pop(),
    ),
    KruiGlassyDialogAction(
      label: 'OK',
      isPrimary: true,
      onPressed: (ctx) => Navigator.of(ctx).pop(true),
    ),
  ],
);''',
  advancedExample: '''showKruiGlassyDialog(
  context,
  title: Text('Liquid Glass', style: TextStyle(fontSize: 22, color: Colors.blue)),
  blur: 20,
  opacity: 0.2,
  borderRadius: BorderRadius.circular(24),
  content: Text('Custom blur and opacity.'),
  actions: [
    KruiGlassyDialogAction(label: 'Cancel', onPressed: (ctx) => Navigator.of(ctx).pop()),
    KruiGlassyDialogAction(label: 'Confirm', isPrimary: true, onPressed: (ctx) => Navigator.of(ctx).pop(true)),
  ],
);''',
  presets: [
    PresetInfo(
      name: 'Confirm',
      description: 'Title, message, and Cancel/OK actions',
      code: '''showKruiGlassyDialog(
  context,
  title: Text('Confirm'),
  content: Text('Are you sure?'),
  actions: [
    KruiGlassyDialogAction(label: 'Cancel', onPressed: (ctx) => Navigator.of(ctx).pop()),
    KruiGlassyDialogAction(label: 'OK', isPrimary: true, onPressed: (ctx) => Navigator.of(ctx).pop(true)),
  ],
);''',
      builder: () => Builder(
        builder: (context) => Center(
          child: KruiGlassyButton(
            onPressed: () => showKruiGlassyDialog(
              context,
              title: const Text('Confirm'),
              content: const Text('Are you sure you want to continue?'),
              actions: [
                KruiGlassyDialogAction(
                  label: 'Cancel',
                  onPressed: (ctx) => Navigator.of(ctx).pop(),
                ),
                KruiGlassyDialogAction(
                  label: 'OK',
                  isPrimary: true,
                  onPressed: (ctx) => Navigator.of(ctx).pop(true),
                ),
              ],
            ),
            child: const Text('Open Glassy Dialog'),
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Barrier dismissible (default)',
      description: 'Tap outside the dialog to close. barrierDismissible: true.',
      code: '''showKruiGlassyDialog(
  context,
  barrierDismissible: true,
  title: Text('Tap outside to close'),
  content: Text('Tap the dimmed area or use a button to dismiss.'),
  actions: [
    KruiGlassyDialogAction(label: 'Close', isPrimary: true, onPressed: (ctx) => Navigator.of(ctx).pop()),
  ],
);''',
      builder: () => Builder(
        builder: (context) => Center(
          child: KruiGlassyButton(
            onPressed: () => showKruiGlassyDialog(
              context,
              barrierDismissible: true,
              title: const Text('Tap outside to close'),
              content: const Text(
                'Tap the dimmed area or use the button to dismiss.',
              ),
              actions: [
                KruiGlassyDialogAction(
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
      description:
          'Tapping outside does nothing. Must use a button. barrierDismissible: false.',
      code: '''showKruiGlassyDialog(
  context,
  barrierDismissible: false,
  title: Text('Must use button'),
  content: Text('Tapping outside will not close this dialog.'),
  actions: [
    KruiGlassyDialogAction(label: 'OK', isPrimary: true, onPressed: (ctx) => Navigator.of(ctx).pop()),
  ],
);''',
      builder: () => Builder(
        builder: (context) => Center(
          child: KruiGlassyButton(
            onPressed: () => showKruiGlassyDialog(
              context,
              barrierDismissible: false,
              title: const Text('Must use button'),
              content: const Text(
                'Tapping outside will not close this dialog.',
              ),
              actions: [
                KruiGlassyDialogAction(
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
      code: '''showKruiGlassyDialog(
  context,
  title: Text(
    'Custom Title',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
  ),
  content: Text('Control title color, size, and more with a Widget.'),
  actions: [
    KruiGlassyDialogAction(label: 'OK', isPrimary: true, onPressed: (ctx) => Navigator.of(ctx).pop()),
  ],
);''',
      builder: () => Builder(
        builder: (context) => Center(
          child: KruiGlassyButton(
            onPressed: () => showKruiGlassyDialog(
              context,
              title: Text(
                'Custom Title',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ) ??
                    const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
              ),
              content: const Text(
                'Control title color, size, and more with a Widget.',
              ),
              actions: [
                KruiGlassyDialogAction(
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
      description: 'Full custom child with liquid glass panel',
      code: '''showKruiGlassyDialog(
  context,
  blur: 18,
  opacity: 0.2,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.auto_awesome, size: 48, color: Colors.blue),
      SizedBox(height: 16),
      Text('Liquid glass panel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    ],
  ),
);''',
      builder: () => Builder(
        builder: (context) => Center(
          child: KruiGlassyButton(
            onPressed: () => showKruiGlassyDialog(
              context,
              blur: 18,
              opacity: 0.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, size: 48, color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    'Liquid glass panel',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ) ??
                        const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            child: const Text('Open Custom Glass'),
          ),
        ),
      ),
    ),
  ],
  demoBuilder: () => Builder(
    builder: (context) => Center(
      child: KruiGlassyButton(
        onPressed: () => showKruiGlassyDialog(
          context,
          title: const Text('Glassy Dialog'),
          content: const Text(
            'A beautiful glassmorphic dialog with frosted blur. Tap outside or use the buttons to close.',
          ),
          actions: [
            KruiGlassyDialogAction(
              label: 'Cancel',
              onPressed: (ctx) => Navigator.of(ctx).pop(),
            ),
            KruiGlassyDialogAction(
              label: 'OK',
              isPrimary: true,
              onPressed: (ctx) => Navigator.of(ctx).pop(true),
            ),
          ],
        ),
        child: const Text('Open Glassy Dialog'),
      ),
    ),
  ),
);
