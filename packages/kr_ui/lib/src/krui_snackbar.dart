import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'krui_initializer.dart';

/// Snackbar variant with predefined icon and colors.
enum KruiSnackbarVariant {
  success,
  danger,
  warning,
  info,
  neutral,
}

/// A modern, elegant toast/snackbar with optional action. No glass or blur.
///
/// No [BuildContext] is required. Set [KruiInitializer.navigatorKey] on your
/// [MaterialApp] for overlay access.
///
/// Quick variants:
/// ```dart
/// KruiSnackbar.success(message: 'Saved!');
/// KruiSnackbar.danger(message: 'Something went wrong');
/// KruiSnackbar.warning(message: 'Check your input');
/// KruiSnackbar.info(message: 'New update available');
/// ```
class KruiSnackbar {
  KruiSnackbar._();

  static const Duration _defaultDuration = Duration(seconds: 3);

  // Modern palette: subtle backgrounds, clear accent
  static const Color _successBg = Color(0xFF0D2818);
  static const Color _successAccent = Color(0xFF34C759);
  static const Color _dangerBg = Color(0xFF2B1014);
  static const Color _dangerAccent = Color(0xFFFF453A);
  static const Color _warningBg = Color(0xFF2B2208);
  static const Color _warningAccent = Color(0xFFFFD60A);
  static const Color _infoBg = Color(0xFF0A1628);
  static const Color _infoAccent = Color(0xFF0A84FF);
  static const Color _neutralBg = Color(0xFF1C1C1E);
  static const Color _neutralFg = Color(0xFFFFFFFF);

  /// Shows a success snackbar (green accent, checkmark).
  static void success({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = _defaultDuration,
  }) {
    _showWithVariant(
      message: message,
      variant: KruiSnackbarVariant.success,
      icon: Icons.check_circle_rounded,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Shows a danger/error snackbar (red accent).
  static void danger({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = _defaultDuration,
  }) {
    _showWithVariant(
      message: message,
      variant: KruiSnackbarVariant.danger,
      icon: Icons.error_rounded,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Shows a warning snackbar (amber accent).
  static void warning({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = _defaultDuration,
  }) {
    _showWithVariant(
      message: message,
      variant: KruiSnackbarVariant.warning,
      icon: Icons.warning_rounded,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Shows an info snackbar (blue accent).
  static void info({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = _defaultDuration,
  }) {
    _showWithVariant(
      message: message,
      variant: KruiSnackbarVariant.info,
      icon: Icons.info_rounded,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  /// Shows a neutral snackbar (no accent, default style).
  static void neutral({
    required String message,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = _defaultDuration,
  }) {
    _showWithVariant(
      message: message,
      variant: KruiSnackbarVariant.neutral,
      icon: icon,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void _showWithVariant({
    required String message,
    required KruiSnackbarVariant variant,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    required Duration duration,
  }) {
    Color bg;
    Color accent;
    final effectiveIcon = icon ?? _defaultIconForVariant(variant);
    switch (variant) {
      case KruiSnackbarVariant.success:
        bg = _successBg;
        accent = _successAccent;
        break;
      case KruiSnackbarVariant.danger:
        bg = _dangerBg;
        accent = _dangerAccent;
        break;
      case KruiSnackbarVariant.warning:
        bg = _warningBg;
        accent = _warningAccent;
        break;
      case KruiSnackbarVariant.info:
        bg = _infoBg;
        accent = _infoAccent;
        break;
      case KruiSnackbarVariant.neutral:
        bg = _neutralBg;
        accent = _neutralFg;
        break;
    }
    show(
      message: message,
      icon: effectiveIcon,
      iconColor: variant == KruiSnackbarVariant.neutral ? _neutralFg : accent,
      backgroundColor: bg,
      foregroundColor: _neutralFg,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      accentColor: variant == KruiSnackbarVariant.neutral ? null : accent,
    );
  }

  static IconData _defaultIconForVariant(KruiSnackbarVariant v) {
    switch (v) {
      case KruiSnackbarVariant.success:
        return Icons.check_circle_rounded;
      case KruiSnackbarVariant.danger:
        return Icons.error_rounded;
      case KruiSnackbarVariant.warning:
        return Icons.warning_rounded;
      case KruiSnackbarVariant.info:
        return Icons.info_rounded;
      case KruiSnackbarVariant.neutral:
        return Icons.notifications_none_rounded;
    }
  }

  /// Shows a custom snackbar. No context needed.
  static void show({
    required String message,
    IconData? icon,
    Color? iconColor,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = _defaultDuration,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? accentColor,
  }) {
    final overlay = KruiInitializer.navigatorKey.currentState?.overlay;

    if (overlay == null) {
      debugPrint(
          'KruiSnackbar: Overlay not found. Set MaterialApp.navigatorKey to KruiInitializer.navigatorKey.');
      return;
    }

    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDark = brightness == Brightness.dark;
    final bg = backgroundColor ??
        (isDark ? const Color(0xFF2C2C2E) : const Color(0xFF1C1C1E));
    final fg = foregroundColor ?? const Color(0xFFFFFFFF);
    final iconTint = iconColor ?? fg;
    final accent = accentColor;

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _SnackbarWidget(
        message: message,
        icon: icon,
        iconColor: iconTint,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
        backgroundColor: bg,
        foregroundColor: fg,
        accentColor: accent,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
}

class _SnackbarWidget extends StatefulWidget {
  final String message;
  final IconData? icon;
  final Color iconColor;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? accentColor;
  final VoidCallback onDismiss;

  const _SnackbarWidget({
    required this.message,
    this.icon,
    required this.iconColor,
    this.actionLabel,
    this.onAction,
    required this.duration,
    required this.backgroundColor,
    required this.foregroundColor,
    this.accentColor,
    required this.onDismiss,
  });

  @override
  State<_SnackbarWidget> createState() => _SnackbarWidgetState();
}

class _SnackbarWidgetState extends State<_SnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

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
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.9, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.9, curve: Curves.easeOutCubic),
      ),
    );

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
    final hasAccent = widget.accentColor != null;

    return Positioned(
      bottom: 28,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (widget.accentColor ?? widget.foregroundColor)
                          .withValues(alpha: 0.12),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          if (hasAccent)
                            Container(
                              width: 4,
                              color: widget.accentColor,
                            ),
                          if (widget.icon != null) ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 16, bottom: 16),
                              child: Icon(
                                widget.icon,
                                color: widget.iconColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                widget.icon == null ? (hasAccent ? 16 : 20) : 0,
                                16,
                                16,
                                16,
                              ),
                              child: Text(
                                widget.message,
                                style: TextStyle(
                                  color: widget.foregroundColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.2,
                                  height: 1.35,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          if (widget.actionLabel != null &&
                              widget.onAction != null) ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 12, top: 8, bottom: 8),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    widget.onAction?.call();
                                    widget.onDismiss();
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      widget.actionLabel!,
                                      style: TextStyle(
                                        color: widget.accentColor ??
                                            widget.foregroundColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
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
      ),
    );
  }
}
