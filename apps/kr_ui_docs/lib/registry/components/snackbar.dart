import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiSnackbarInfo = ComponentInfo(
  id: 'snackbar',
  name: 'KruiSnackbar',
  displayName: 'Snackbar Toast',
  description:
      'A modern, elegant toast with optional action and quick variants (success, danger, warning, info). No glass or blur—refined solid surface, accent strip, and smooth animation. Context not required.',
  category: 'Feedback',
  icon: Icons.notifications_outlined,
  properties: [
    const PropertyInfo(
      name: 'message',
      type: 'String',
      defaultValue: 'required',
      description: 'The message text to display.',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'icon',
      type: 'IconData?',
      defaultValue: 'null',
      description: 'Optional leading icon (used with KruiSnackbar.show).',
    ),
    const PropertyInfo(
      name: 'actionLabel',
      type: 'String?',
      defaultValue: 'null',
      description: 'Label for the action button (e.g. Undo).',
    ),
    const PropertyInfo(
      name: 'onAction',
      type: 'VoidCallback?',
      defaultValue: 'null',
      description: 'Called when the action is tapped; also dismisses the snackbar.',
    ),
    const PropertyInfo(
      name: 'duration',
      type: 'Duration',
      defaultValue: 'Duration(seconds: 3)',
      description: 'How long the snackbar stays visible.',
    ),
    const PropertyInfo(
      name: 'backgroundColor',
      type: 'Color?',
      defaultValue: 'null',
      description: 'Background color (KruiSnackbar.show only).',
    ),
    const PropertyInfo(
      name: 'foregroundColor',
      type: 'Color?',
      defaultValue: 'null',
      description: 'Text and icon color (KruiSnackbar.show only).',
    ),
  ],
  basicExample: '''KruiSnackbar.success(message: 'Saved!');''',
  advancedExample: '''KruiSnackbar.danger(
  message: 'Failed to save',
  actionLabel: 'Retry',
  onAction: () => retry(),
  duration: Duration(seconds: 5),
);''',
  presets: [
    PresetInfo(
      name: 'Success',
      description: 'Green accent, checkmark icon',
      code: '''KruiSnackbar.success(message: 'Saved!');''',
      builder: () => KruiSimpleButton(
        onPressed: () => KruiSnackbar.success(message: 'Saved!'),
        child: const Text('Success'),
      ),
    ),
    PresetInfo(
      name: 'Danger',
      description: 'Red accent, error icon',
      code: '''KruiSnackbar.danger(message: 'Something went wrong');''',
      builder: () => KruiSimpleButton(
        onPressed: () => KruiSnackbar.danger(message: 'Something went wrong'),
        child: const Text('Danger'),
      ),
    ),
    PresetInfo(
      name: 'Warning',
      description: 'Amber accent, warning icon',
      code: '''KruiSnackbar.warning(message: 'Check your input');''',
      builder: () => KruiSimpleButton(
        onPressed: () => KruiSnackbar.warning(message: 'Check your input'),
        child: const Text('Warning'),
      ),
    ),
    PresetInfo(
      name: 'Info',
      description: 'Blue accent, info icon',
      code: '''KruiSnackbar.info(message: 'New update available');''',
      builder: () => KruiSimpleButton(
        onPressed: () => KruiSnackbar.info(message: 'New update available'),
        child: const Text('Info'),
      ),
    ),
    PresetInfo(
      name: 'With action',
      description: 'Snackbar with Undo action',
      code: '''KruiSnackbar.success(
  message: 'Item removed',
  actionLabel: 'Undo',
  onAction: () => KruiSnackbar.info(message: 'Restored'),
);''',
      builder: () => KruiSimpleButton(
        onPressed: () => KruiSnackbar.success(
          message: 'Item removed',
          actionLabel: 'Undo',
          onAction: () => KruiSnackbar.info(message: 'Restored'),
        ),
        child: const Text('Action Snackbar'),
      ),
    ),
    PresetInfo(
      name: 'Custom (show)',
      description: 'Fully custom with icon and colors',
      code: '''KruiSnackbar.show(
  message: 'Link copied',
  icon: Icons.link_rounded,
  backgroundColor: Color(0xFF1C1C1E),
);''',
      builder: () => KruiSimpleButton(
        onPressed: () => KruiSnackbar.show(
          message: 'Link copied to clipboard',
          icon: Icons.link_rounded,
        ),
        child: const Text('Custom Snackbar'),
      ),
    ),
  ],
  demoBuilder: () => Wrap(
    spacing: 10,
    runSpacing: 10,
    children: [
      KruiSimpleButton(
        onPressed: () => KruiSnackbar.success(message: 'Saved!'),
        child: const Text('Success'),
      ),
      KruiSimpleButton(
        onPressed: () => KruiSnackbar.danger(message: 'Error occurred'),
        child: const Text('Danger'),
      ),
      KruiSimpleButton(
        onPressed: () => KruiSnackbar.warning(message: 'Please review'),
        child: const Text('Warning'),
      ),
      KruiSimpleButton(
        onPressed: () => KruiSnackbar.info(message: 'Update available'),
        child: const Text('Info'),
      ),
      KruiSimpleButton(
        onPressed: () => KruiSnackbar.success(
          message: 'Item deleted',
          actionLabel: 'Undo',
          onAction: () => KruiSnackbar.info(message: 'Undone!'),
        ),
        child: const Text('With action'),
      ),
    ],
  ),
);
