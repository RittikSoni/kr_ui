import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A modern, elegant app bar with glassmorphic support.
class KruiAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title of the app bar.
  final Widget? title;

  /// The leading widget.
  final Widget? leading;

  /// The actions (trailing widgets).
  final List<Widget>? actions;

  /// Whether to center the title.
  final bool? centerTitle;

  /// The background color.
  final Color? backgroundColor;

  /// The elevation.
  final double? elevation;

  /// Whether to show a glassmorphic effect.
  final bool glass;

  /// The blur intensity for the glass effect.
  final double blurIntensity;

  /// The scaling of the title text.
  final double? titleSpacing;

  /// The height of the app bar.
  final double height;

  /// The system overlay style.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// The bottom widget (e.g. TabBar).
  final PreferredSizeWidget? bottom;

  const KruiAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.glass = true,
    this.blurIntensity = 10,
    this.titleSpacing,
    this.height = kToolbarHeight,
    this.systemOverlayStyle,
    this.bottom,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBgColor = backgroundColor ??
        (glass
            ? (isDark
                ? Colors.black.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.7))
            : theme.appBarTheme.backgroundColor);

    Widget content = AppBar(
      title: title,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleSpacing: titleSpacing,
      systemOverlayStyle: systemOverlayStyle,
      bottom: bottom,
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : Colors.black87,
      ),
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : Colors.black87,
      ),
    );

    if (glass) {
      return ClipRect(
        child: BackdropFilter(
          filter:
              ImageFilter.blur(sigmaX: blurIntensity, sigmaY: blurIntensity),
          child: Container(
            color: effectiveBgColor,
            child: content,
          ),
        ),
      );
    }

    return Container(
      color: effectiveBgColor,
      child: content,
    );
  }
}
