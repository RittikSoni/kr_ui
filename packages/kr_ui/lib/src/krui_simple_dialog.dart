import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A clean, modern dialog without glass effects—refined solid surface and typography.
///
/// Use [showKruiSimpleDialog] to display. Supports title, content, and action buttons
/// with optional elevation and rounded corners.
///
/// ## Basic Usage
///
/// Pass the dialog context to actions so the dialog closes correctly (not the page behind):
///
/// ```dart
/// showKruiSimpleDialog(
///   context,
///   title: Text('Confirm'),
///   content: Text('Are you sure you want to continue?'),
///   actions: [
///     KruiSimpleDialogAction(label: 'Cancel', onPressed: (dialogContext) => Navigator.of(dialogContext).pop()),
///     KruiSimpleDialogAction(label: 'OK', isPrimary: true, onPressed: (dialogContext) => Navigator.of(dialogContext).pop(true)),
///   ],
/// );
/// ```
///
/// ## Custom title (color, size, etc.)
///
/// [title] is a [Widget], so you control appearance fully:
///
/// ```dart
/// title: Text('Confirm', style: TextStyle(fontSize: 24, color: Colors.indigo)),
/// title: Row(children: [Icon(Icons.info), SizedBox(width: 8), Text('Info')]),
/// ```
///
/// ## Custom content
///
/// ```dart
/// showKruiSimpleDialog(
///   context,
///   backgroundColor: Colors.white,
///   borderRadius: BorderRadius.circular(20),
///   child: YourCustomWidget(),
/// );
/// ```
Future<T?> showKruiSimpleDialog<T>(
  BuildContext context, {
  Widget? title,
  Widget? content,
  List<KruiSimpleDialogAction>? actions,
  Widget? child,
  bool barrierDismissible = true,
  Color? barrierColor,
  Color? backgroundColor,
  BorderRadius? borderRadius,
  double elevation = 8,
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
    barrierColor: barrierColor ?? Colors.black45,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 220),
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
        child: _KruiSimpleDialogContent(
          title: title,
          content: content,
          actions: actions,
          backgroundColor:
              backgroundColor ?? Theme.of(dialogContext).colorScheme.surface,
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          elevation: elevation,
          width: width,
          child: child,
        ),
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
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

/// Action button for [showKruiSimpleDialog].
///
/// [onPressed] receives the dialog's [BuildContext]. Use it to close the dialog
/// so the correct route is popped: `Navigator.of(dialogContext).pop()` or
/// `Navigator.of(dialogContext).pop(true)` to return a value.
class KruiSimpleDialogAction {
  final String label;

  /// Called when the action is tapped. Receives the dialog context so you can
  /// call `Navigator.of(dialogContext).pop()` or `Navigator.of(dialogContext).pop(value)`.
  final void Function(BuildContext dialogContext)? onPressed;
  final bool isPrimary;

  const KruiSimpleDialogAction({
    required this.label,
    this.onPressed,
    this.isPrimary = false,
  });
}

class _KruiSimpleDialogContent extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<KruiSimpleDialogAction>? actions;
  final Widget? child;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final double elevation;
  final double? width;

  const _KruiSimpleDialogContent({
    this.title,
    this.content,
    this.actions,
    this.child,
    required this.backgroundColor,
    required this.borderRadius,
    required this.elevation,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
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
                        child: _SimpleDialogButton(
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

    return _SimpleDialogConstraintWidth(
      maxWidth: width ?? 340,
      child: Material(
        color: Colors.transparent,
        elevation: elevation,
        shadowColor: Colors.black26,
        borderRadius: borderRadius,
        child: Container(
          width: width,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: body,
        ),
      ),
    );
  }
}

class _SimpleDialogButton extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final void Function()? onPressed;

  const _SimpleDialogButton({
    required this.label,
    required this.isPrimary,
    this.onPressed,
  });

  @override
  State<_SimpleDialogButton> createState() => _SimpleDialogButtonState();
}

class _SimpleDialogConstraintWidth extends StatelessWidget {
  final double? maxWidth;
  final Widget child;

  const _SimpleDialogConstraintWidth({this.maxWidth, required this.child});

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

class _SimpleDialogButtonState extends State<_SimpleDialogButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPrimary = widget.isPrimary;
    final bg = isPrimary
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest;
    final fg =
        isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _pressed
                ? (isPrimary
                    ? theme.colorScheme.primary.withValues(alpha: 0.9)
                    : theme.colorScheme.surfaceContainerHigh)
                : bg,
            borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}
