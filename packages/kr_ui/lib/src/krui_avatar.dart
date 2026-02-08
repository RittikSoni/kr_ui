import 'package:flutter/material.dart';

/// A modern avatar component that supports images, initials, and icons.
///
/// Includes support for:
/// - Online/status badges
/// - Group/Stack display
/// - Custom sizes and shapes
/// - Border and shadow customization
class KruiAvatar extends StatelessWidget {
  /// The image to display (takes precedence over text and icon).
  final ImageProvider? image;

  /// The text (initials) to display if no image is provided.
  final String? text;

  /// The icon to display if no image or text is provided.
  final IconData? icon;

  /// The size of the avatar (diameter).
  final double size;

  /// The background color of the avatar.
  final Color? backgroundColor;

  /// The text color (for initials).
  final Color? foregroundColor;

  /// The icon color.
  final Color? iconColor;

  /// The border color.
  final Color? borderColor;

  /// The border width.
  final double borderWidth;

  /// The border radius (defaults to circular).
  final BorderRadius? borderRadius;

  /// The status badge color (e.g., green for online).
  final Color? badgeColor;

  /// The status badge size.
  final double badgeSize;

  /// The status badge position alignment.
  final Alignment badgeAlignment;

  /// Custom widget for the badge (overrides badgeColor).
  final Widget? badge;

  /// Shadow for the avatar.
  final List<BoxShadow>? boxShadow;

  /// Callback when tapped.
  final VoidCallback? onTap;

  const KruiAvatar({
    super.key,
    this.image,
    this.text,
    this.icon,
    this.size = 40,
    this.backgroundColor,
    this.foregroundColor,
    this.iconColor,
    this.borderColor,
    this.borderWidth = 0,
    this.borderRadius,
    this.badgeColor,
    this.badgeSize = 12,
    this.badgeAlignment = Alignment.bottomRight,
    this.badge,
    this.boxShadow,
    this.onTap,
  });

  /// Creates a group of avatars.
  static Widget group({
    required List<KruiAvatar> children,
    double overlap = 0.4,
    int? max,
    Widget? remainingCountParams,
    double size = 40,
    Color? borderColor,
    double borderWidth = 2,
  }) {
    final effectiveChildren = max != null && children.length > max
        ? children.take(max).toList()
        : children;

    final remaining = children.length - effectiveChildren.length;

    return SizedBox(
      height: size,
      width: size +
          (effectiveChildren.length + (remaining > 0 ? 1 : 0) - 1) *
              (size * (1 - overlap)),
      child: Stack(
        children: [
          for (int i = 0; i < effectiveChildren.length; i++)
            Positioned(
              left: i * (size * (1 - overlap)),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor ?? Colors.white,
                    width: borderWidth,
                  ),
                ),
                child: effectiveChildren[i],
              ),
            ),
          if (remaining > 0)
            Positioned(
              left: effectiveChildren.length * (size * (1 - overlap)),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor ?? Colors.white,
                    width: borderWidth,
                  ),
                ),
                child: KruiAvatar(
                  text: '+$remaining',
                  size: size,
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.grey.shade800,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBgColor = backgroundColor ??
        (isDark ? Colors.grey.shade800 : Colors.grey.shade200);
    final effectiveFgColor =
        foregroundColor ?? (isDark ? Colors.white : Colors.black87);
    final effectiveIconColor = iconColor ?? effectiveFgColor;

    Widget content;
    if (image != null) {
      content = Image(
        image: image!,
        fit: BoxFit.cover,
        width: size,
        height: size,
      );
    } else if (text != null) {
      content = Center(
        child: Text(
          text!,
          style: TextStyle(
            color: effectiveFgColor,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
          ),
        ),
      );
    } else {
      content = Center(
        child: Icon(
          icon ?? Icons.person,
          color: effectiveIconColor,
          size: size * 0.6,
        ),
      );
    }

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
        border: borderColor != null && borderWidth > 0
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        boxShadow: boxShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );

    Widget result = avatar;

    if (badge != null || badgeColor != null) {
      result = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: badgeAlignment.x > 0 ? 0 : null,
            left: badgeAlignment.x < 0 ? 0 : null,
            top: badgeAlignment.y < 0 ? 0 : null,
            bottom: badgeAlignment.y > 0 ? 0 : null,
            child: badge ??
                Container(
                  width: badgeSize,
                  height: badgeSize,
                  decoration: BoxDecoration(
                    color: badgeColor ?? Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                ),
          ),
        ],
      );
    }

    if (onTap != null) {
      result = GestureDetector(onTap: onTap, child: result);
    }

    return result;
  }
}
