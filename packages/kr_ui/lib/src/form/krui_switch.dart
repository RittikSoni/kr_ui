import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Switch position relative to the label.
enum KruiSwitchPosition {
  leading,
  trailing,
}

/// Modern switch with optional label and subtitle, position, and color customization.
class KruiSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final String? subtitle;
  final bool enabled;
  final KruiSwitchPosition switchPosition;

  /// Active (on) track color.
  final Color? activeTrackColor;

  /// Active (on) thumb color.
  final Color? activeThumbColor;

  /// Inactive (off) track color.
  final Color? inactiveTrackColor;

  /// Inactive (off) thumb color.
  final Color? inactiveThumbColor;
  final Color? labelColor;
  final Color? subtitleColor;

  const KruiSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.subtitle,
    this.enabled = true,
    this.switchPosition = KruiSwitchPosition.trailing,
    this.activeTrackColor,
    this.activeThumbColor,
    this.inactiveTrackColor,
    this.inactiveThumbColor,
    this.labelColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor =
        activeTrackColor ?? activeThumbColor ?? theme.colorScheme.primary;

    Widget switchWidget = Switch(
      value: value,
      onChanged: enabled ? (v) => onChanged(v) : null,
      activeTrackColor: activeTrackColor ?? activeColor.withValues(alpha: 0.5),
      activeThumbColor: activeThumbColor ?? activeColor,
      inactiveTrackColor: inactiveTrackColor,
      inactiveThumbColor: inactiveThumbColor,
    );

    final labelColor = this.labelColor ?? theme.colorScheme.onSurface;
    final subtitleColor = this.subtitleColor ?? theme.hintColor;

    Widget? content;
    if (label != null) {
      content = subtitle != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label!,
                    style:
                        theme.textTheme.bodyLarge?.copyWith(color: labelColor)),
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style:
                      theme.textTheme.bodySmall?.copyWith(color: subtitleColor),
                ),
              ],
            )
          : Text(label!,
              style: theme.textTheme.bodyLarge?.copyWith(color: labelColor));
    }

    final rowChildren = switchPosition == KruiSwitchPosition.leading
        ? [
            switchWidget,
            if (content != null) ...[
              const SizedBox(width: 16),
              Expanded(child: content)
            ],
          ]
        : [
            if (content != null) ...[
              Expanded(child: content),
              const SizedBox(width: 16)
            ],
            switchWidget,
          ];

    return InkWell(
      onTap: enabled
          ? () {
              HapticFeedback.lightImpact();
              onChanged(!value);
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: rowChildren,
        ),
      ),
    );
  }
}
