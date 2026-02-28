// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENUMS & TYPEDEFS
// ─────────────────────────────────────────────────────────────────────────────

/// Visual style variant for chips.
enum KruiChipVariant {
  /// iOS-style frosted glass effect.
  glassy,

  /// Clean, flat material-style chip.
  simple,
}

/// Size preset for chips.
enum KruiChipSize {
  /// Compact — ideal for dense UIs and tag clouds.
  small,

  /// Default balanced size.
  medium,

  /// Spacious — ideal for primary filter bars.
  large,
}

/// Controls how many chips can be selected simultaneously in a [KruiChipGroup].
enum KruiChipGroupSelectionMode {
  /// No selection interaction — display only.
  none,

  /// Exactly one chip may be selected at a time (radio behaviour).
  single,

  /// Any number of chips may be selected.
  multi,
}

/// Controls how the chip group lays out its chips.
enum KruiChipGroupLayout {
  /// Wraps chips across multiple rows (default).
  wrap,

  /// Single horizontal scrollable row.
  scrollableRow,
}

typedef KruiChipOnTap = void Function(String chipId, bool isSelected);
typedef KruiChipOnClose = void Function(String chipId);

// ─────────────────────────────────────────────────────────────────────────────
// KruiTagChipData  (immutable value object)
// ─────────────────────────────────────────────────────────────────────────────

/// Immutable data class representing a single chip item inside a [KruiChipGroup].
///
/// ## Standard usage
/// ```dart
/// KruiTagChipData(id: 'flutter', label: 'Flutter', icon: Icons.flutter_dash)
/// ```
///
/// ## Fully custom chip content
/// When [customChild] is provided it **completely replaces** the built-in
/// label / icon / avatar row. You can pass any widget — `Image`, `SvgPicture`,
/// `Row`, `Column`, `RichText`, a custom painted widget, etc.
///
/// The surface (glass / simple), border, selection highlight, press scale,
/// hover glow, haptics and accessibility wrapper are **always** applied,
/// regardless of whether [customChild] is set.
///
/// ```dart
/// KruiTagChipData(
///   id: 'custom',
///   label: 'My chip',          // still used for semantics / accessibility
///   customChild: Row(
///     mainAxisSize: MainAxisSize.min,
///     children: [
///       Image.asset('assets/flag.png', width: 18, height: 18),
///       const SizedBox(width: 6),
///       const Text('English', style: TextStyle(color: Colors.white)),
///     ],
///   ),
/// )
/// ```
@immutable
class KruiTagChipData {
  /// Unique identifier used by selection callbacks.
  final String id;

  /// Display text for the chip.
  ///
  /// Used for semantics / accessibility even when [customChild] is set.
  /// When [customChild] is null this is rendered as the chip label.
  final String label;

  /// Optional leading icon. Ignored when [avatar] or [customChild] is non-null.
  final IconData? icon;

  /// Optional leading image widget (e.g. CircleAvatar, Image, SvgPicture).
  /// Takes precedence over [icon]. Ignored when [customChild] is non-null.
  final Widget? avatar;

  /// **Fully custom chip content widget.**
  ///
  /// When non-null, this widget is rendered as the entire chip body —
  /// [label], [icon], and [avatar] are not shown (though [label] is still
  /// used for semantics).
  ///
  /// The chip surface (glass blur / background / border / animations) is
  /// always rendered around [customChild].
  ///
  /// Padding is applied around [customChild] using the group's size preset
  /// unless you include your own padding inside the widget.
  final Widget? customChild;

  /// When [customChild] is set, controls whether the size-preset padding is
  /// still applied around it. Set to `false` if your custom widget manages
  /// its own padding/sizing.
  final bool applyPaddingToCustomChild;

  /// Whether this chip should render in a disabled / non-interactive state.
  final bool isDisabled;

  /// Per-chip colour override. Falls back to the group-level colour scheme
  /// when null.
  final Color? accentColor;

  /// Optional semantic label for accessibility.
  /// Defaults to [label] when null.
  final String? semanticLabel;

