import 'dart:ui';
import 'package:flutter/material.dart';

/// A floating dock with spring physics and scale animations, inspired by macOS/iOS docks.
///
/// Creates a glassmorphic floating bar with icons that scale up on hover/press.
/// Perfect for quick access navigation, action menus, and floating controls.
///
/// Example:
/// ```dart
/// KruiFloatingDock(
///   items: [
///     FloatingDockItem(icon: Icons.home, onTap: () => print('Home')),
///     FloatingDockItem(icon: Icons.search, onTap: () => print('Search')),
///     FloatingDockItem(icon: Icons.favorite, onTap: () => print('Favorites')),
///   ],
/// )
/// ```
class KruiFloatingDock extends StatefulWidget {
  /// List of dock items to display
  final List<KruiFloatingDockItem> items;

  /// Dock position on screen
  final FloatingDockPosition position;

  /// Dock height
  final double height;

  /// Spacing between icons
  final double spacing;

  /// Icon size (base size before scaling)
  final double iconSize;

  /// Maximum scale factor on hover
  final double maxScale;

  /// Background blur intensity
  final double blurIntensity;

  /// Background color (glassmorphic)
  final Color? backgroundColor;

  /// Border color
  final Color? borderColor;

  /// Auto-hide on scroll
  final bool autoHide;

  /// Padding around the dock
  final EdgeInsets padding;

  const KruiFloatingDock({
    super.key,
    required this.items,
    this.position = FloatingDockPosition.bottom,
    this.height = 70,
    this.spacing = 16,
    this.iconSize = 24,
    this.maxScale = 1.5,
    this.blurIntensity = 15,
    this.backgroundColor,
    this.borderColor,
    this.autoHide = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  }) : assert(items.length > 0, 'Must have at least one item');

  @override
  State<KruiFloatingDock> createState() => _KruiFloatingDockState();
}

class _KruiFloatingDockState extends State<KruiFloatingDock>
    with TickerProviderStateMixin {
  late List<AnimationController> _scaleControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _scaleControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );

    _scaleAnimations = _scaleControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: widget.maxScale).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutBack, // Spring-like curve
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _scaleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemHover(int index, bool isHovered) {
    if (isHovered) {
      // Only scale up the hovered item
      _scaleControllers[index].forward();
    } else {
      // Reset only the hovered item
      _scaleControllers[index].reverse();
    }
  }

  void _onItemTap(int index) {
    // Bounce animation on tap
    _scaleControllers[index].forward().then((_) {
      _scaleControllers[index].reverse();
    });
    widget.items[index].onTap?.call();
  }

  Widget _buildDockItem(int index) {
    final item = widget.items[index];

    return AnimatedBuilder(
      animation: _scaleAnimations[index],
      builder: (context, child) {
        final scale = _scaleAnimations[index].value;

        final iconWidget = Transform.scale(
          scale: scale,
          child: Container(
            width: widget.iconSize + 16,
            height: widget.iconSize + 16,
            decoration: BoxDecoration(
              color: item.backgroundColor ?? Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: item.showBorder
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    )
                  : null,
            ),
            child: Icon(
              item.icon,
              size: widget.iconSize,
              color: item.iconColor ?? Colors.white,
            ),
          ),
        );

        return MouseRegion(
          onEnter: (_) => _onItemHover(index, true),
          onExit: (_) => _onItemHover(index, false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _onItemTap(index),
            child: item.label != null
                ? Tooltip(
                    message: item.label!,
                    preferBelow: false,
                    verticalOffset: 16,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    child: iconWidget,
                  )
                : iconWidget,
          ),
        );
      },
    );
  }

  Widget _buildDock() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.height / 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.blurIntensity,
          sigmaY: widget.blurIntensity,
        ),
        child: Container(
          height: widget.height,
          padding: widget.padding,
          decoration: BoxDecoration(
            color:
                widget.backgroundColor ?? Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: Border.all(
              color: widget.borderColor ?? Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 24,
                spreadRadius: -4,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < widget.items.length; i++) ...[
                _buildDockItem(i),
                if (i < widget.items.length - 1)
                  SizedBox(width: widget.spacing),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget dockWidget = _buildDock();

    // Position the dock based on FloatingDockPosition
    switch (widget.position) {
      case FloatingDockPosition.bottom:
        return Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(child: dockWidget),
        );
      case FloatingDockPosition.top:
        return Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Center(child: dockWidget),
        );
      case FloatingDockPosition.left:
        return Positioned(
          left: 20,
          top: 0,
          bottom: 0,
          child: Center(child: dockWidget),
        );
      case FloatingDockPosition.right:
        return Positioned(
          right: 20,
          top: 0,
          bottom: 0,
          child: Center(child: dockWidget),
        );
    }
  }
}

/// Represents a single item in the floating dock
class KruiFloatingDockItem {
  /// Icon to display
  final IconData icon;

  /// Callback when item is tapped
  final VoidCallback? onTap;

  /// Custom icon color
  final Color? iconColor;

  /// Custom background color for this item
  final Color? backgroundColor;

  /// Show border around item
  final bool showBorder;

  /// Optional label to show on hover
  final String? label;

  const KruiFloatingDockItem({
    required this.icon,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.showBorder = false,
    this.label,
  });
}

/// Position of the floating dock on screen
enum FloatingDockPosition {
  top,
  bottom,
  left,
  right,
}
