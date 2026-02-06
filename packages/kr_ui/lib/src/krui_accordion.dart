import 'dart:ui';
import 'package:flutter/material.dart';

/// A premium glassmorphic accordion component with smooth expansion animations.
class KruiAccordion extends StatefulWidget {
  final Widget title;
  final Widget content;
  final Widget? leading;
  final Widget? trailing;
  final bool initiallyExpanded;
  final double blur;
  final double opacity;
  final Color? color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? contentPadding;
  final ValueChanged<bool>? onExpansionChanged;

  const KruiAccordion({
    super.key,
    required this.title,
    required this.content,
    this.leading,
    this.trailing,
    this.initiallyExpanded = false,
    this.blur = 10,
    this.opacity = 0.1,
    this.color,
    this.borderRadius,
    this.headerPadding = const EdgeInsets.all(16),
    this.contentPadding = const EdgeInsets.all(16),
    this.onExpansionChanged,
  });

  @override
  State<KruiAccordion> createState() => _KruiAccordionState();
}

class _KruiAccordionState extends State<KruiAccordion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconRotation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    _iconRotation = _controller.drive(Tween<double>(begin: 0, end: 0.5)
        .chain(CurveTween(curve: Curves.easeInOut)));

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderRadius = widget.borderRadius ?? BorderRadius.circular(16);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);
    final surfaceColor = widget.color ?? (isDark ? Colors.white : Colors.black);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor.withValues(alpha: widget.opacity),
              borderRadius: borderRadius,
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                InkWell(
                  onTap: _handleTap,
                  child: Padding(
                    padding: widget.headerPadding!,
                    child: Row(
                      children: [
                        if (widget.leading != null) ...[
                          widget.leading!,
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: DefaultTextStyle(
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            child: widget.title,
                          ),
                        ),
                        if (widget.trailing != null)
                          widget.trailing!
                        else
                          RotationTransition(
                            turns: _iconRotation,
                            child: Icon(
                              Icons.expand_more,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Content
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return ClipRect(
                      child: Align(
                        heightFactor: _heightFactor.value,
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: widget.contentPadding!,
                    child: widget.content,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
