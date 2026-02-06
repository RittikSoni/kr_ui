import 'package:flutter/material.dart';
import 'krui_glassy_sheet.dart' show KruiSheetPosition;

BorderRadius _simpleSheetBorderRadius(
    KruiSheetPosition position, BorderRadius radius) {
  switch (position) {
    case KruiSheetPosition.bottom:
      return BorderRadius.only(
          topLeft: radius.topLeft, topRight: radius.topRight);
    case KruiSheetPosition.top:
      return BorderRadius.only(
          bottomLeft: radius.bottomLeft, bottomRight: radius.bottomRight);
    case KruiSheetPosition.left:
      return BorderRadius.only(
          topRight: radius.topRight, bottomRight: radius.bottomRight);
    case KruiSheetPosition.right:
      return BorderRadius.only(
          topLeft: radius.topLeft, bottomLeft: radius.bottomLeft);
  }
}

/// Shows a simple (non-glass) sheet from the given [position].
///
/// Use [child] for custom content. Set [height] or [width] as for [showKruiGlassySheet].
///
/// ## Basic usage
///
/// ```dart
/// showKruiSimpleSheet(
///   context,
///   position: KruiSheetPosition.bottom,
///   height: 0.4,
///   child: Padding(
///     padding: EdgeInsets.all(24),
///     child: Text('Simple sheet'),
///   ),
/// );
/// ```
///
/// ## From different edges
///
/// ```dart
/// showKruiSimpleSheet(context, position: KruiSheetPosition.top, height: 200, child: ...);
/// showKruiSimpleSheet(context, position: KruiSheetPosition.left, width: 280, child: ...);
/// showKruiSimpleSheet(context, position: KruiSheetPosition.right, width: 0.7, child: ...);
/// ```
Future<T?> showKruiSimpleSheet<T>(
  BuildContext context, {
  required Widget child,
  KruiSheetPosition position = KruiSheetPosition.bottom,
  double? height,
  double? width,
  bool barrierDismissible = true,
  Color? barrierColor,
  Color? backgroundColor,
  BorderRadius? borderRadius,
  double elevation = 8,
  bool useSafeArea = true,
  Duration transitionDuration = const Duration(milliseconds: 280),
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? Colors.black45,
    barrierLabel: 'Dismiss',
    transitionDuration: transitionDuration,
    transitionBuilder: (sheetContext, animation, secondaryAnimation, page) {
      final curve = Curves.easeOutCubic;
      final curved = CurvedAnimation(parent: animation, curve: curve);
      final theme = Theme.of(sheetContext);
      final media = MediaQuery.of(sheetContext);
      final padding = useSafeArea ? media.padding : EdgeInsets.zero;

      double? w;
      double? h;
      if (position == KruiSheetPosition.bottom ||
          position == KruiSheetPosition.top) {
        h = height != null
            ? (height <= 1 ? media.size.height * height : height)
            : null;
        w = media.size.width;
      } else {
        w = width != null
            ? (width <= 1 ? media.size.width * width : width)
            : null;
        h = media.size.height;
      }

      final radius = borderRadius ?? BorderRadius.circular(20);
      final bg = backgroundColor ?? theme.colorScheme.surface;

      Widget panel = Material(
        color: Colors.transparent,
        elevation: elevation,
        shadowColor: Colors.black26,
        borderRadius: _simpleSheetBorderRadius(position, radius),
        child: Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: _simpleSheetBorderRadius(position, radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: child,
        ),
      );

      Alignment align;
      Offset beginOffset;
      switch (position) {
        case KruiSheetPosition.bottom:
          align = Alignment.bottomCenter;
          beginOffset = const Offset(0, 1);
          break;
        case KruiSheetPosition.top:
          align = Alignment.topCenter;
          beginOffset = const Offset(0, -1);
          break;
        case KruiSheetPosition.left:
          align = Alignment.centerLeft;
          beginOffset = const Offset(-1, 0);
          break;
        case KruiSheetPosition.right:
          align = Alignment.centerRight;
          beginOffset = const Offset(1, 0);
          break;
      }

      return Stack(
        children: [
          if (barrierDismissible)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(sheetContext).pop(),
                child: FadeTransition(
                  opacity: curved,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          Align(
            alignment: align,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: beginOffset,
                end: Offset.zero,
              ).animate(curved),
              child: FadeTransition(
                opacity: curved,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: padding.left,
                    top: position == KruiSheetPosition.top ? padding.top : 0,
                    right: padding.right,
                    bottom: position == KruiSheetPosition.bottom
                        ? padding.bottom
                        : 0,
                  ),
                  child: panel,
                ),
              ),
            ),
          ),
        ],
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) =>
        const SizedBox.shrink(),
  );
}
