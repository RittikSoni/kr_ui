import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import 'package:provider/provider.dart';
import '../../config/component_models.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_provider.dart';

final kruiContentCardInfo = ComponentInfo(
  id: 'content-card',
  name: 'KruiContentCard',
  displayName: 'Content Card',
  description:
      'A modern, structured card with optional header, content, and footer. Clean elevation and dividers for dashboards, plans, notifications, and settings. No glass—optimized and accessible.',
  category: 'Cards',
  icon: Icons.dashboard_customize_outlined,
  properties: [
    const PropertyInfo(
      name: 'header',
      type: 'Widget?',
      defaultValue: 'null',
      description: 'Optional header (title, subtitle, trailing).',
    ),
    const PropertyInfo(
      name: 'content',
      type: 'Widget',
      defaultValue: 'required',
      description: 'Main body content.',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'footer',
      type: 'Widget?',
      defaultValue: 'null',
      description: 'Optional footer (actions, caption).',
    ),
    const PropertyInfo(
      name: 'padding',
      type: 'EdgeInsets?',
      defaultValue: 'EdgeInsets.fromLTRB(20, 16, 20, 16)',
      description: 'Padding inside the card.',
    ),
    const PropertyInfo(
      name: 'headerPadding',
      type: 'EdgeInsets?',
      defaultValue: 'null',
      description: 'Padding for header zone (defaults to padding).',
    ),
    const PropertyInfo(
      name: 'contentPadding',
      type: 'EdgeInsets?',
      defaultValue: 'null',
      description: 'Padding for content zone (defaults to padding).',
    ),
    const PropertyInfo(
      name: 'footerPadding',
      type: 'EdgeInsets?',
      defaultValue: 'null',
      description: 'Padding for footer zone (defaults to padding).',
    ),
    const PropertyInfo(
      name: 'showHeaderDivider',
      type: 'bool',
      defaultValue: 'true',
      description: 'Show divider between header and content.',
    ),
    const PropertyInfo(
      name: 'showFooterDivider',
      type: 'bool',
      defaultValue: 'true',
      description: 'Show divider between content and footer.',
    ),
    const PropertyInfo(
      name: 'color',
      type: 'Color?',
      defaultValue: 'null',
      description: 'Card background (defaults to theme surface).',
    ),
    const PropertyInfo(
      name: 'elevation',
      type: 'double',
      defaultValue: '1',
      description: 'Shadow elevation (0 for flat).',
    ),
    const PropertyInfo(
      name: 'borderRadius',
      type: 'BorderRadius?',
      defaultValue: 'BorderRadius.circular(16)',
      description: 'Corner radius.',
    ),
    const PropertyInfo(
      name: 'onTap',
      type: 'VoidCallback?',
      defaultValue: 'null',
      description: 'Optional tap callback (makes card tappable).',
    ),
  ],
  basicExample: '''KruiContentCard(
  header: Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
  content: Text('Body content here'),
  footer: TextButton(onPressed: () {}, child: Text('Action')),
)''',
  advancedExample: '''KruiContentCard(
  header: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text('Pro Plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      Text('\$12/mo', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
    ],
  ),
  content: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('• Unlimited projects'),
      SizedBox(height: 4),
      Text('• Priority support'),
    ],
  ),
  footer: KruiGlassyButton(
    onPressed: () {},
    child: Text('Subscribe'),
  ),
  elevation: 2,
)''',
  presets: [
    PresetInfo(
      name: 'Basic',
      description: 'Header, content, and footer',
      code: '''KruiContentCard(
  header: Text('Card Title', style: TextStyle(fontWeight: FontWeight.bold)),
  content: Text('Body text goes here.'),
  footer: Text('Footer caption', style: TextStyle(fontSize: 12, color: Colors.grey)),
)''',
      builder: () => KruiContentCard(
        header: const Text(
          'Card Title',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: const Text('Body text goes here.'),
        footer: Text(
          'Footer caption',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ),
    ),
    PresetInfo(
      name: 'Subscription plan (real-world)',
      description: 'Plan card with price, features, and CTA',
      code: '''KruiContentCard(
  header: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text('Pro Plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      Text('\$12/mo', style: TextStyle(color: Color(0xFF34C759), fontWeight: FontWeight.w600)),
    ],
  ),
  content: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('• Unlimited projects'),
      SizedBox(height: 4),
      Text('• Priority support'),
      SizedBox(height: 4),
      Text('• Advanced analytics'),
    ],
  ),
  footer: KruiGlassyButton(
    onPressed: () {},
    child: Text('Subscribe'),
  ),
)''',
      builder: () => Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;
          final textColor = isDark ? Colors.white70 : Colors.black87;
          return KruiContentCard(
            header: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pro Plan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: textColor,
                  ),
                ),
                Text(
                  '\$12/mo',
                  style: const TextStyle(
                    color: Color(0xFF34C759),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('• Unlimited projects',
                    style: TextStyle(color: textColor)),
                const SizedBox(height: 4),
                Text('• Priority support', style: TextStyle(color: textColor)),
                const SizedBox(height: 4),
                Text('• Advanced analytics',
                    style: TextStyle(color: textColor)),
              ],
            ),
            footer: KruiGlassyButton(
              onPressed: () {},
              color: const Color(0xFF007AFF),
              child: const Text(
                'Subscribe',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ),
    ),
    PresetInfo(
      name: 'Notification / settings row',
      description: 'Single-line header with trailing, short content',
      code: '''KruiContentCard(
  showHeaderDivider: false,
  showFooterDivider: false,
  header: Row(
    children: [
      Icon(Icons.notifications_outlined, size: 20),
      SizedBox(width: 12),
      Expanded(child: Text('Push notifications')),
      Switch(value: true, onChanged: (_) {}),
    ],
  ),
  content: SizedBox.shrink(),
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
)''',
      builder: () => Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;
          final textColor = isDark ? Colors.white70 : Colors.black87;
          return KruiContentCard(
            showHeaderDivider: false,
            showFooterDivider: false,
            header: Row(
              children: [
                Icon(Icons.notifications_outlined, size: 20, color: textColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Push notifications',
                    style: TextStyle(color: textColor, fontSize: 15),
                  ),
                ),
                Switch(value: true, onChanged: (_) {}),
              ],
            ),
            content: const SizedBox.shrink(),
            contentPadding: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          );
        },
      ),
    ),
    PresetInfo(
      name: 'Tappable card',
      description: 'Whole card is tappable with ripple',
      code: '''KruiContentCard(
  onTap: () => print('Card tapped'),
  header: Text('Tap me', style: TextStyle(fontWeight: FontWeight.bold)),
  content: Text('This entire card responds to tap.'),
)''',
      builder: () => KruiContentCard(
        onTap: () {},
        header: const Text(
          'Tap me',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: const Text('This entire card responds to tap.'),
      ),
    ),
    PresetInfo(
      name: 'Flat (no elevation)',
      description: 'No shadow, minimal border',
      code: '''KruiContentCard(
  elevation: 0,
  border: Border.all(color: Colors.grey.shade300),
  header: Text('Flat card'),
  content: Text('No shadow.'),
)''',
      builder: () => KruiContentCard(
        elevation: 0,
        border: Border.all(color: Colors.grey.shade300),
        header: const Text(
          'Flat card',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('No shadow.'),
      ),
    ),
    PresetInfo(
      name: 'Scrollable list',
      description: 'Multiple cards in a scrollable list',
      code: '''ListView.builder(
  shrinkWrap: true,
  physics: ClampingScrollPhysics(),
  itemCount: 4,
  itemBuilder: (context, index) {
    return KruiContentCard(
      margin: EdgeInsets.only(bottom: 12),
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Item \${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('\${(index + 1) * 2}\$', style: TextStyle(color: Colors.green)),
        ],
      ),
      content: Text('Description for item \${index + 1}.'),
      footer: KruiSimpleButton(
        onPressed: () {},
        child: Text('View'),
      ),
    );
  },
)''',
      builder: () => Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          final dynamicTheme = DynamicTheme(themeProvider);
          final textColor = dynamicTheme.textPrimary;
          final secondaryColor = dynamicTheme.textSecondary;
          return SizedBox(
            height: 320,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 4,
              itemBuilder: (context, index) {
                return KruiContentCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  header: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Item ${index + 1}',
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '\$${(index + 1) * 2}',
                        style: const TextStyle(
                          color: Color(0xFF34C759),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    'Description for item ${index + 1}.',
                    style: TextStyle(color: secondaryColor, fontSize: 14),
                  ),
                  footer: KruiSimpleButton(
                    onPressed: () {},
                    child: const Text('View'),
                  ),
                );
              },
            ),
          );
        },
      ),
    ),
  ],
  demoBuilder: () => Builder(
    builder: (context) {
      final themeProvider = Provider.of<ThemeProvider>(context);
      final dynamicTheme = DynamicTheme(themeProvider);
      final textColor = dynamicTheme.textPrimary;
      final secondaryColor = dynamicTheme.textSecondary;
      return KruiContentCard(
        margin: const EdgeInsets.only(bottom: 16),
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pro Plan',
              style: AppTheme.h4.copyWith(color: textColor),
            ),
            Text(
              '\$12/mo',
              style: TextStyle(
                color: const Color(0xFF34C759),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('• Unlimited projects',
                style: TextStyle(color: secondaryColor)),
            const SizedBox(height: 4),
            Text('• Priority support', style: TextStyle(color: secondaryColor)),
          ],
        ),
        footer: KruiGlassyButton(
          onPressed: () {},
          color: dynamicTheme.primary,
          child: Text(
            'Subscribe',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      );
    },
  ),
);
