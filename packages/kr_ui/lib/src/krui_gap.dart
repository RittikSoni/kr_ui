import 'package:flutter/material.dart';

/// A simple gap widget that replaces `SizedBox` for spacing.
///
/// Use [KruiGap.vertical] for vertical spacing and [KruiGap.horizontal]
/// for horizontal spacing.
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     Text('Hello'),
///     KruiGap.vertical(16),
///     Text('World'),
///   ],
/// )
/// ```
class KruiGap extends StatelessWidget {
  /// The size of the gap.
  final double? size;

  /// The axis of the gap (vertical or horizontal).
  final Axis axis;

  /// Creates a gap with the given [size] and [axis].
  const KruiGap({
    super.key,
    this.size,
    required this.axis,
  });

  /// Creates a vertical gap.
  ///
  /// If [size] is null, it defaults to 16.0.
  /// Creates a vertical gap.
  ///
  /// If [size] is null, it defaults to 16.0.
  const KruiGap.vertical(double? size, {Key? key})
      : this(size: size ?? 16.0, axis: Axis.vertical, key: key);

  /// Creates a horizontal gap.
  ///
  /// If [size] is null, it defaults to 16.0.
  const KruiGap.horizontal(double? size, {Key? key})
      : this(size: size ?? 16.0, axis: Axis.horizontal, key: key);

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.vertical) {
      return SizedBox(height: size);
    } else {
      return SizedBox(width: size);
    }
  }
}
