// KRUI — Reusable UI components (krui-style)
// Countdown timer: OTP resend, fitness, workouts, etc.

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ═══════════════════════════════════════════════════════════════════════════
// COUNTDOWN TIMER
// ═══════════════════════════════════════════════════════════════════════════

/// Format for displaying remaining time.
enum KruiCountdownFormat {
  /// e.g. "45"
  seconds,

  /// e.g. "1:23"
  mmSs,

  /// e.g. "1:05:30"
  hhMmSs,

  /// e.g. "2d 5h 30m 15s" (days, hours, minutes, seconds)
  days,

  /// e.g. "2d 05:30:15" (days + HH:MM:SS)
  daysHhMmSs,
}

/// Visual style variants for the countdown.
enum KruiCountdownVariant {
  /// Plain text, minimal chrome.
  simple,

  /// Glassmorphism: blur, border, subtle gradient.
  liquidGlass,

  /// Circular progress ring with time in center.
  circularProgress,

  /// Very compact, small text.
  minimal,

  /// Bold, large numbers; good for fitness/workout.
  fitness,

  /// Digital segment boxes (e.g. event launch: [02] [05] [30] [15]).
  segments,
}

/// Controller for [KruiCountdown]. Start, pause, reset, and observe remaining time.
class KruiCountdownController extends ChangeNotifier {
  KruiCountdownController({
    required Duration initialDuration,
    this.autoStart = true,
    this.tickDuration = const Duration(seconds: 1),
    this.countUp = false,
    this.hapticOnComplete = false,
  })  : _initialDuration = initialDuration,
        _remaining = initialDuration,
        _elapsed = Duration.zero;

  final Duration _initialDuration;
  final bool autoStart;

  /// How often the countdown updates (e.g. every 1 second, 5 seconds, or custom).
  /// Default is 1 second. Use [Duration(seconds: 5)] for a 5-second tick, etc.
  final Duration tickDuration;

  /// If true, timer counts up from zero (elapsed time) instead of down.
  final bool countUp;

  /// If true, triggers haptic feedback when countdown reaches zero.
  final bool hapticOnComplete;

  Duration get initialDuration => _initialDuration;

  /// Time left (countdown) or time left until "complete" in count-up mode.
  Duration get remaining => countUp ? _initialDuration - _elapsed : _remaining;

  /// Time elapsed (only meaningful in count-up mode; in countdown mode it's initial - remaining).
  Duration get elapsed => countUp ? _elapsed : _initialDuration - _remaining;

  /// Progress from 0.0 (just started) to 1.0 (complete). Use for custom progress bars/rings.
  double get progress {
    final total = _initialDuration.inSeconds;
    if (total <= 0) return 1.0;
    final left = remaining.inSeconds;
    return (1.0 - (left / total)).clamp(0.0, 1.0);
  }

  bool get isRunning => _timer != null && _timer!.isActive;
  bool get isCompleted =>
      countUp ? _elapsed >= _initialDuration : _remaining <= Duration.zero;

  Duration _remaining;
  Duration _elapsed;
  Timer? _timer;
  VoidCallback? _onComplete;
  void Function(Duration remaining)? _onTick;

  /// Called when countdown reaches zero (or elapsed reaches duration in count-up mode).
  void setOnComplete(VoidCallback? cb) => _onComplete = cb;

  /// Called every [tickDuration] with remaining time (or elapsed in count-up mode via remaining).
  void setOnTick(void Function(Duration remaining)? cb) => _onTick = cb;

  /// Start or resume.
  void start() {
    if (_timer != null && _timer!.isActive) return;
    if (countUp && _elapsed >= _initialDuration) return;
    if (!countUp && _remaining <= Duration.zero) return;

    _timer?.cancel();
    _timer = Timer.periodic(tickDuration, (_) => _tick());
    notifyListeners();
  }

