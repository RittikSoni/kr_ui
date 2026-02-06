import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A beautiful glassmorphic (liquid glass) dialog with frosted blur and modern styling.
///
/// Use [showKruiGlassyDialog] to display. Supports title, content, and action buttons
/// with full customization of blur, opacity, and colors.
///
/// ## Basic Usage
///
/// Pass the dialog context to actions so the dialog closes correctly (not the page behind):
///
/// ```dart
/// showKruiGlassyDialog(
///   context,
///   title: Text('Confirm'),
///   content: Text('Are you sure you want to continue?'),
///   actions: [
///     KruiGlassyDialogAction(
///       label: 'Cancel',
///       onPressed: (dialogContext) => Navigator.of(dialogContext).pop(),
///     ),
///     KruiGlassyDialogAction(
///       label: 'OK',
///       isPrimary: true,
///       onPressed: (dialogContext) => Navigator.of(dialogContext).pop(true),
///     ),
///   ],
/// );
/// ```
///
/// ## Custom title (color, size, etc.)
///
/// [title] is a [Widget], so you control appearance fully:
///
/// ```dart
/// title: Text('Confirm', style: TextStyle(fontSize: 24, color: Colors.blue)),
/// title: Row(children: [Icon(Icons.warning), SizedBox(width: 8), Text('Warning')]),
/// ```
///
/// ## Custom content
///
/// ```dart
/// showKruiGlassyDialog(
///   context,
///   blur: 20,
///   opacity: 0.2,
///   borderRadius: BorderRadius.circular(24),
///   child: YourCustomWidget(),
/// );
/// ```
Future<T?> showKruiGlassyDialog<T>(
  BuildContext context, {
  Widget? title,
  Widget? content,
  List<KruiGlassyDialogAction>? actions,
  Widget? child,
  bool barrierDismissible = true,
  Color? barrierColor,
  double blur = 16,
  double opacity = 0.18,
  Color color = Colors.white,
  BorderRadius? borderRadius,
  Border? border,
  double? width,
  bool useSafeArea = true,
}) {
  if (child != null &&
      (title != null || content != null || (actions?.isNotEmpty == true))) {
    assert(false, 'Use either child or title/content/actions, not both.');
  }
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? Colors.black54,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 250),
    transitionBuilder: (dialogContext, animation, secondaryAnimation, page) {
      final curve = Curves.easeOutCubic;
      final curved = CurvedAnimation(parent: animation, curve: curve);
      final padding = useSafeArea
          ? EdgeInsets.only(
              left: 24 + MediaQuery.paddingOf(dialogContext).left,
              right: 24 + MediaQuery.paddingOf(dialogContext).right,
              top: MediaQuery.paddingOf(dialogContext).top,
              bottom: MediaQuery.paddingOf(dialogContext).bottom,
            )
          : const EdgeInsets.symmetric(horizontal: 24);
      final dialogContent = Padding(
        padding: padding,
        child: _KruiGlassyDialogContent(
          title: title,
          content: content,
          actions: actions,
          blur: blur,
          opacity: opacity,
          color: color,
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          border: border,
          width: width,
          child: child,
        ),
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                if (barrierDismissible)
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(dialogContext).pop(),
                      child: const SizedBox.expand(),
                    ),
                  ),
                Center(child: dialogContent),
              ],
            ),
          ),
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) =>
        const SizedBox.shrink(),
  );
}

/// Action button for [showKruiGlassyDialog].
///
/// [onPressed] receives the dialog's [BuildContext]. Use it to close the dialog
/// so the correct route is popped: `Navigator.of(dialogContext).pop()` or
/// `Navigator.of(dialogContext).pop(true)` to return a value.
class KruiGlassyDialogAction {
  final String label;

  /// Called when the action is tapped. Receives the dialog context so you can
  /// call `Navigator.of(dialogContext).pop()` or `Navigator.of(dialogContext).pop(value)`.
  final void Function(BuildContext dialogContext)? onPressed;
  final bool isPrimary;

  const KruiGlassyDialogAction({
    required this.label,
    this.onPressed,
    this.isPrimary = false,
  });
}

class _KruiGlassyDialogContent extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<KruiGlassyDialogAction>? actions;
  final Widget? child;
  final double blur;
  final double opacity;
  final Color color;
  final BorderRadius borderRadius;
  final Border? border;
  final double? width;

  const _KruiGlassyDialogContent({
    this.title,
    this.content,
    this.actions,
    this.child,
    required this.blur,
    required this.opacity,
    required this.color,
    required this.borderRadius,
    this.border,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorder = border ??
        Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1.5);

    Widget body;
    if (child != null) {
      body = child!;
    } else {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            title!,
            const SizedBox(height: 12),
          ],
          if (content != null) content!,
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!
                  .map((a) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _GlassyDialogButton(
                          label: a.label,
                          isPrimary: a.isPrimary,
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            a.onPressed?.call(context);
                          },
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      );
    }

    return ConstraintWidth(
      maxWidth: width ?? 340,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: blur, sigmaY: blur, tileMode: TileMode.clamp),
          child: Container(
            width: width,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.withValues(alpha: opacity),
              borderRadius: borderRadius,
              border: effectiveBorder,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: body,
          ),
        ),
      ),
    );
  }
}

class _GlassyDialogButton extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final void Function()? onPressed;

  const _GlassyDialogButton({
    required this.label,
    required this.isPrimary,
    this.onPressed,
  });

  @override
  State<_GlassyDialogButton> createState() => _GlassyDialogButtonState();
}

class _GlassyDialogButtonState extends State<_GlassyDialogButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPrimary = widget.isPrimary;
    final bg = isPrimary
        ? (theme.colorScheme.primary)
        : Colors.white.withValues(alpha: 0.2);
    final fg =
        isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: _pressed
              ? (isPrimary
                  ? theme.colorScheme.primary.withValues(alpha: 0.85)
                  : Colors.white.withValues(alpha: 0.3))
              : bg,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Text(
          widget.label,
          style: theme.textTheme.labelLarge?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ) ??
              TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }
}

class ConstraintWidth extends StatelessWidget {
  final double? maxWidth;
  final Widget child;

  const ConstraintWidth({super.key, this.maxWidth, required this.child});

  @override
  Widget build(BuildContext context) {
    if (maxWidth == null) return child;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        child: child,
      ),
    );
  }
}
