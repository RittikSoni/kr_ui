import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiToastInfo = ComponentInfo(
  id: 'toast',
  name: 'KruiToast',
  displayName: 'Toast Notification',
  description:
      'A premium glassmorphic toast notification. No BuildContext required—uses KruiInitializer.navigatorKey. Non-intrusive feedback at the bottom with smooth animations.',
  category: 'Feedback',
  icon: Icons.notifications_active_outlined,
  properties: [
    const PropertyInfo(
      name: 'message',
      type: 'String',
      defaultValue: 'required',
      description: 'The message text to display in the toast.',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'icon',
      type: 'IconData?',
      defaultValue: 'null',
      description: 'Optional icon to display before the message.',
    ),
    const PropertyInfo(
      name: 'duration',
      type: 'Duration',
      defaultValue: 'Duration(seconds: 3)',
      description: 'How long the toast should stay on screen.',
    ),
    const PropertyInfo(
      name: 'color',
      type: 'Color',
      defaultValue: 'Colors.white',
      description: 'The tint color of the glass toast.',
    ),
    const PropertyInfo(
      name: 'blur',
      type: 'double',
      defaultValue: '15',
      description: 'Glass blur intensity.',
    ),
    const PropertyInfo(
      name: 'opacity',
      type: 'double',
      defaultValue: '0.2',
      description: 'Background opacity.',
    ),
    const PropertyInfo(
      name: 'actionLabel',
      type: 'String?',
      defaultValue: 'null',
      description: 'Label for an optional action button.',
    ),
    const PropertyInfo(
      name: 'onAction',
      type: 'VoidCallback?',
      defaultValue: 'null',
      description: 'Callback when the action button is tapped.',
    ),
  ],
  basicExample: '''KruiToast.show(
  message: 'Success Notification',
);''',
  advancedExample: '''KruiToast.show(
  message: 'Premium Feedback',
  icon: Icons.star,
  actionLabel: 'UNDO',
  onAction: () => print('Undo tapped'),
  duration: Duration(seconds: 5),
  color: Colors.blue,
  blur: 20,
);''',
  presets: [
    PresetInfo(
      name: 'Action',
      description: 'Toast with interactive action button',
      code: '''KruiToast.show(
  message: 'Message Deleted',
  actionLabel: 'UNDO',
  onAction: () {},
);''',
      builder: () => KruiGlassyButton(
        onPressed: () => KruiToast.show(
          message: 'Message Deleted',
          actionLabel: 'UNDO',
          onAction: () => KruiToast.show(message: 'Restored!'),
        ),
        child: const Text('Action Toast'),
      ),
    ),
    PresetInfo(
      name: 'Success',
      description: 'Success state with green tint',
      code: '''KruiToast.show(
  message: 'Operation Successful!',
  icon: Icons.check_circle_outline,
  color: Colors.green,
);''',
      builder: () => KruiGlassyButton(
        onPressed: () => KruiToast.show(
          message: 'Operation Successful!',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        ),
        child: const Text('Success Toast'),
      ),
    ),
    PresetInfo(
      name: 'Error',
      description: 'Error state with red tint',
      code: '''KruiToast.show(
  message: 'Something went wrong.',
  icon: Icons.error_outline,
  color: Colors.red,
);''',
      builder: () => KruiGlassyButton(
        onPressed: () => KruiToast.show(
          message: 'Something went wrong.',
          icon: Icons.error_outline,
          color: Colors.red,
        ),
        child: const Text('Error Toast'),
      ),
    ),
  ],
  demoBuilder: () => KruiGlassyButton(
    onPressed: () => KruiToast.show(
      message: 'Glassmorphic feedback triggered!',
      icon: Icons.auto_awesome,
      color: const Color(0xFF007AFF),
    ),
    child: const Text('Trigger Toast'),
  ),
);