  const KruiTagChipData({
    required this.id,
    required this.label,
    this.icon,
    this.avatar,
    this.customChild,
    this.applyPaddingToCustomChild = true,
    this.isDisabled = false,
    this.accentColor,
    this.semanticLabel,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KruiTagChipData &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  KruiTagChipData copyWith({
    String? id,
    String? label,
    IconData? icon,
    Widget? avatar,
    Widget? customChild,
    bool? applyPaddingToCustomChild,
    bool? isDisabled,
    Color? accentColor,
    String? semanticLabel,
  }) {
    return KruiTagChipData(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      avatar: avatar ?? this.avatar,
      customChild: customChild ?? this.customChild,
      applyPaddingToCustomChild:
          applyPaddingToCustomChild ?? this.applyPaddingToCustomChild,
      isDisabled: isDisabled ?? this.isDisabled,
      accentColor: accentColor ?? this.accentColor,
      semanticLabel: semanticLabel ?? this.semanticLabel,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KruiTagChip  — standalone chip widget
// ─────────────────────────────────────────────────────────────────────────────

/// A single, fully customisable tag chip supporting both **Glassy** (frosted
/// glass) and **Simple** (flat material) variants.
///
/// ## Standard usage
/// ```dart
/// KruiTagChip(
///   label: 'Flutter',
///   icon: Icons.flutter_dash,
///   isSelected: _selected,
///   onTap: () => setState(() => _selected = !_selected),
/// )
/// ```
///
/// ## Fully custom chip body
/// Pass any widget as [child] to replace the built-in label/icon row entirely.
/// The surface (glass blur, border, selection tint, press scale, hover, haptics,
/// semantics) is **always** applied regardless.
///
/// ```dart
/// KruiTagChip(
///   label: 'English',          // still used for semantics
///   child: Row(
///     mainAxisSize: MainAxisSize.min,
///     children: [
///       Image.network('https://…/flag.png', width: 18),
///       const SizedBox(width: 6),
///       const Text('English', style: TextStyle(color: Colors.white, fontSize: 13)),
///     ],
///   ),
/// )
/// ```
///
/// ## Edge cases handled
/// - Null / empty label gracefully falls back to an empty string.
/// - Overflow labels are ellipsis-truncated with a configurable max-width.
/// - Disabled state blocks interaction and reduces opacity.
/// - Delete/close button fires a dedicated callback independent of tap.
/// - Animated selection transition with a configurable duration.
/// - Haptic feedback on interaction (configurable).
/// - RTL layout support.
/// - `semanticsLabel` for screen-readers.
/// - Custom [child] is never forced into a fixed-size box — it sizes naturally.
class KruiTagChip extends StatefulWidget {
  // ── Content ──────────────────────────────────────────────────────────────
  /// Text displayed inside the chip (standard mode).
  ///
  /// Also used as the accessibility / semantics label even when [child] is set.
  final String label;

  /// Optional leading icon. Ignored when [avatar] or [child] is non-null.
  final IconData? icon;

  /// Optional leading widget (e.g. CircleAvatar, Image, SvgPicture).
  /// Takes precedence over [icon]. Ignored when [child] is non-null.
  final Widget? avatar;

  /// **Fully custom chip body widget.**
  ///
  /// When non-null this widget is rendered as the entire chip interior —
  /// [label], [icon], and [avatar] are not rendered visually (but [label]
  /// is still used for semantics / accessibility).
  ///
  /// The glass/simple surface, press-scale animation, hover glow, haptics,
  /// disabled opacity, and delete icon are all still applied.
  ///
  /// Example: an image + text row, an SVG, a badge stack, a gradient text,
  /// a `Column`, a `RichText`, a custom-painted widget — anything goes.
  final Widget? child;

  /// When [child] is set, controls whether the size-preset padding is applied
  /// around it automatically. Set to `false` if your widget manages its own
  /// padding or you want zero internal padding (e.g. a full-bleed image chip).
  final bool applyPaddingToChild;

  // ── State ─────────────────────────────────────────────────────────────────
  /// Whether the chip is currently in a selected state.
  final bool isSelected;

  /// When true the chip renders in a dimmed, non-interactive state.
  final bool isDisabled;

  /// When true a close/remove icon is shown on the trailing edge.
  /// Works in both standard and [child] modes.
  final bool isDeletable;

  // ── Styling ───────────────────────────────────────────────────────────────
  /// Glassmorphic or flat material style.
  final KruiChipVariant variant;

  /// Compact, medium, or large size preset.
  final KruiChipSize size;

  /// Primary accent colour (border highlight, selected tint, icon colour).
  final Color? accentColor;

  /// Chip background colour override. Auto-derived when null.
  final Color? backgroundColor;

  /// Label text colour override.
  final Color? labelColor;

  /// Selected-state background colour. Auto-derived when null.
  final Color? selectedColor;

  /// Border radius override. Falls back to a pill shape when null.
  final BorderRadius? borderRadius;

  /// Explicit max-width for the chip. Prevents layout overflow in tight spaces.
  final double? maxWidth;

  // ── Glass-specific ────────────────────────────────────────────────────────
  /// BackdropFilter blur strength (glassy variant only).
  final double blurSigma;

  /// Glass surface opacity (0.0 – 1.0).
  final double glassOpacity;

  // ── Animation ─────────────────────────────────────────────────────────────
  /// Duration of the selection state transition animation.
  final Duration animationDuration;

  // ── Interaction ───────────────────────────────────────────────────────────
  /// Called when the chip body is tapped.
  final VoidCallback? onTap;

  /// Called when the delete icon is tapped.
  final VoidCallback? onDeleted;

  /// When true a haptic pulse fires on tap.
  final bool enableHaptics;

  /// Semantic accessibility label.
  final String? semanticsLabel;

  // ── Text style ────────────────────────────────────────────────────────────
  /// Override the auto-computed label [TextStyle] (standard mode only).
  final TextStyle? labelStyle;

  const KruiTagChip({
    super.key,
    required this.label,
    this.icon,
    this.avatar,
    this.child,
    this.applyPaddingToChild = true,
    this.isSelected = false,
    this.isDisabled = false,
    this.isDeletable = false,
    this.variant = KruiChipVariant.glassy,
    this.size = KruiChipSize.medium,
    this.accentColor,
    this.backgroundColor,
    this.labelColor,
    this.selectedColor,
    this.borderRadius,
    this.maxWidth,
    this.blurSigma = 12.0,
    this.glassOpacity = 0.18,
    this.animationDuration = const Duration(milliseconds: 200),
    this.onTap,
    this.onDeleted,
    this.enableHaptics = true,
    this.semanticsLabel,
    this.labelStyle,
  });

  @override
  State<KruiTagChip> createState() => _KruiTagChipState();
}

class _KruiTagChipState extends State<KruiTagChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Sizing helpers ────────────────────────────────────────────────────────

  EdgeInsets get _padding {
    switch (widget.size) {
      case KruiChipSize.small:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 5);
      case KruiChipSize.medium:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 8);
      case KruiChipSize.large:
        return const EdgeInsets.symmetric(horizontal: 18, vertical: 11);
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case KruiChipSize.small:
        return 11.0;
      case KruiChipSize.medium:
        return 13.0;
      case KruiChipSize.large:
        return 15.0;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case KruiChipSize.small:
        return 12.0;
      case KruiChipSize.medium:
        return 15.0;
      case KruiChipSize.large:
        return 18.0;
    }
  }

  double get _deleteIconSize {
    switch (widget.size) {
      case KruiChipSize.small:
        return 13.0;
      case KruiChipSize.medium:
        return 15.0;
      case KruiChipSize.large:
        return 17.0;
    }
  }

  double get _avatarSize {
    switch (widget.size) {
      case KruiChipSize.small:
        return 16.0;
      case KruiChipSize.medium:
        return 20.0;
      case KruiChipSize.large:
        return 24.0;
    }
  }

  // ── Colour helpers ────────────────────────────────────────────────────────

  Color get _resolvedAccent => widget.accentColor ?? const Color(0xFF6C63FF);

  Color _glassBackground(BuildContext context) {
    if (widget.isSelected) {
      return (widget.selectedColor ?? _resolvedAccent)
          .withValues(alpha: widget.glassOpacity + 0.12);
    }
    return (widget.backgroundColor ??
            (Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.white))
        .withValues(alpha: widget.glassOpacity);
  }

  Color _simpleBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (widget.isSelected) {
      // Solid filled background — no opacity tricks, no translucency.
      if (widget.selectedColor != null) return widget.selectedColor!;
      // Flat tint: blend accent into the surface at a fixed alpha.
      return isDark
          ? Color.alphaBlend(
              _resolvedAccent.withValues(alpha: 0.28), const Color(0xFF1E1E1E))
          : Color.alphaBlend(
              _resolvedAccent.withValues(alpha: 0.13), Colors.white);
    }
    // Unselected: fully opaque surface — no opacity manipulation.
    return widget.backgroundColor ??
        (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF3F4F6));
  }