  /// Pause (keeps current value).
  void pause() {
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  /// Reset. In count-up mode resets elapsed to zero.
  void reset() {
    _timer?.cancel();
    _timer = null;
    _remaining = _initialDuration;
    _elapsed = Duration.zero;
    notifyListeners();
    if (autoStart) start();
  }

  /// Restart from full duration and start.
  void restart() {
    _remaining = _initialDuration;
    _elapsed = Duration.zero;
    reset();
  }

  void _tick() {
    if (countUp) {
      _elapsed += tickDuration;
      if (_elapsed >= _initialDuration) {
        _elapsed = _initialDuration;
        _timer?.cancel();
        _timer = null;
        if (hapticOnComplete) HapticFeedback.mediumImpact();
        _onComplete?.call();
      } else {
        _onTick?.call(_initialDuration - _elapsed);
      }
    } else {
      if (_remaining <= Duration.zero) {
        _timer?.cancel();
        _timer = null;
        if (hapticOnComplete) HapticFeedback.mediumImpact();
        _onComplete?.call();
        notifyListeners();
        return;
      }
      _remaining -= tickDuration;
      if (_remaining < Duration.zero) _remaining = Duration.zero;
      _onTick?.call(_remaining);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Formats [duration] as string per [format].
/// [leadingZeros] pads numbers (e.g. "01:05" instead of "1:5").
String kruiFormatCountdown(
  Duration duration,
  KruiCountdownFormat format, {
  bool leadingZeros = false,
}) {
  if (duration < Duration.zero) duration = Duration.zero;
  final s = duration.inSeconds;
  String pad(int n, int width) =>
      leadingZeros ? n.toString().padLeft(width, '0') : '$n';

  switch (format) {
    case KruiCountdownFormat.seconds:
      return pad(s, 1);
    case KruiCountdownFormat.mmSs:
      final m = s ~/ 60;
      final sec = s % 60;
      return '${pad(m, 1)}:${sec.toString().padLeft(2, '0')}';
    case KruiCountdownFormat.hhMmSs:
      final h = s ~/ 3600;
      final m = (s % 3600) ~/ 60;
      final sec = s % 60;
      return '${pad(h, 1)}:${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
    case KruiCountdownFormat.days:
      final d = s ~/ 86400;
      final h = (s % 86400) ~/ 3600;
      final m = (s % 3600) ~/ 60;
      final sec = s % 60;
      final parts = <String>[];
      if (d > 0) parts.add('${d}d');
      if (h > 0 || parts.isNotEmpty) parts.add('${h}h');
      if (m > 0 || parts.isNotEmpty) parts.add('${m}m');
      parts.add('${sec}s');
      return parts.join(' ');
    case KruiCountdownFormat.daysHhMmSs:
      final d = s ~/ 86400;
      final h = (s % 86400) ~/ 3600;
      final m = (s % 3600) ~/ 60;
      final sec = s % 60;
      final time =
          '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
      return d > 0 ? '${d}d $time' : time;
  }
}

/// Returns [days, hours, minutes, seconds] for segment-style UIs.
List<int> kruiCountdownSegments(Duration duration) {
  if (duration < Duration.zero) duration = Duration.zero;
  final s = duration.inSeconds;
  return [
    s ~/ 86400,
    (s % 86400) ~/ 3600,
    (s % 3600) ~/ 60,
    s % 60,
  ];
}

/// Reusable countdown timer widget. Use dot notation for variants:
/// [KruiCountdown.simple], [KruiCountdown.liquidGlass], [KruiCountdown.circularProgress],
/// [KruiCountdown.minimal], [KruiCountdown.fitness], [KruiCountdown.segments], [KruiCountdown.otpResend].
class KruiCountdown extends StatefulWidget {
  const KruiCountdown({
    super.key,
    required this.duration,
    required this.controller,
    this.variant = KruiCountdownVariant.simple,
    this.format = KruiCountdownFormat.mmSs,
    this.formatBuilder,
    this.leadingZeros = false,
    this.semanticLabel,
    this.onComplete,
    this.onTick,
    this.label,
    this.actionLabel,
    this.onAction,
    this.size = 56.0,
    this.primaryColor,
    this.secondaryColor,
    this.textStyle,
    this.labelStyle,
    this.borderRadius,
    this.padding,
  });

  /// Total countdown duration.
  final Duration duration;

  /// Controller to start/pause/reset. Create with [KruiCountdownController].
  final KruiCountdownController controller;

  /// Visual variant (set automatically when using dot constructors).
  final KruiCountdownVariant variant;

  /// How to display time: [KruiCountdownFormat.seconds], [mmSs], [hhMmSs], [days], [daysHhMmSs].
  final KruiCountdownFormat format;

  /// Optional custom formatter. If set, overrides [format] and returns any string for [Duration] remaining.
  /// Use for fully custom display (e.g. "2 days left", localized strings, custom units).
  final String Function(Duration remaining)? formatBuilder;

  /// When true, pads numbers (e.g. "01:05" instead of "1:5"). Only applies when [formatBuilder] is null.
  final bool leadingZeros;

  /// Accessibility: custom label for screen readers. If null, a readable time string is used (e.g. "2 minutes 30 seconds remaining").
  final String? semanticLabel;

  /// Called when countdown reaches zero.
  final VoidCallback? onComplete;

  /// Called every [KruiCountdownController.tickDuration] with remaining time.
  final void Function(Duration remaining)? onTick;

  /// Optional label below or beside the timer (e.g. "Resend in", "Rest").
  final String? label;

  /// Optional action label when completed (e.g. "Resend OTP").
  final String? actionLabel;

  /// When [actionLabel] is set and countdown is done, this is called when user taps.
  final VoidCallback? onAction;

  /// Base size (diameter for circular, or height for others). Responsive if needed.
  final double size;

  /// Primary color (progress, text, accent).
  final Color? primaryColor;

  /// Secondary color (track, background tint).
  final Color? secondaryColor;

  /// Custom text style for the time.
  final TextStyle? textStyle;

  /// Custom text style for [label].
  final TextStyle? labelStyle;

  /// Border radius for variants that use a container (e.g. liquidGlass).
  final double? borderRadius;

  /// Padding around the content.
  final EdgeInsets? padding;

  // ─── Dot notation constructors (variant + full customization) ───

  /// Plain text countdown, e.g. "1:23". Fully customizable.
  factory KruiCountdown.simple({
    Key? key,
    required Duration duration,
    required KruiCountdownController controller,
    KruiCountdownFormat format = KruiCountdownFormat.mmSs,
    String Function(Duration remaining)? formatBuilder,
    VoidCallback? onComplete,
    void Function(Duration remaining)? onTick,
    String? label,
    String? actionLabel,
    VoidCallback? onAction,
    double size = 48.0,
    Color? primaryColor,
    Color? secondaryColor,
    TextStyle? textStyle,
    TextStyle? labelStyle,
    EdgeInsets? padding,
  }) =>
      KruiCountdown(
        key: key,
        duration: duration,
        controller: controller,
        variant: KruiCountdownVariant.simple,
        format: format,
        formatBuilder: formatBuilder,
        onComplete: onComplete,
        onTick: onTick,
        label: label,
        actionLabel: actionLabel,
        onAction: onAction,
        size: size,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        textStyle: textStyle,
        labelStyle: labelStyle,
        padding: padding,
      );

  /// Glassmorphism style: blur, border, gradient. Fully customizable.
  factory KruiCountdown.liquidGlass({
    Key? key,
    required Duration duration,
    required KruiCountdownController controller,
    KruiCountdownFormat format = KruiCountdownFormat.mmSs,
    String Function(Duration remaining)? formatBuilder,
    VoidCallback? onComplete,
    void Function(Duration remaining)? onTick,
    String? label,
    String? actionLabel,
    VoidCallback? onAction,
    double size = 64.0,
    Color? primaryColor,
    Color? secondaryColor,
    TextStyle? textStyle,
    TextStyle? labelStyle,
    double? borderRadius,
    EdgeInsets? padding,
  }) =>
      KruiCountdown(
        key: key,
        duration: duration,
        controller: controller,
        variant: KruiCountdownVariant.liquidGlass,
        format: format,
        formatBuilder: formatBuilder,
        onComplete: onComplete,
        onTick: onTick,
        label: label,
        actionLabel: actionLabel,
        onAction: onAction,
        size: size,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        textStyle: textStyle,
        labelStyle: labelStyle,
        borderRadius: borderRadius,
        padding: padding,
      );

  /// Circular progress ring with time in center. Fully customizable.
  factory KruiCountdown.circularProgress({
    Key? key,
    required Duration duration,
    required KruiCountdownController controller,
    KruiCountdownFormat format = KruiCountdownFormat.mmSs,
    String Function(Duration remaining)? formatBuilder,
    VoidCallback? onComplete,
    void Function(Duration remaining)? onTick,
    String? label,
    String? actionLabel,
    VoidCallback? onAction,
    double size = 56.0,
    Color? primaryColor,
    Color? secondaryColor,
    TextStyle? textStyle,
    TextStyle? labelStyle,
    EdgeInsets? padding,
  }) =>
      KruiCountdown(
        key: key,
        duration: duration,
        controller: controller,
        variant: KruiCountdownVariant.circularProgress,
        format: format,
        formatBuilder: formatBuilder,
        onComplete: onComplete,
        onTick: onTick,
        label: label,
        actionLabel: actionLabel,
        onAction: onAction,
        size: size,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        textStyle: textStyle,
        labelStyle: labelStyle,
        padding: padding,
      );

  /// Compact inline countdown. Fully customizable.
  factory KruiCountdown.minimal({
    Key? key,
    required Duration duration,
    required KruiCountdownController controller,
    KruiCountdownFormat format = KruiCountdownFormat.mmSs,
    String Function(Duration remaining)? formatBuilder,
    VoidCallback? onComplete,
    void Function(Duration remaining)? onTick,
    String? label,
    String? actionLabel,
    VoidCallback? onAction,
    double size = 40.0,
    Color? primaryColor,
    Color? secondaryColor,
    TextStyle? textStyle,
    TextStyle? labelStyle,
    EdgeInsets? padding,
  }) =>
      KruiCountdown(
        key: key,
        duration: duration,
        controller: controller,
        variant: KruiCountdownVariant.minimal,
        format: format,
        formatBuilder: formatBuilder,
        onComplete: onComplete,
        onTick: onTick,
        label: label,
        actionLabel: actionLabel,
        onAction: onAction,
        size: size,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        textStyle: textStyle,
        labelStyle: labelStyle,
        padding: padding,
      );

  /// Bold fitness/workout style with pulse. Fully customizable.
  factory KruiCountdown.fitness({
    Key? key,
    required Duration duration,
    required KruiCountdownController controller,
    KruiCountdownFormat format = KruiCountdownFormat.mmSs,
    String Function(Duration remaining)? formatBuilder,
    VoidCallback? onComplete,
    void Function(Duration remaining)? onTick,
    String? label,
    String? actionLabel,
    VoidCallback? onAction,
    double size = 72.0,
    Color? primaryColor,
    Color? secondaryColor,
    TextStyle? textStyle,
    TextStyle? labelStyle,
    EdgeInsets? padding,
  }) =>
      KruiCountdown(
        key: key,
        duration: duration,
        controller: controller,
        variant: KruiCountdownVariant.fitness,
        format: format,
        formatBuilder: formatBuilder,
        onComplete: onComplete,
        onTick: onTick,
        label: label,
        actionLabel: actionLabel,
        onAction: onAction,
        size: size,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        textStyle: textStyle,
        labelStyle: labelStyle,
        padding: padding,
      );

  /// Digital segment boxes (event/launch style): [02] [05] [30] [15] with Days/Hours/Mins/Secs.
  factory KruiCountdown.segments({
    Key? key,
    required Duration duration,
    required KruiCountdownController controller,
    VoidCallback? onComplete,
    void Function(Duration remaining)? onTick,
    String? label,
    String? actionLabel,
    VoidCallback? onAction,
    double size = 64.0,
    Color? primaryColor,
    Color? secondaryColor,
    TextStyle? textStyle,
    TextStyle? labelStyle,
    String? semanticLabel,
    EdgeInsets? padding,
  }) =>
      KruiCountdown(
        key: key,
        duration: duration,
        controller: controller,
        variant: KruiCountdownVariant.segments,
        onComplete: onComplete,
        onTick: onTick,
        label: label,
        actionLabel: actionLabel,
        onAction: onAction,
        size: size,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        textStyle: textStyle,
        labelStyle: labelStyle,
        semanticLabel: semanticLabel,
        padding: padding,
      );

  /// OTP resend: circular progress + "Resend" when done. Same params, format defaults to seconds.
  factory KruiCountdown.otpResend({
    Key? key,
    required Duration duration,
    required KruiCountdownController controller,
    VoidCallback? onResend,
    String label = 'Resend in',
    double size = 56.0,
    Color? primaryColor,
    Color? secondaryColor,
    TextStyle? textStyle,
    TextStyle? labelStyle,
    EdgeInsets? padding,
    String Function(Duration remaining)? formatBuilder,
  }) =>
      KruiCountdown(
        key: key,
        duration: duration,
        controller: controller,
        variant: KruiCountdownVariant.circularProgress,
        format: KruiCountdownFormat.seconds,
        formatBuilder: formatBuilder,
        label: label,
        actionLabel: 'Resend',
        onAction: onResend,
        size: size,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        textStyle: textStyle,
        labelStyle: labelStyle,
        padding: padding,
      );

  @override
  State<KruiCountdown> createState() => _KruiCountdownState();
}

class _KruiCountdownState extends State<KruiCountdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _pulseActive = false;

  @override
  void initState() {
    super.initState();
    widget.controller.setOnComplete(_handleComplete);
    widget.controller.setOnTick(widget.onTick);
    if (widget.controller.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.controller.start();
      });
    }

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.variant == KruiCountdownVariant.fitness) {
      _pulseActive = true;
      _pulseController.repeat(reverse: true);
    }
  }

