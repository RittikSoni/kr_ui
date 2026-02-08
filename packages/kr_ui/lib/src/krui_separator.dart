import 'package:flutter/material.dart';

/// A customizable separator widget with support for text, icons, and different line styles.
class KruiSeparator extends StatelessWidget {
  /// The axis of the separator (horizontal or vertical).
  final Axis axis;

  /// The text to display in the middle of the separator.
  final String? text;

  /// The icon to display in the middle of the separator.
  final IconData? icon;

  /// The color of the separator line.
  final Color? color;

  /// The thickness of the separator line.
  final double thickness;

  /// The style of the separator line (solid, dashed, dotted).
  final SeparatorStyle style;

  /// The gradient for the separator line.
  final Gradient? gradient;

  /// The padding around the separator.
  final EdgeInsetsGeometry padding;

  /// The text style for the middle text.
  final TextStyle? textStyle;

  /// The size for the middle icon.
  final double iconSize;

  /// Creates a horizontal separator.
  const KruiSeparator.horizontal({
    super.key,
    this.text,
    this.icon,
    this.color,
    this.thickness = 1.0,
    this.style = SeparatorStyle.solid,
    this.gradient,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
    this.textStyle,
    this.iconSize = 20.0,
  }) : axis = Axis.horizontal;

  /// Creates a vertical separator.
  const KruiSeparator.vertical({
    super.key,
    this.text,
    this.icon,
    this.color,
    this.thickness = 1.0,
    this.style = SeparatorStyle.solid,
    this.gradient,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.textStyle,
    this.iconSize = 20.0,
  }) : axis = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.dividerColor;
    final effectiveTextStyle = textStyle ?? theme.textTheme.bodySmall;

    Widget line = CustomPaint(
      painter: _SeparatorPainter(
        color: effectiveColor,
        thickness: thickness,
        style: style,
        gradient: gradient,
        axis: axis,
      ),
    );

    if (axis == Axis.horizontal) {
      line = SizedBox(height: thickness, child: line);
    } else {
      line = SizedBox(width: thickness, child: line);
    }

    Widget content = line;

    if (text != null || icon != null) {
      final middleWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: iconSize, color: effectiveColor),
              if (text != null) const SizedBox(width: 8),
            ],
            if (text != null)
              Text(
                text!,
                style: effectiveTextStyle?.copyWith(color: effectiveColor),
              ),
          ],
        ),
      );

      if (axis == Axis.horizontal) {
        content = Row(
          children: [
            Expanded(child: line),
            middleWidget,
            Expanded(child: line),
          ],
        );
      } else {
        content = Column(
          children: [
            Expanded(child: line),
            RotatedBox(quarterTurns: 1, child: middleWidget),
            Expanded(child: line),
          ],
        );
      }
    }

    return Padding(
      padding: padding,
      child: content,
    );
  }
}

enum SeparatorStyle { solid, dashed, dotted }

class _SeparatorPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final SeparatorStyle style;
  final Gradient? gradient;
  final Axis axis;

  _SeparatorPainter({
    required this.color,
    required this.thickness,
    required this.style,
    this.gradient,
    required this.axis,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    if (gradient != null) {
      paint.shader = gradient!.createShader(Offset.zero & size);
    }

    final path = Path();
    if (axis == Axis.horizontal) {
      path.moveTo(0, size.height / 2);
      path.lineTo(size.width, size.height / 2);
    } else {
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width / 2, size.height);
    }

    if (style == SeparatorStyle.solid) {
      canvas.drawPath(path, paint);
    } else {
      final dashWidth = style == SeparatorStyle.dashed ? 8.0 : thickness;
      final dashSpace = style == SeparatorStyle.dashed ? 4.0 : thickness * 2;

      if (style == SeparatorStyle.dotted) {
        paint.strokeCap = StrokeCap.round;
      }

      final metric = path.computeMetrics().first;
      var distance = 0.0;
      while (distance < metric.length) {
        final extractPath = metric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SeparatorPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        oldDelegate.style != style ||
        oldDelegate.gradient != gradient ||
        oldDelegate.axis != axis;
  }
}
