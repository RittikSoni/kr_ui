import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Checkbox position relative to the label.
enum KruiCheckboxPosition {
  leading,
  trailing,
}

/// Modern checkbox with optional label and subtitle, link support, and position.
///
/// Use [labelLinkText] and [onLabelLinkTap] (or [subtitleLinkText] / [onSubtitleLinkTap])
/// to make part of the text tappable (e.g. "I agree to the Terms & Conditions" with "Terms & Conditions" as link).
class KruiCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? label;
  final String? subtitle;

  /// When set, the matching substring in [label] is made tappable and triggers [onLabelLinkTap].
  final String? labelLinkText;
  final VoidCallback? onLabelLinkTap;

  /// When set, the matching substring in [subtitle] is made tappable and triggers [onSubtitleLinkTap].
  final String? subtitleLinkText;
  final VoidCallback? onSubtitleLinkTap;
  final bool enabled;
  final KruiCheckboxPosition checkboxPosition;
  final Color? activeColor;
  final Color? labelColor;
  final Color? subtitleColor;

  const KruiCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.subtitle,
    this.labelLinkText,
    this.onLabelLinkTap,
    this.subtitleLinkText,
    this.onSubtitleLinkTap,
    this.enabled = true,
    this.checkboxPosition = KruiCheckboxPosition.leading,
    this.activeColor,
    this.labelColor,
    this.subtitleColor,
  });

  Widget _buildLabelWithLink(BuildContext context, String text,
      String? linkText, VoidCallback? onLinkTap, Color? color) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodyLarge ?? const TextStyle();
    final style =
        baseStyle.copyWith(color: color ?? theme.colorScheme.onSurface);
    final linkStyle = baseStyle.copyWith(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
      decorationColor: theme.colorScheme.primary,
    );

    if (linkText == null || linkText.isEmpty || onLinkTap == null) {
      return Text(text, style: style);
    }
    final idx = text.indexOf(linkText);
    if (idx < 0) {
      return Text(text, style: style);
    }
    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: linkText,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                HapticFeedback.lightImpact();
                onLinkTap();
              },
          ),
          TextSpan(text: text.substring(idx + linkText.length)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final checkbox = SizedBox(
      width: 24,
      height: 24,
      child: Checkbox(
        value: value,
        onChanged: enabled ? (v) => onChanged(v) : null,
        activeColor: activeColor ?? theme.colorScheme.primary,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
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
                _buildLabelWithLink(
                    context, label!, labelLinkText, onLabelLinkTap, labelColor),
                const SizedBox(height: 2),
                _buildLabelWithLink(context, subtitle!, subtitleLinkText,
                    onSubtitleLinkTap, subtitleColor),
              ],
            )
          : _buildLabelWithLink(
              context, label!, labelLinkText, onLabelLinkTap, labelColor);
    }

    final rowChildren = checkboxPosition == KruiCheckboxPosition.leading
        ? [
            checkbox,
            if (content != null) ...[
              const SizedBox(width: 12),
              Expanded(child: content)
            ],
          ]
        : [
            if (content != null) ...[
              Expanded(child: content),
              const SizedBox(width: 12)
            ],
            checkbox,
          ];

    return InkWell(
      onTap: enabled
          ? () {
              HapticFeedback.selectionClick();
              onChanged(!value);
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowChildren,
        ),
      ),
    );
  }
}
