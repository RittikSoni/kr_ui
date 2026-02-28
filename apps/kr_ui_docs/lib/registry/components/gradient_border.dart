import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiGradientBorderInfo = ComponentInfo(
  id: 'gradient-border',
  name: 'KruiGradientBorder',
  displayName: 'Gradient Border',
  description:
      'A zero-dependency, production-grade gradient border wrapper. Features various animated and static variants perfect for cards, avatars, drop zones, statuses, and focused inputs.',
  category: 'Containers',
  icon: Icons.border_outer_rounded,
  properties: [
    const PropertyInfo(
      name: 'child',
      type: 'Widget',
      defaultValue: 'required',
      description: 'The widget to display inside the border',
      isRequired: true,
    ),
    const PropertyInfo(
      name: 'style',
      type: 'KruiGradientBorderStyle',
      defaultValue: 'const KruiGradientBorderStyle()',
      description: 'Configuration for colors, widths, radiuses, and timings',
    ),
    const PropertyInfo(
      name: 'variant',
      type: 'KruiGradientBorderVariant',
      defaultValue: 'KruiGradientBorderVariant.staticGradient',
      description:
          'The visual variant to render (shimmer, rotating, breathing, glow, dashed, underline, etc.)',
    ),
    const PropertyInfo(
      name: 'externalController',
      type: 'AnimationController?',
      defaultValue: 'null',
      description:
          'Caller-owned controller for advanced syncing with focus or scroll',
    ),
    const PropertyInfo(
      name: 'onAnimationComplete',
      type: 'VoidCallback?',
      defaultValue: 'null',
      description: 'Called when loop = false and the animation finishes',
    ),
  ],
  basicExample: '''KruiGradientBorder(
  style: KruiGradientBorderStyle(
    colors: [Colors.purple, Colors.cyan],
    borderWidth: 2.5,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Gradient Border'),
  ),
)''',
  advancedExample: '''// External Controller Example
final ctrl = AnimationController(vsync: this, duration: Duration(seconds: 2));

KruiGradientBorder(
  variant: KruiGradientBorderVariant.rotating,
  externalController: ctrl,
  onAnimationComplete: () {},
  style: KruiGradientBorderStyle(
    colors: [Colors.orange, Colors.amber, Colors.lightGreen, Colors.orange],
    borderWidth: 2.5,
    borderRadius: BorderRadius.circular(14),
  ),
  child: Container(
    padding: EdgeInsets.all(20),
    child: Text('Hover to Rotate'),
  ),
)''',
  presets: [
    PresetInfo(
      name: 'Circular Avatar (Rotating)',
      description: 'Rotating variant applied to a circular avatar',
      code: '''KruiGradientBorder.rotating(
  borderWidth: 2.5,
  borderRadius: BorderRadius.circular(30),
  duration: const Duration(seconds: 4),
  child: Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      color: const Color(0xFF1A1A2E),
    ),
    child: const Center(
      child: Text('A', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
    ),
  ),
)''',
      builder: () => const _AvatarDemo(),
    ),
    PresetInfo(
      name: 'Static Gradient',
      description:
          'Cards · Containers · Any decorative border with zero runtime cost',
      code: '''KruiGradientBorder(
  style: const KruiGradientBorderStyle(
    colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
    borderWidth: 2.0,
    borderRadius: BorderRadius.all(Radius.circular(14)),
  ),
  child: _DemoTile(
    icon: Icons.credit_card_rounded,
    label: 'Payment Card',
    sub: 'Static gradient border',
  ),
)''',
      builder: () => KruiGradientBorder(
        style: const KruiGradientBorderStyle(
          colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
          borderWidth: 2.0,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: const _DemoTile(
          icon: Icons.credit_card_rounded,
          label: 'Payment Card',
          sub: 'Static gradient border',
        ),
      ),
    ),
    PresetInfo(
      name: 'Rotating',
      description:
          'Featured cards · Avatar rings · Premium plan badges · Hero CTAs',
      code: '''KruiGradientBorder.rotating(
  colors: const [Color(0xFF8B5CF6), Color(0xFF06B6D4), Color(0xFFEC4899), Color(0xFF8B5CF6)],
  borderWidth: 2.5,
  borderRadius: BorderRadius.circular(14),
  duration: const Duration(seconds: 3),
  child: _DemoTile(
    icon: Icons.stars_rounded,
    label: 'Featured Plan',
    sub: 'Rotating conic gradient',
  ),
)''',
      builder: () => KruiGradientBorder.rotating(
        colors: const [
          Color(0xFF8B5CF6),
          Color(0xFF06B6D4),
          Color(0xFFEC4899),
          Color(0xFF8B5CF6)
        ],
        borderWidth: 2.5,
        borderRadius: BorderRadius.circular(14),
        duration: const Duration(seconds: 3),
        child: const _DemoTile(
          icon: Icons.stars_rounded,
          label: 'Featured Plan',
          sub: 'Rotating conic gradient',
        ),
      ),
    ),
    PresetInfo(
      name: 'Shimmer',
      description:
          'Loading skeletons · Focus ring on TextFields · Skeleton screens',
      code: '''KruiGradientBorder.shimmer(
  duration: const Duration(milliseconds: 1500),
  child: _DemoTile(
    icon: Icons.search_rounded,
    label: 'Search Field',
    sub: 'Shimmer sweep border',
  ),
)''',
      builder: () => KruiGradientBorder.shimmer(
        duration: const Duration(milliseconds: 1500),
        child: const _DemoTile(
          icon: Icons.search_rounded,
          label: 'Search Field',
          sub: 'Shimmer sweep border',
        ),
      ),
    ),
    PresetInfo(
      name: 'Breathing',
      description:
          'Live status indicators · AI engine cards · "Online" badges · Recording states',
      code: '''KruiGradientBorder.breathing(
  colors: const [Color(0xFF10B981), Color(0xFF06B6D4), Color(0xFF6366F1)],
  glowSpread: 10,
  borderWidth: 1.5,
  minOpacity: 0.2,
  duration: const Duration(seconds: 2),
  child: _DemoTile(
    icon: Icons.wifi_tethering_rounded,
    label: 'AI Engine Live',
    sub: 'Breathing sine-wave pulse',
  ),
)''',
      builder: () => KruiGradientBorder.breathing(
        colors: const [Color(0xFF10B981), Color(0xFF06B6D4), Color(0xFF6366F1)],
        glowSpread: 10,
        borderWidth: 1.5,
        minOpacity: 0.2,
        duration: const Duration(seconds: 2),
        child: const _DemoTile(
          icon: Icons.wifi_tethering_rounded,
          label: 'AI Engine Live',
          sub: 'Breathing sine-wave pulse',
        ),
      ),
    ),
    PresetInfo(
      name: 'Glow',
      description:
          'Active plan badge · Premium tier · Neon / cyberpunk UI · Selected state',
      code: '''KruiGradientBorder.glow(
  glowColor: const Color(0xFF06B6D4),
  glowSpread: 12,
  borderWidth: 1.5,
  borderRadius: BorderRadius.circular(14),
  child: _DemoTile(
    icon: Icons.workspace_premium_rounded,
    label: 'Pro Active',
    sub: 'Neon glow — 3 layered blur draws',
  ),
)''',
      builder: () => KruiGradientBorder.glow(
        glowColor: const Color(0xFF06B6D4),
        glowSpread: 12,
        borderWidth: 1.5,
        borderRadius: BorderRadius.circular(14),
        child: const _DemoTile(
          icon: Icons.workspace_premium_rounded,
          label: 'Pro Active',
          sub: 'Neon glow — 3 layered blur draws',
        ),
      ),
    ),
    PresetInfo(
      name: 'Dashed',
      description:
          'Drop zones · Import areas · Empty-state placeholders · Pending containers',
      code: '''KruiGradientBorder.dashed(
  dashLength: 10,
  gapLength: 6,
  colors: const [Color(0xFFF59E0B), Color(0xFFEF4444), Color(0xFF8B5CF6)],
  borderWidth: 1.5,
  borderRadius: BorderRadius.circular(14),
  child: _DemoTile(
    icon: Icons.upload_file_rounded,
    label: 'Drop Zone',
    sub: 'Dashed via path metrics',
  ),
)''',
      builder: () => KruiGradientBorder.dashed(
        dashLength: 10,
        gapLength: 6,
        colors: const [Color(0xFFF59E0B), Color(0xFFEF4444), Color(0xFF8B5CF6)],
        borderWidth: 1.5,
        borderRadius: BorderRadius.circular(14),
        child: const _DemoTile(
          icon: Icons.upload_file_rounded,
          label: 'Drop Zone',
          sub: 'Dashed via path metrics',
        ),
      ),
    ),
    PresetInfo(
      name: 'Underline',
      description: 'Tab bars · Section headings · Nav items · Active list rows',
      code: '''KruiGradientBorder.underline(
  colors: const [Color(0xFF8B5CF6), Color(0xFFEC4899), Color(0xFF06B6D4)],
  lineHeight: 2.5,
  child: _DemoTile(
    icon: Icons.tab_rounded,
    label: 'Active Tab',
    sub: 'Bottom-edge gradient only',
  ),
)''',
      builder: () => KruiGradientBorder.underline(
        colors: const [Color(0xFF8B5CF6), Color(0xFFEC4899), Color(0xFF06B6D4)],
        lineHeight: 2.5,
        child: const _DemoTile(
          icon: Icons.tab_rounded,
          label: 'Active Tab',
          sub: 'Bottom-edge gradient only',
        ),
      ),
    ),
  ],
  demoBuilder: () => Builder(
    builder: (context) => KruiGradientBorder.rotating(
      colors: const [
        Color(0xFF8B5CF6),
        Color(0xFF06B6D4),
        Color(0xFFEC4899),
        Color(0xFF8B5CF6)
      ],
      borderWidth: 2.5,
      borderRadius: BorderRadius.circular(16),
      duration: const Duration(seconds: 3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F1A),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars_rounded, color: Color(0xFF06B6D4), size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Pro Plan',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text('Active and fully featured',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6))),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
);

// ─────────────────────────────────────────────────────────────────────────────
// Real-world examples
// ─────────────────────────────────────────────────────────────────────────────

class _DemoTile extends StatelessWidget {
  const _DemoTile({required this.icon, required this.label, required this.sub});
  final IconData icon;
  final String label;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // Prevents blowing out full width in flex layouts
        children: [
          Icon(icon, size: 22, color: Colors.white.withValues(alpha: 0.6)),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              const SizedBox(height: 3),
              Text(sub,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.38))),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarDemo extends StatelessWidget {
  const _AvatarDemo();

  @override
  Widget build(BuildContext context) {
    return KruiGradientBorder.rotating(
      borderWidth: 2.5,
      borderRadius: BorderRadius.circular(30),
      duration: const Duration(seconds: 4),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: const Color(0xFF1A1A2E),
        ),
        child: const Center(
          child: Text('A',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ),
      ),
    );
  }
}
