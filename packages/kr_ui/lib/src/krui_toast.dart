import 'dart:ui';
import 'package:flutter/material.dart';
import 'krui_initializer.dart';

/// A premium glassmorphic toast notification for the kr_ui library.
///
/// No [BuildContext] is required. Ensure [KruiInitializer.navigatorKey] is
/// set on your [MaterialApp] (e.g. `navigatorKey: KruiInitializer.navigatorKey`).
class KruiToast {
  /// Shows a glassmorphic toast. No context needed.
  static void show({
    required String message,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    Color color = Colors.white,
    double blur = 15,
    double opacity = 0.2,
  }) {
    final overlay = KruiInitializer.navigatorKey.currentState?.overlay;

    if (overlay == null) {
      debugPrint(
          'KruiToast: Overlay not found. Set MaterialApp.navigatorKey to KruiInitializer.navigatorKey.');
      return;
    }

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        icon: icon,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
        color: color,
        blur: blur,
        opacity: opacity,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;
  final Color color;
  final double blur;
  final double opacity;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    required this.duration,
    required this.color,
    required this.blur,
    required this.opacity,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();

    Future.delayed(widget.duration, () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: widget.blur,
                    sigmaY: widget.blur,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: widget.opacity),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                        ],
                        Flexible(
                          child: Text(
                            widget.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (widget.actionLabel != null) ...[
                          const SizedBox(width: 12),
                          Container(
                            width: 1,
                            height: 16,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: () {
                              widget.onAction?.call();
                              widget.onDismiss();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              widget.actionLabel!.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