  /// Hover tint for simple variant — solid colour shift, no opacity tricks.
  Color _simpleHoverBackground(BuildContext context) {
    final base = _simpleBackground(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Color.alphaBlend(Colors.white.withValues(alpha: 0.06), base)
        : Color.alphaBlend(Colors.black.withValues(alpha: 0.04), base);
  }

  Color get _labelColor {
    if (widget.labelColor != null) return widget.labelColor!;
    if (widget.isSelected) return _resolvedAccent;
    return Colors.white;
  }

  Color get _simpleLabelColor {
    if (widget.labelColor != null) return widget.labelColor!;
    if (widget.isSelected) {
      // Use the full-opacity accent as the label colour so it reads clearly
      // on the solid tinted background computed by _simpleBackground.
      // We darken it slightly on light surfaces for better contrast.
      return _resolvedAccent;
    }
    return Colors.black87;
  }

  BorderRadius get _borderRadius =>
      widget.borderRadius ?? BorderRadius.circular(100);

  // ── Interaction handlers ──────────────────────────────────────────────────

  void _handleTap() {
    if (widget.isDisabled) return;
    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
    widget.onTap?.call();
  }

  void _handleDelete() {
    if (widget.isDisabled) return;
    if (widget.enableHaptics) {
      HapticFeedback.selectionClick();
    }
    widget.onDeleted?.call();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isInteractive =
        !widget.isDisabled && (widget.onTap != null || widget.isDeletable);

    final chip = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: Semantics(
        label: widget.semanticsLabel ?? widget.label,
        selected: widget.isSelected,
        button: isInteractive,
        enabled: !widget.isDisabled,
        child: AnimatedOpacity(
          opacity: widget.isDisabled ? 0.42 : 1.0,
          duration: widget.animationDuration,
          child: widget.variant == KruiChipVariant.glassy
              ? _GlassyChipSurface(
                  blurSigma: widget.blurSigma,
                  backgroundColor: _glassBackground(context),
                  borderRadius: _borderRadius,
                  isSelected: widget.isSelected,
                  accentColor: _resolvedAccent,
                  animationDuration: widget.animationDuration,
                  isHovered: _isHovered,
                  child: _chipContent(context, isGlassy: true),
                )
              : _SimpleChipSurface(
                  backgroundColor: _simpleBackground(context),
                  hoverBackgroundColor: _simpleHoverBackground(context),
                  borderRadius: _borderRadius,
                  isSelected: widget.isSelected,
                  accentColor: _resolvedAccent,
                  animationDuration: widget.animationDuration,
                  isHovered: _isHovered,
                  child: _chipContent(context, isGlassy: false),
                ),
        ),
      ),
    );

    if (!isInteractive) return chip;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth ?? double.infinity),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) {
            _controller.forward();
          },
          onTapUp: (_) {
            _controller.reverse();
            _handleTap();
          },
          onTapCancel: () {
            _controller.reverse();
          },
          child: chip,
        ),
      ),
    );
  }

  Widget _chipContent(BuildContext context, {required bool isGlassy}) {
    // ── CUSTOM CHILD MODE ───────────────────────────────────────────────────
    // When a custom child is supplied, render it as the whole chip body.
    // The delete icon is still appended when [isDeletable] is true so that
    // deletable chips work regardless of the content mode.
    if (widget.child != null) {
      // Close icon colour: derive from accent / white depending on variant.
      final Color closeColor = isGlassy
          ? Colors.white.withValues(alpha: 0.75)
          : (widget.isSelected ? _resolvedAccent : Colors.black54);

      // If deletable, we must wrap in a Row to append the close icon.
      // Otherwise, just apply padding (or not) and return.
      if (widget.isDeletable) {
        final paddedCustom = widget.applyPaddingToChild
            ? Padding(padding: _padding, child: widget.child!)
            : widget.child!;

        return Padding(
          // When applyPaddingToChild is false we only add end-padding for the
          // close icon so it doesn't sit flush against the edge.
          padding: widget.applyPaddingToChild
              ? EdgeInsets.zero
              : EdgeInsets.only(right: _padding.right),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              paddedCustom,
              SizedBox(width: _padding.left * 0.3),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _handleDelete,
                child: Padding(
                  padding: EdgeInsets.only(right: _padding.right * 0.6),
                  child: Icon(
                    Icons.close_rounded,
                    size: _deleteIconSize,
                    color: closeColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      // Not deletable — wrap in padding if requested and return directly.
      if (widget.applyPaddingToChild) {
        return Padding(padding: _padding, child: widget.child!);
      }
      return widget.child!;
    }

    // ── STANDARD MODE ──────────────────────────────────────────────────────
    final Color textColor = isGlassy ? _labelColor : _simpleLabelColor;
    final Color iconColor = widget.isSelected ? _resolvedAccent : textColor;

    final TextStyle resolvedLabelStyle = widget.labelStyle ??
        TextStyle(
          fontSize: _fontSize,
          fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
          color: textColor,
          letterSpacing: 0.1,
        );

    return Padding(
      padding: _padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Leading: avatar or icon ───────────────────────────────────
          if (widget.avatar != null) ...[
            SizedBox(
              width: _avatarSize,
              height: _avatarSize,
              child: widget.avatar!,
            ),
            SizedBox(width: _padding.left * 0.5),
          ] else if (widget.icon != null) ...[
            Icon(widget.icon, size: _iconSize, color: iconColor),
            SizedBox(width: _padding.left * 0.45),
          ],

          // ── Label ─────────────────────────────────────────────────────
          Flexible(
            child: Text(
              widget.label.isEmpty ? '' : widget.label,
              style: resolvedLabelStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          // ── Trailing: delete icon ──────────────────────────────────────
          if (widget.isDeletable) ...[
            SizedBox(width: _padding.left * 0.4),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _handleDelete,
              child: Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Icon(
                  Icons.close_rounded,
                  size: _deleteIconSize,
                  color: textColor.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private surface widgets
// ─────────────────────────────────────────────────────────────────────────────

class _GlassyChipSurface extends StatelessWidget {
  final Widget child;
  final double blurSigma;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final bool isSelected;
  final Color accentColor;
  final Duration animationDuration;
  final bool isHovered;

  const _GlassyChipSurface({
    required this.child,
    required this.blurSigma,
    required this.backgroundColor,
    required this.borderRadius,
    required this.isSelected,
    required this.accentColor,
    required this.animationDuration,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? accentColor.withValues(alpha: 0.75)
        : isHovered
            ? Colors.white.withValues(alpha: 0.45)
            : Colors.white.withValues(alpha: 0.28);

    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.0),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: AnimatedContainer(
            duration: animationDuration,
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accentColor.withValues(alpha: 0.20),
                        accentColor.withValues(alpha: 0.08),
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: isHovered ? 0.22 : 0.15),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SimpleChipSurface extends StatelessWidget {
  final Widget child;

  /// The resolved background colour for the current state (selected / idle).
  /// Pre-computed by the parent so this widget stays purely presentational.
  final Color backgroundColor;

  /// Pre-computed hover background (solid colour, no opacity manipulation).
  final Color hoverBackgroundColor;
  final BorderRadius borderRadius;
  final bool isSelected;

  /// The accent colour in its full, opaque form.
  final Color accentColor;
  final Duration animationDuration;
  final bool isHovered;

  const _SimpleChipSurface({
    required this.child,
    required this.backgroundColor,
    required this.hoverBackgroundColor,
    required this.borderRadius,
    required this.isSelected,
    required this.accentColor,
    required this.animationDuration,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    // ── Border ────────────────────────────────────────────────────────────
    // Selected  → solid full-opacity accent border (crisp, material).
    // Hovered   → a lighter but still opaque tint of the accent.
    // Idle      → no border (transparent).
    final Color borderColor;
    if (isSelected) {
      borderColor = accentColor; // fully opaque
    } else if (isHovered) {
      // Blend accent at 40% into the surface for a solid hover ring.
      borderColor = Color.alphaBlend(
        accentColor.withValues(alpha: 0.40),
        backgroundColor,
      );
    } else {
      borderColor = Colors.transparent;
    }

    // ── Background ────────────────────────────────────────────────────────
    // Hover uses the pre-computed solid hover colour; selected and idle
    // use the pre-computed backgroundColor — never raw opacity.
    final Color surfaceColor =
        isHovered && !isSelected ? hoverBackgroundColor : backgroundColor;

    // ── Shadow ────────────────────────────────────────────────────────────
    // Selected: a very tight, low-spread shadow using the solid accent —
    // gives depth without the blurry glow of the old glassy shadow.
    final List<BoxShadow>? shadow = isSelected
        ? [
            BoxShadow(
              color: Color.alphaBlend(
                accentColor.withValues(alpha: 0.20),
                Colors.transparent,
              ),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ]
        : null;

    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.0),
        boxShadow: shadow,
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KruiChipGroup  — managed group of chips
// ─────────────────────────────────────────────────────────────────────────────

/// A managed group of [KruiTagChip] widgets with built-in selection state,
/// animation, and layout control.
///
/// ## Modes
/// - [KruiChipGroupSelectionMode.none] — display-only, no selection.
/// - [KruiChipGroupSelectionMode.single] — radio-style, one chip at a time.
/// - [KruiChipGroupSelectionMode.multi] — filter-style, any number of chips.
///
/// ## Layouts
/// - [KruiChipGroupLayout.wrap] — multi-row wrap layout (default).
/// - [KruiChipGroupLayout.scrollableRow] — single horizontally scrollable row.
///
/// ## Quick usage
/// ```dart
/// KruiChipGroup(
///   chips: [
///     KruiTagChipData(id: 'dart', label: 'Dart', icon: Icons.code),
///     KruiTagChipData(id: 'flutter', label: 'Flutter', icon: Icons.flutter_dash),
///   ],
///   selectionMode: KruiChipGroupSelectionMode.multi,
///   onSelectionChanged: (ids) => print(ids),
/// )
/// ```
class KruiChipGroup extends StatefulWidget {
  /// The chip definitions to render.
  final List<KruiTagChipData> chips;

  /// Controls how many chips can be selected simultaneously.
  final KruiChipGroupSelectionMode selectionMode;

  /// Wrap or horizontal scroll row layout.
  final KruiChipGroupLayout layout;

  /// Glassmorphic or flat style applied to all chips (can be overridden
  /// per-chip via [KruiTagChipData.accentColor]).
  final KruiChipVariant variant;

  /// Chip size applied uniformly.
  final KruiChipSize size;

  /// Default accent colour for all chips.
  final Color? accentColor;

  /// The initially selected chip IDs.
  final Set<String> initialSelectedIds;

  /// Fires whenever the selection set changes. Receives the current set of
  /// selected IDs.
  final ValueChanged<Set<String>>? onSelectionChanged;

  /// Fires when a deletable chip's close icon is tapped. Receives the ID of
  /// the removed chip. When null, no chips render a close button.
  final KruiChipOnClose? onChipDeleted;

  // ── Layout ────────────────────────────────────────────────────────────────
  /// Spacing between chips on the main axis.
  final double spacing;

  /// Spacing between rows (wrap layout only).
  final double runSpacing;

  /// Alignment of chips within the wrap (wrap layout only).
  final WrapAlignment wrapAlignment;

  /// ScrollController for scrollableRow layout (optional).
  final ScrollController? scrollController;

  /// Padding around the entire chip group.
  final EdgeInsetsGeometry? padding;

  // ── Glass-specific ────────────────────────────────────────────────────────
  final double blurSigma;
  final double glassOpacity;

  // ── Animation ─────────────────────────────────────────────────────────────
  final Duration animationDuration;

  /// When true chips animate in on first build with a staggered fade+scale.
  final bool animateOnLoad;

  // ── Interaction ───────────────────────────────────────────────────────────
  final bool enableHaptics;

  /// Max-width for each individual chip before truncation.
  final double? chipMaxWidth;

  /// Optional label text style override applied to all chips.
  final TextStyle? chipLabelStyle;

  const KruiChipGroup({
    super.key,
    required this.chips,
    this.selectionMode = KruiChipGroupSelectionMode.multi,
    this.layout = KruiChipGroupLayout.wrap,
    this.variant = KruiChipVariant.glassy,
    this.size = KruiChipSize.medium,
    this.accentColor,
    this.initialSelectedIds = const {},
    this.onSelectionChanged,
    this.onChipDeleted,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.wrapAlignment = WrapAlignment.start,
    this.scrollController,
    this.padding,
    this.blurSigma = 12.0,
    this.glassOpacity = 0.18,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animateOnLoad = true,
    this.enableHaptics = true,
    this.chipMaxWidth,
    this.chipLabelStyle,
  });

  @override
  State<KruiChipGroup> createState() => _KruiChipGroupState();
}

class _KruiChipGroupState extends State<KruiChipGroup>
    with TickerProviderStateMixin {
  late Set<String> _selectedIds;

  // Tracks chips currently visible (used for delete animation).
  late List<KruiTagChipData> _visibleChips;

  // Stagger animation controllers per chip.
  final List<AnimationController> _staggerControllers = [];
  final List<Animation<double>> _staggerFades = [];
  final List<Animation<Offset>> _staggerSlides = [];

  @override
  void initState() {
    super.initState();
    _selectedIds = Set<String>.from(widget.initialSelectedIds);
    _visibleChips = List<KruiTagChipData>.from(widget.chips);
    if (widget.animateOnLoad) {
      _buildStaggerAnimations();
    }
  }

  @override
  void didUpdateWidget(KruiChipGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync additions — keep selection state for existing chips.
    if (oldWidget.chips != widget.chips) {
      _visibleChips = List<KruiTagChipData>.from(widget.chips);
      // Clean up stale selected IDs.
      final validIds = widget.chips.map((c) => c.id).toSet();
      _selectedIds = _selectedIds.intersection(validIds);
    }
  }

  void _buildStaggerAnimations() {
    _disposeStaggerControllers();
    for (int i = 0; i < _visibleChips.length; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 350),
      );
      _staggerControllers.add(ctrl);
      _staggerFades.add(Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeOut),
      ));
      _staggerSlides.add(
        Tween<Offset>(
          begin: const Offset(0.0, 0.25),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut)),
      );
      // Stagger delay: 40ms per chip, capped at 400ms total.
      final delay = Duration(milliseconds: (40 * i).clamp(0, 400));
      Future.delayed(delay, () {
        if (mounted) ctrl.forward();
      });
    }
  }

  void _disposeStaggerControllers() {
    for (final c in _staggerControllers) {
      c.dispose();
    }
    _staggerControllers.clear();
    _staggerFades.clear();
    _staggerSlides.clear();
  }

  @override
  void dispose() {
    _disposeStaggerControllers();
    super.dispose();
  }

  // ── Selection logic ───────────────────────────────────────────────────────

  void _handleChipTap(String id) {
    if (widget.selectionMode == KruiChipGroupSelectionMode.none) return;
    setState(() {
      if (widget.selectionMode == KruiChipGroupSelectionMode.single) {
        _selectedIds = _selectedIds.contains(id) ? {} : {id};
      } else {
        if (_selectedIds.contains(id)) {
          _selectedIds = Set.from(_selectedIds)..remove(id);
        } else {
          _selectedIds = Set.from(_selectedIds)..add(id);
        }
      }
    });
    widget.onSelectionChanged?.call(Set.unmodifiable(_selectedIds));
  }

  void _handleChipDelete(String id) {
    setState(() {
      _visibleChips.removeWhere((c) => c.id == id);
      _selectedIds.remove(id);
    });
    widget.onChipDeleted?.call(id);
    widget.onSelectionChanged?.call(Set.unmodifiable(_selectedIds));
  }

  // ── Build helpers ─────────────────────────────────────────────────────────

  Widget _buildChip(int index, KruiTagChipData data) {
    final isSelected = _selectedIds.contains(data.id);

    Widget chip = KruiTagChip(
      key: ValueKey(data.id),
      label: data.label,
      icon: data.icon,
      avatar: data.avatar,
      applyPaddingToChild: data.applyPaddingToCustomChild,
      isSelected: isSelected,
      isDisabled: data.isDisabled,
      isDeletable: widget.onChipDeleted != null,
      variant: widget.variant,
      size: widget.size,
      accentColor: data.accentColor ?? widget.accentColor,
      blurSigma: widget.blurSigma,
      glassOpacity: widget.glassOpacity,
      animationDuration: widget.animationDuration,
      enableHaptics: widget.enableHaptics,
      maxWidth: widget.chipMaxWidth,
      semanticsLabel: data.semanticLabel,
      labelStyle: widget.chipLabelStyle,
      onTap: widget.selectionMode != KruiChipGroupSelectionMode.none
          ? () => _handleChipTap(data.id)
          : null,
      onDeleted: widget.onChipDeleted != null
          ? () => _handleChipDelete(data.id)
          : null,
      // ── Custom child passthrough ──────────────────────────────────────────
      child: data.customChild,
    );

    // Stagger animation wrapper.
    if (widget.animateOnLoad && index < _staggerControllers.length) {
      chip = FadeTransition(
        opacity: _staggerFades[index],
        child: SlideTransition(
          position: _staggerSlides[index],
          child: chip,
        ),
      );
    }

    return chip;
  }

  @override
  Widget build(BuildContext context) {
    // Guard: empty chip list.
    if (_visibleChips.isEmpty) {
      return widget.padding != null
          ? Padding(padding: widget.padding!, child: const SizedBox.shrink())
          : const SizedBox.shrink();
    }

    Widget content;

    switch (widget.layout) {
      case KruiChipGroupLayout.wrap:
        content = Wrap(
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          alignment: widget.wrapAlignment,
          children: [
            for (int i = 0; i < _visibleChips.length; i++)
              _buildChip(i, _visibleChips[i]),
          ],
        );
        break;

      case KruiChipGroupLayout.scrollableRow:
        content = SingleChildScrollView(
          controller: widget.scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < _visibleChips.length; i++) ...[
                _buildChip(i, _visibleChips[i]),
                if (i < _visibleChips.length - 1)
                  SizedBox(width: widget.spacing),
              ],
            ],
          ),
        );
        break;
    }

    if (widget.padding != null) {
      content = Padding(padding: widget.padding!, child: content);
    }

    return content;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONVENIENCE FACTORIES
// ─────────────────────────────────────────────────────────────────────────────

/// Convenience factory — creates a glassy chip group.
///
/// Forwards all arguments to [KruiChipGroup] with [variant] forced to
/// [KruiChipVariant.glassy].
KruiChipGroup kruiGlassyChipGroup({
  Key? key,
  required List<KruiTagChipData> chips,
  KruiChipGroupSelectionMode selectionMode = KruiChipGroupSelectionMode.multi,
  KruiChipGroupLayout layout = KruiChipGroupLayout.wrap,
  KruiChipSize size = KruiChipSize.medium,
  Color? accentColor,
  Set<String> initialSelectedIds = const {},
  ValueChanged<Set<String>>? onSelectionChanged,
  KruiChipOnClose? onChipDeleted,
  double spacing = 8.0,
  double runSpacing = 8.0,
  EdgeInsetsGeometry? padding,
  double blurSigma = 12.0,
  double glassOpacity = 0.18,
  Duration animationDuration = const Duration(milliseconds: 200),
  bool animateOnLoad = true,
  bool enableHaptics = true,
  double? chipMaxWidth,
}) {
  return KruiChipGroup(
    key: key,
    chips: chips,
    selectionMode: selectionMode,
    layout: layout,
    variant: KruiChipVariant.glassy,
    size: size,
    accentColor: accentColor,
    initialSelectedIds: initialSelectedIds,
    onSelectionChanged: onSelectionChanged,
    onChipDeleted: onChipDeleted,
    spacing: spacing,
    runSpacing: runSpacing,
    padding: padding,
    blurSigma: blurSigma,
    glassOpacity: glassOpacity,
    animationDuration: animationDuration,
    animateOnLoad: animateOnLoad,
    enableHaptics: enableHaptics,
    chipMaxWidth: chipMaxWidth,
  );
}

/// Convenience factory — creates a simple (flat) chip group.
KruiChipGroup kruiSimpleChipGroup({
  Key? key,
  required List<KruiTagChipData> chips,
  KruiChipGroupSelectionMode selectionMode = KruiChipGroupSelectionMode.multi,
  KruiChipGroupLayout layout = KruiChipGroupLayout.wrap,
  KruiChipSize size = KruiChipSize.medium,
  Color? accentColor,
  Set<String> initialSelectedIds = const {},
  ValueChanged<Set<String>>? onSelectionChanged,
  KruiChipOnClose? onChipDeleted,
  double spacing = 8.0,
  double runSpacing = 8.0,
  EdgeInsetsGeometry? padding,
  Duration animationDuration = const Duration(milliseconds: 200),
  bool animateOnLoad = true,
  bool enableHaptics = true,
  double? chipMaxWidth,
}) {
  return KruiChipGroup(
    key: key,
    chips: chips,
    selectionMode: selectionMode,
    layout: layout,
    variant: KruiChipVariant.simple,
    size: size,
    accentColor: accentColor,
    initialSelectedIds: initialSelectedIds,
    onSelectionChanged: onSelectionChanged,
    onChipDeleted: onChipDeleted,
    spacing: spacing,
    runSpacing: runSpacing,
    padding: padding,
    animationDuration: animationDuration,
    animateOnLoad: animateOnLoad,
    enableHaptics: enableHaptics,
    chipMaxWidth: chipMaxWidth,
  );
}
