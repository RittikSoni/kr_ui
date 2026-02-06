import 'package:flutter/material.dart';

/// A modern, structured card with optional header, content, and footer.
///
/// Designed for clarity and hierarchy—ideal for dashboards, settings,
/// subscription plans, notifications, and list items. Clean elevation,
/// consistent padding, and optional dividers keep layouts scannable.
///
/// ## Basic usage
///
/// ```dart
/// KruiContentCard(
///   header: Text('Title'),
///   content: Text('Body text here'),
///   footer: TextButton(onPressed: () {}, child: Text('Action')),
/// )
/// ```
///
/// ## Real-world example (plan card)
///
/// ```dart
/// KruiContentCard(
///   header: Row(
///     mainAxisAlignment: MainAxisAlignment.spaceBetween,
///     children: [
///       Text('Pro Plan', style: TextStyle(fontWeight: FontWeight.bold)),
///       Text('\$12/mo', style: TextStyle(color: Colors.green)),
///     ],
///   ),
///   content: Column(
///     crossAxisAlignment: CrossAxisAlignment.start,
///     children: [
///       Text('• Unlimited projects'),
///       Text('• Priority support'),
///     ],
///   ),
///   footer: KruiGlassyButton(
///     onPressed: () {},
///     child: Text('Subscribe'),
///   ),
/// )
/// ```
class KruiContentCard extends StatelessWidget {
  /// Optional header (title, subtitle, trailing). Shown above content.
  final Widget? header;

  /// Main body. Required.
  final Widget content;

  /// Optional footer (actions, caption). Shown below content.
  final Widget? footer;

  /// Padding around the entire card (outside the surface).
  final EdgeInsets? margin;

  /// Padding inside the card surface.
  final EdgeInsets? padding;

  /// Padding for the header zone only. Defaults to [padding] if null.
  final EdgeInsets? headerPadding;

  /// Padding for the content zone only. Defaults to [padding] if null.
  final EdgeInsets? contentPadding;

  /// Padding for the footer zone only. Defaults to [padding] if null.
  final EdgeInsets? footerPadding;

  /// Whether to show a divider between header and content.
  final bool showHeaderDivider;

  /// Whether to show a divider between content and footer.
  final bool showFooterDivider;

  /// Background color of the card. Defaults to a light/dark surface when null.
  final Color? color;

  /// Corner radius of the card.
  final BorderRadius? borderRadius;

  /// Border. Omitted when null.
  final Border? border;

  /// Elevation (shadow). Use 0 for flat cards.
  final double elevation;

  /// Shadow color. Defaults to black with low opacity when null.
  final Color? shadowColor;

  /// Callback when the card is tapped. If null, the card is not tappable.
  final VoidCallback? onTap;

  /// Clip behavior for the card shape (e.g. rounded corners).
  final Clip clipBehavior;

  const KruiContentCard({
    super.key,
    this.header,
    required this.content,
    this.footer,
    this.margin,
    this.padding,
    this.headerPadding,
    this.contentPadding,
    this.footerPadding,
    this.showHeaderDivider = true,
    this.showFooterDivider = true,
    this.color,
    this.borderRadius,
    this.border,
    this.elevation = 1,
    this.shadowColor,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
  });

  static const EdgeInsets _defaultPadding = EdgeInsets.fromLTRB(20, 16, 20, 16);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final surfaceColor = color ??
        (brightness == Brightness.dark
            ? const Color(0xFF2C2C2E)
            : Colors.white);
    final effectivePadding = padding ?? _defaultPadding;
    final headerPad = headerPadding ?? effectivePadding;
    final contentPad = contentPadding ?? effectivePadding;
    final footerPad = footerPadding ?? effectivePadding;
    final radius = borderRadius ?? BorderRadius.circular(16);
    final dividerColor = brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null) ...[
          Padding(padding: headerPad, child: header),
          if (showHeaderDivider)
            Divider(height: 1, thickness: 1, color: dividerColor),
        ],
        Padding(padding: contentPad, child: content),
        if (footer != null) ...[
          if (showFooterDivider)
            Divider(height: 1, thickness: 1, color: dividerColor),
          Padding(padding: footerPad, child: footer),
        ],
      ],
    );

    final scrollableContent = SingleChildScrollView(
      child: column,
    );

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: radius,
        border: border,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: shadowColor ?? Colors.black.withValues(alpha: 0.06),
                  blurRadius: elevation * 8,
                  offset: Offset(0, elevation * 2),
                ),
              ]
            : null,
      ),
      clipBehavior: clipBehavior,
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: radius,
                child: scrollableContent,
              ),
            )
          : scrollableContent,
    );

    return card;
  }
}