  void _handleComplete() {
    widget.onComplete?.call();
  }

  @override
  void didUpdateWidget(KruiCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.setOnComplete(null);
      oldWidget.controller.setOnTick(null);
      widget.controller.setOnComplete(_handleComplete);
      widget.controller.setOnTick(widget.onTick);
      if (widget.controller.autoStart) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) widget.controller.start();
        });
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color get _primary =>
      widget.primaryColor ?? Theme.of(context).colorScheme.primary;
  Color get _secondary =>
      widget.secondaryColor ??
      Theme.of(context).colorScheme.surfaceContainerHighest;

  String _displayText(Duration remaining) => widget.formatBuilder != null
      ? widget.formatBuilder!(remaining)
      : kruiFormatCountdown(remaining, widget.format,
          leadingZeros: widget.leadingZeros);

  /// Human-readable duration for semantics (e.g. "2 minutes 30 seconds remaining").
  String _semanticText(Duration remaining) {
    if (widget.semanticLabel != null) return widget.semanticLabel!;
    if (remaining <= Duration.zero) return 'Countdown complete';
    final s = remaining.inSeconds;
    final parts = <String>[];
    if (s >= 86400) parts.add('${s ~/ 86400} days');
    if (s >= 3600) parts.add('${(s % 86400) ~/ 3600} hours');
    if (s >= 60) parts.add('${(s % 3600) ~/ 60} minutes');
    parts.add('${s % 60} seconds');
    return '${parts.join(' ')} remaining';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final remaining = widget.controller.remaining;
        final completed = widget.controller.isCompleted;
        final showAction =
            completed && widget.actionLabel != null && widget.onAction != null;

        final Widget child;
        switch (widget.variant) {
          case KruiCountdownVariant.simple:
            child = _buildSimple(remaining, completed, showAction);
            break;
          case KruiCountdownVariant.liquidGlass:
            child = _buildLiquidGlass(remaining, completed, showAction);
            break;
          case KruiCountdownVariant.circularProgress:
            child = _buildCircularProgress(remaining, completed, showAction);
            break;
          case KruiCountdownVariant.minimal:
            child = _buildMinimal(remaining, completed, showAction);
            break;
          case KruiCountdownVariant.fitness:
            child = _buildFitness(remaining, completed, showAction);
            break;
          case KruiCountdownVariant.segments:
            child = _buildSegments(remaining, completed, showAction);
            break;
        }
        final withSemantics = Semantics(
          liveRegion: true,
          label: _semanticText(remaining),
          child: child,
        );
        return RepaintBoundary(child: withSemantics);
      },
    );
  }

  Widget _buildSimple(Duration remaining, bool completed, bool showAction) {
    final padding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            completed && showAction
                ? widget.actionLabel!
                : _displayText(remaining),
            style: widget.textStyle ??
                TextStyle(
                  fontSize: widget.size * 0.45,
                  fontWeight: FontWeight.w700,
                  color: _primary,
                  letterSpacing: 0.5,
                ),
          ),
          if (widget.label != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.label!,
              style: widget.labelStyle ??
                  TextStyle(
                    fontSize: widget.size * 0.2,
                    color: _secondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
          if (showAction)
            TextButton(
              onPressed: widget.onAction,
              child: Text(widget.actionLabel!),
            ),
        ],
      ),
    );
  }

  Widget _buildLiquidGlass(
      Duration remaining, bool completed, bool showAction) {
    final r = widget.borderRadius ?? 20.0;
    final padding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
    return Padding(
      padding: padding,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(r),
          border: Border.all(
            color: _primary.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _primary.withValues(alpha: 0.08),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(r),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _primary.withValues(alpha: 0.06),
                    _secondary.withValues(alpha: 0.04),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    completed && showAction ? '—' : _displayText(remaining),
                    style: widget.textStyle ??
                        TextStyle(
                          fontSize: widget.size * 0.5,
                          fontWeight: FontWeight.w800,
                          color: _primary,
                          letterSpacing: 1,
                        ),
                  ),
                  if (widget.label != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      widget.label!,
                      style: widget.labelStyle ??
                          TextStyle(
                            fontSize: widget.size * 0.22,
                            color: _secondary,
                          ),
                    ),
                  ],
                  if (showAction) ...[
                    const SizedBox(height: 12),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onAction,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Text(
                            widget.actionLabel!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _primary,
                              fontSize: widget.size * 0.24,
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
    );
  }

  Widget _buildCircularProgress(
      Duration remaining, bool completed, bool showAction) {
    final totalSec = widget.duration.inSeconds;
    final remainingSec = remaining.inSeconds;
    final progress = totalSec > 0 ? (remainingSec / totalSec) : 0.0;
    final size = widget.size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RepaintBoundary(
          child: SizedBox(
            height: size,
            width: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: size,
                  width: size,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: size * 0.08,
                    backgroundColor: _secondary.withValues(alpha: 0.5),
                    valueColor: AlwaysStoppedAnimation<Color>(_primary),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                if (!completed || !showAction)
                  Text(
                    _displayText(remaining),
                    style: widget.textStyle ??
                        TextStyle(
                          fontSize: size * 0.28,
                          fontWeight: FontWeight.w700,
                          color: _primary,
                        ),
                  )
                else
                  GestureDetector(
                    onTap: widget.onAction,
                    child: Text(
                      widget.actionLabel ?? 'Resend',
                      style: widget.textStyle ??
                          TextStyle(
                            fontSize: size * 0.2,
                            fontWeight: FontWeight.w600,
                            color: _primary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.label != null) ...[
          SizedBox(height: size * 0.15),
          Text(
            widget.label!,
            style: widget.labelStyle ??
                TextStyle(
                  fontSize: size * 0.2,
                  color: _secondary,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildMinimal(Duration remaining, bool completed, bool showAction) {
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            completed && showAction
                ? widget.actionLabel!
                : _displayText(remaining),
            style: widget.textStyle ??
                TextStyle(
                  fontSize: widget.size * 0.3,
                  fontWeight: FontWeight.w600,
                  color: _primary,
                ),
          ),
          if (widget.label != null) ...[
            const SizedBox(width: 6),
            Text(
              widget.label!,
              style: widget.labelStyle ??
                  TextStyle(
                    fontSize: widget.size * 0.25,
                    color: _secondary,
                  ),
            ),
          ],
          if (showAction)
            TextButton(
              onPressed: widget.onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(widget.actionLabel!),
            ),
        ],
      ),
    );
  }

  Widget _buildFitness(Duration remaining, bool completed, bool showAction) {
    final scale = _pulseActive
        ? Tween<double>(begin: 0.96, end: 1.02).animate(
            CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
          )
        : null;
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final s = (scale != null && !completed) ? scale.value : 1.0;
              return Transform.scale(scale: s, child: child);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.size * 0.4,
                vertical: widget.size * 0.2,
              ),
              decoration: BoxDecoration(
                color: _primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Text(
                completed && showAction ? 'GO' : _displayText(remaining),
                style: widget.textStyle ??
                    TextStyle(
                      fontSize: widget.size * 0.55,
                      fontWeight: FontWeight.w900,
                      color: _primary,
                      letterSpacing: 2,
                    ),
              ),
            ),
          ),
          if (widget.label != null) ...[
            SizedBox(height: widget.size * 0.2),
            Text(
              widget.label!,
              style: widget.labelStyle ??
                  TextStyle(
                    fontSize: widget.size * 0.22,
                    color: _secondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
          if (showAction)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: FilledButton(
                onPressed: widget.onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(widget.actionLabel!),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSegments(Duration remaining, bool completed, bool showAction) {
    final seg = kruiCountdownSegments(remaining);
    const labels = ['Days', 'Hours', 'Mins', 'Secs'];
    final boxSize = widget.size * 0.9;
    final fontSize = boxSize * 0.35;
    final labelSize = boxSize * 0.18;

    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final value = completed && i == 3 ? 0 : seg[i];
              return Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? 0 : 6,
                  right: i == 3 ? 0 : 6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: boxSize,
                      height: boxSize,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _primary.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _primary.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        value.toString().padLeft(2, '0'),
                        style: widget.textStyle ??
                            TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w800,
                              color: _primary,
                              letterSpacing: 1,
                            ),
                      ),
                    ),
                    SizedBox(height: boxSize * 0.12),
                    Text(
                      labels[i],
                      style: widget.labelStyle ??
                          TextStyle(
                            fontSize: labelSize,
                            color: _secondary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              );
            }),
          ),
          if (widget.label != null) ...[
            SizedBox(height: widget.size * 0.2),
            Text(
              widget.label!,
              style: widget.labelStyle ??
                  TextStyle(
                    fontSize: labelSize,
                    color: _secondary,
                  ),
            ),
          ],
          if (showAction)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextButton(
                onPressed: widget.onAction,
                child: Text(widget.actionLabel ?? 'Action'),
              ),
            ),
        ],
      ),
    );
  }
}
