// ignore_for_file: library_private_types_in_public_api
// =============================================================================
// KRUIGradientBorder — kr_ui design system component
// Author: kr_ui team
// Dart SDK: >=3.0.0 | Flutter: >=3.10.0
//
// All public API lives in this single file:
//   • KRUIGradientBorderVariant    — variant enum
//   • KRUIGradientBorderStyle      — immutable config (copyWith / lerp / ==)
//   • KRUIGradientBorderTheme      — ThemeData extension
//   • KRUIGradientBorder           — the widget + named constructors
//   • _GradientBorderPainter       — CustomPainter (private)
//   • _SlideGradientTransform      — GradientTransform helper (private)
// =============================================================================

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 1 — Variant
// ─────────────────────────────────────────────────────────────────────────────

/// Controls the visual style and animation behaviour of [KruiGradientBorder].
enum KruiGradientBorderVariant {
  /// Static gradient stroke — zero animation overhead, layer-cached by Flutter.
  staticGradient,

  /// Continuously rotating conic gradient — the classic "aurora" card effect.
  rotating,

  /// A diagonal shimmer sweep that loops (or runs once). Ideal for loading
  /// skeletons and focused input fields.
  shimmer,

  /// Opacity pulses with a sine-wave — a soft "breathing" glow effect.
  breathing,

  /// Gradient line rendered only on the bottom edge. Good for tabs, labels,
  /// section headings.
  underline,

  /// Evenly-spaced dashed segments with a gradient fill — great for
  /// drop-zones and dashed containers.
  dashed,

  /// Neon / cyberpunk layered-blur border. Three draw calls: outer halo,
  /// mid halo, crisp gradient stroke on top.
  glow,
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 2 — Style
// ─────────────────────────────────────────────────────────────────────────────

/// {@template krui_gradient_border_style}
/// Immutable configuration object for [KruiGradientBorder].
///
/// Follows Flutter's own style pattern — supports [copyWith], [lerp],
/// value equality, and [debugFillProperties] out of the box.
///
/// All fields are optional with production-ready defaults so that
/// `const KRUIGradientBorderStyle()` is always safe to use as-is.
/// {@endtemplate}
@immutable
class KruiGradientBorderStyle with Diagnosticable {
  /// {@macro krui_gradient_border_style}
  const KruiGradientBorderStyle({
    this.colors = const [
      Color(0xFF8B5CF6),
      Color(0xFF06B6D4),
      Color(0xFFEC4899),
    ],
    this.borderWidth = 2.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.animationDuration = const Duration(seconds: 3),
    this.loop = true,
    this.minOpacity = 0.3,
    this.maxOpacity = 1.0,
    this.dashLength = 8.0,
    this.gapLength = 5.0,
    this.glowSpread = 6.0,
    this.glowColor,
    this.padding,
  })  : assert(borderWidth > 0,
            'KRUIGradientBorderStyle: borderWidth must be > 0.'),
        assert(minOpacity >= 0.0 && minOpacity <= 1.0,
            'minOpacity must be in [0, 1].'),
        assert(maxOpacity >= 0.0 && maxOpacity <= 1.0,
            'maxOpacity must be in [0, 1].'),
        assert(minOpacity <= maxOpacity, 'minOpacity must be <= maxOpacity.');
  // NOTE: colors.length >= 2 is validated at runtime in debugFillProperties
  // and in the painter. Dart's const evaluator prohibits List.length in asserts.

  // ── Fields ─────────────────────────────────────────────────────────────────

  /// Gradient color stops. Minimum 2 required.
  final List<Color> colors;

  /// Stroke width of the border in logical pixels.
  final double borderWidth;

  /// Corner radii. Use [BorderRadius.zero] for sharp corners.
  final BorderRadius borderRadius;

  /// Duration of one full animation cycle.
  final Duration animationDuration;

  /// `true` = loop forever, `false` = play once then stop.
  final bool loop;

  /// Minimum opacity used by the breathing / glow variants. Range: `[0, 1]`.
  final double minOpacity;

  /// Maximum opacity used by the breathing / glow variants. Range: `[0, 1]`.
  final double maxOpacity;

  /// Dash segment length in logical pixels (dashed variant only).
  final double dashLength;

  /// Gap between dash segments in logical pixels (dashed variant only).
  final double gapLength;

  /// Blur sigma for the outer glow halo (glow / breathing variants).
  final double glowSpread;

  /// Override the glow tint color. Falls back to `colors.first` when `null`.
  final Color? glowColor;

  /// Explicit padding between the border stroke and the child widget.
  /// Defaults to `EdgeInsets.all(borderWidth)` when `null`.
  final EdgeInsetsGeometry? padding;

  // ── copyWith ───────────────────────────────────────────────────────────────

  /// Returns a new [KruiGradientBorderStyle] with specified fields replaced.
  KruiGradientBorderStyle copyWith({
    List<Color>? colors,
    double? borderWidth,
    BorderRadius? borderRadius,
    Duration? animationDuration,
    bool? loop,
    double? minOpacity,
    double? maxOpacity,
    double? dashLength,
    double? gapLength,
    double? glowSpread,
    Color? glowColor,
    EdgeInsetsGeometry? padding,
  }) {
    return KruiGradientBorderStyle(
      colors: colors ?? this.colors,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      animationDuration: animationDuration ?? this.animationDuration,
      loop: loop ?? this.loop,
      minOpacity: minOpacity ?? this.minOpacity,
      maxOpacity: maxOpacity ?? this.maxOpacity,
      dashLength: dashLength ?? this.dashLength,
      gapLength: gapLength ?? this.gapLength,
      glowSpread: glowSpread ?? this.glowSpread,
      glowColor: glowColor ?? this.glowColor,
      padding: padding ?? this.padding,
    );
  }

  // ── lerp ───────────────────────────────────────────────────────────────────

  /// Linearly interpolates between two styles. Safe to call with `null`.
  static KruiGradientBorderStyle lerp(
    KruiGradientBorderStyle? a,
    KruiGradientBorderStyle? b,
    double t,
  ) {
    if (a == null && b == null) return const KruiGradientBorderStyle();
    if (a == null) return b!;
    if (b == null) return a;

    final len = math.max(a.colors.length, b.colors.length);
    final lerpedColors = List<Color>.generate(len, (i) {
      final ca = i < a.colors.length ? a.colors[i] : a.colors.last;
      final cb = i < b.colors.length ? b.colors[i] : b.colors.last;
      return Color.lerp(ca, cb, t) ?? ca;
    });

    return KruiGradientBorderStyle(
      colors: lerpedColors,
      borderWidth: _ld(a.borderWidth, b.borderWidth, t),
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t) ??
          a.borderRadius,
      animationDuration: a.animationDuration,
      loop: t < 0.5 ? a.loop : b.loop,
      minOpacity: _ld(a.minOpacity, b.minOpacity, t),
      maxOpacity: _ld(a.maxOpacity, b.maxOpacity, t),
      dashLength: _ld(a.dashLength, b.dashLength, t),
      gapLength: _ld(a.gapLength, b.gapLength, t),
      glowSpread: _ld(a.glowSpread, b.glowSpread, t),
      glowColor: Color.lerp(a.glowColor, b.glowColor, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
    );
  }

  static double _ld(double a, double b, double t) => a + (b - a) * t;

  // ── Equality ───────────────────────────────────────────────────────────────

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KruiGradientBorderStyle &&
        listEquals(colors, other.colors) &&
        borderWidth == other.borderWidth &&
        borderRadius == other.borderRadius &&
        animationDuration == other.animationDuration &&
        loop == other.loop &&
        minOpacity == other.minOpacity &&
        maxOpacity == other.maxOpacity &&
        dashLength == other.dashLength &&
        gapLength == other.gapLength &&
        glowSpread == other.glowSpread &&
        glowColor == other.glowColor &&
        padding == other.padding;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(colors),
        borderWidth,
        borderRadius,
        animationDuration,
        loop,
        minOpacity,
        maxOpacity,
        dashLength,
        gapLength,
        glowSpread,
        glowColor,
        padding,
      );

  // ── Diagnostics ────────────────────────────────────────────────────────────

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    assert(colors.length >= 2,
        'KRUIGradientBorderStyle: colors must have >= 2 entries, got ${colors.length}.');
    properties
      ..add(IterableProperty<Color>('colors', colors))
      ..add(DoubleProperty('borderWidth', borderWidth))
      ..add(DiagnosticsProperty<BorderRadius>('borderRadius', borderRadius))
      ..add(
          DiagnosticsProperty<Duration>('animationDuration', animationDuration))
      ..add(FlagProperty('loop', value: loop, ifTrue: 'loop', ifFalse: 'once'))
      ..add(DoubleProperty('minOpacity', minOpacity))
      ..add(DoubleProperty('maxOpacity', maxOpacity))
      ..add(DoubleProperty('dashLength', dashLength))
      ..add(DoubleProperty('gapLength', gapLength))
      ..add(DoubleProperty('glowSpread', glowSpread))
      ..add(ColorProperty('glowColor', glowColor))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'KRUIGradientBorderStyle(colors: $colors, borderWidth: $borderWidth, borderRadius: $borderRadius)';
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 3 — Theme Extension
// ─────────────────────────────────────────────────────────────────────────────

/// {@template krui_gradient_border_theme}
/// A [ThemeExtension] that registers a default [KruiGradientBorderStyle] in
/// your app's [ThemeData], giving every [KruiGradientBorder] a consistent
/// baseline style without repeating arguments everywhere.
///
/// ```dart
/// // Register once in MaterialApp:
/// theme: ThemeData(extensions: [
///   KRUIGradientBorderTheme(
///     defaultStyle: KRUIGradientBorderStyle(
///       colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
///     ),
///   ),
/// ])
///
/// // Read anywhere:
/// final theme = KRUIGradientBorderTheme.of(context);
/// ```
/// {@endtemplate}
@immutable
class KruiGradientBorderTheme extends ThemeExtension<KruiGradientBorderTheme> {
  const KruiGradientBorderTheme({
    this.defaultStyle = const KruiGradientBorderStyle(),
  });

  final KruiGradientBorderStyle defaultStyle;

  /// Returns the nearest registered [KruiGradientBorderTheme], or the
  /// built-in default if none is registered.
  static KruiGradientBorderTheme of(BuildContext context) =>
      Theme.of(context).extension<KruiGradientBorderTheme>() ??
      const KruiGradientBorderTheme();

  @override
  KruiGradientBorderTheme copyWith({KruiGradientBorderStyle? defaultStyle}) =>
      KruiGradientBorderTheme(defaultStyle: defaultStyle ?? this.defaultStyle);

  @override
  KruiGradientBorderTheme lerp(
    ThemeExtension<KruiGradientBorderTheme>? other,
    double t,
  ) {
    if (other is! KruiGradientBorderTheme) return this;
    return KruiGradientBorderTheme(
      defaultStyle:
          KruiGradientBorderStyle.lerp(defaultStyle, other.defaultStyle, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KruiGradientBorderTheme && other.defaultStyle == defaultStyle;

  @override
  int get hashCode => defaultStyle.hashCode;
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 4 — Widget
// ─────────────────────────────────────────────────────────────────────────────

/// {@template krui_gradient_border}
/// A zero-dependency, production-grade gradient border wrapper for the
/// `kr_ui` design system.
///
/// Renders any child widget inside a fully-customizable gradient border via
/// [CustomPainter]. Animated variants run a single [AnimationController]
/// and isolate repaints so the **child subtree is never repainted** during
/// animation ticks.
///
/// ## Variants at a glance
///
/// | Variant | Constructor | Animated |
/// |---|---|---|
/// | Static gradient | `KRUIGradientBorder(...)` | ❌ |
/// | Rotating conic | `.rotating(...)` | ✅ |
/// | Shimmer sweep | `.shimmer(...)` | ✅ |
/// | Breathing glow | `.breathing(...)` | ✅ |
/// | Neon glow | `.glow(...)` | ✅ or static |
/// | Underline only | `.underline(...)` | optional |
/// | Dashed | `.dashed(...)` | ❌ |
///
/// ## Minimal usage
/// ```dart
/// KRUIGradientBorder(
///   style: KRUIGradientBorderStyle(
///     colors: [Colors.purple, Colors.cyan],
///     borderWidth: 2.5,
///     borderRadius: BorderRadius.circular(16),
///   ),
///   child: YourWidget(),
/// )
/// ```
///
/// ## External controller
/// Pass [externalController] to drive the animation yourself — perfect for
/// syncing with focus, hover, or scroll events.
/// {@endtemplate}
class KruiGradientBorder extends StatefulWidget {
  /// {@macro krui_gradient_border}
  const KruiGradientBorder({
    super.key,
    required this.child,
    this.style = const KruiGradientBorderStyle(),
    this.variant = KruiGradientBorderVariant.staticGradient,
    this.externalController,
    this.onAnimationComplete,
  });

  // ── Named constructors ────────────────────────────────────────────────────

  /// Rotating conic gradient — classic aurora/holographic card effect.
  factory KruiGradientBorder.rotating({
    Key? key,
    required Widget child,
    List<Color>? colors,
    double borderWidth = 2.0,
    BorderRadius? borderRadius,
    Duration duration = const Duration(seconds: 3),
    AnimationController? externalController,
  }) =>
      KruiGradientBorder(
        key: key,
        variant: KruiGradientBorderVariant.rotating,
        externalController: externalController,
        style: KruiGradientBorderStyle(
          colors: colors ??
              const [
                Color(0xFF8B5CF6),
                Color(0xFF06B6D4),
                Color(0xFFEC4899),
                Color(0xFF8B5CF6)
              ],
          borderWidth: borderWidth,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          animationDuration: duration,
        ),
        child: child,
      );

  /// Diagonal shimmer sweep — loading skeletons, focused inputs.
  factory KruiGradientBorder.shimmer({
    Key? key,
    required Widget child,
    List<Color>? colors,
    double borderWidth = 2.0,
    BorderRadius? borderRadius,
    Duration duration = const Duration(milliseconds: 1500),
    bool loop = true,
    AnimationController? externalController,
  }) =>
      KruiGradientBorder(
        key: key,
        variant: KruiGradientBorderVariant.shimmer,
        externalController: externalController,
        style: KruiGradientBorderStyle(
          colors: colors ??
              const [
                Color(0xFF1E293B),
                Color(0xFF94A3B8),
                Color(0xFFE2E8F0),
                Color(0xFF94A3B8),
                Color(0xFF1E293B)
              ],
          borderWidth: borderWidth,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          animationDuration: duration,
          loop: loop,
        ),
        child: child,
      );

  /// Breathing sine-wave opacity pulse — focused states, alerts, live indicators.
  factory KruiGradientBorder.breathing({
    Key? key,
    required Widget child,
    List<Color>? colors,
    double borderWidth = 2.5,
    BorderRadius? borderRadius,
    double glowSpread = 6.0,
    double minOpacity = 0.2,
    double maxOpacity = 1.0,
    Duration duration = const Duration(seconds: 2),
  }) =>
      KruiGradientBorder(
        key: key,
        variant: KruiGradientBorderVariant.breathing,
        style: KruiGradientBorderStyle(
          colors: colors ??
              const [Color(0xFF6EE7B7), Color(0xFF3B82F6), Color(0xFF9333EA)],
          borderWidth: borderWidth,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          glowSpread: glowSpread,
          animationDuration: duration,
          minOpacity: minOpacity,
          maxOpacity: maxOpacity,
        ),
        child: child,
      );

  /// Bottom gradient underline — tabs, section labels, nav items.
  factory KruiGradientBorder.underline({
    Key? key,
    required Widget child,
    List<Color>? colors,
    double lineHeight = 2.0,
    bool animated = false,
    Duration duration = const Duration(seconds: 2),
  }) =>
      KruiGradientBorder(
        key: key,
        variant: animated
            ? KruiGradientBorderVariant.shimmer
            : KruiGradientBorderVariant.underline,
        style: KruiGradientBorderStyle(
          colors: colors ??
              const [Color(0xFF8B5CF6), Color(0xFFEC4899), Color(0xFF06B6D4)],
          borderWidth: lineHeight,
          borderRadius: BorderRadius.zero,
          animationDuration: duration,
        ),
        child: child,
      );

  /// Evenly-spaced dashed gradient border — drop zones, dashed containers.
  factory KruiGradientBorder.dashed({
    Key? key,
    required Widget child,
    List<Color>? colors,
    double borderWidth = 2.0,
    BorderRadius? borderRadius,
    double dashLength = 8.0,
    double gapLength = 5.0,
  }) =>
      KruiGradientBorder(
        key: key,
        variant: KruiGradientBorderVariant.dashed,
        style: KruiGradientBorderStyle(
          colors: colors ??
              const [Color(0xFFF59E0B), Color(0xFFEF4444), Color(0xFF8B5CF6)],
          borderWidth: borderWidth,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          dashLength: dashLength,
          gapLength: gapLength,
        ),
        child: child,
      );

  /// Neon / cyberpunk layered glow border. Animated by default.
  factory KruiGradientBorder.glow({
    Key? key,
    required Widget child,
    Color glowColor = const Color(0xFF06B6D4),
    double borderWidth = 1.5,
    BorderRadius? borderRadius,
    double glowSpread = 8.0,
    bool animated = true,
    Duration duration = const Duration(seconds: 2),
  }) =>
      KruiGradientBorder(
        key: key,
        variant: animated
            ? KruiGradientBorderVariant.breathing
            : KruiGradientBorderVariant.glow,
        style: KruiGradientBorderStyle(
          colors: [
            glowColor.withValues(alpha: 0.6),
            glowColor,
            glowColor.withValues(alpha: 0.6)
          ],
          borderWidth: borderWidth,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          glowSpread: glowSpread,
          glowColor: glowColor,
          animationDuration: duration,
        ),
        child: child,
      );

  // ── Fields ─────────────────────────────────────────────────────────────────

  final Widget child;
  final KruiGradientBorderStyle style;
  final KruiGradientBorderVariant variant;

  /// Optional caller-owned controller. When provided, the widget will NOT
  /// create its own — giving the caller full playback control (play on focus,
  /// pause on blur, reverse on dismiss, etc.).
  final AnimationController? externalController;

  /// Called once when `loop: false` and the animation completes.
  final VoidCallback? onAnimationComplete;

  @override
  State<KruiGradientBorder> createState() => _KruiGradientBorderState();
}

// ─── State ────────────────────────────────────────────────────────────────────

class _KruiGradientBorderState extends State<KruiGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _ownsCtrl = false;

  // Variants that need no tick at all.
  bool get _isAnimated =>
      widget.variant != KruiGradientBorderVariant.staticGradient &&
      widget.variant != KruiGradientBorderVariant.underline &&
      widget.variant != KruiGradientBorderVariant.dashed &&
      widget.variant != KruiGradientBorderVariant.glow;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    if (widget.externalController != null) {
      _ctrl = widget.externalController!;
      _ownsCtrl = false;
    } else {
      _ctrl = AnimationController(
          vsync: this, duration: widget.style.animationDuration);
      _ownsCtrl = true;
    }
    _anim = CurvedAnimation(parent: _ctrl, curve: _curve);
    if (_isAnimated && _ownsCtrl) {
      widget.style.loop
          ? _ctrl.repeat()
          : _ctrl.forward().then((_) => widget.onAnimationComplete?.call());
    }
  }

  Curve get _curve => switch (widget.variant) {
        KruiGradientBorderVariant.breathing => Curves.easeInOut,
        KruiGradientBorderVariant.shimmer => Curves.easeInOut,
        _ => Curves.linear,
      };

  @override
  void didUpdateWidget(KruiGradientBorder old) {
    super.didUpdateWidget(old);
    if (old.style.animationDuration != widget.style.animationDuration &&
        _ownsCtrl) {
      _ctrl.duration = widget.style.animationDuration;
    }
    if (old.variant != widget.variant) {
      _anim = CurvedAnimation(parent: _ctrl, curve: _curve);
      if (_ownsCtrl) {
        if (_isAnimated) {
          _ctrl.reset();
          widget.style.loop ? _ctrl.repeat() : _ctrl.forward();
        } else {
          _ctrl.stop();
          _ctrl.reset();
        }
      }
    }
  }

  @override
  void dispose() {
    if (_ownsCtrl) _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAnimated) {
      return CustomPaint(
        painter: _GradientBorderPainter(
          style: widget.style,
          variant: widget.variant,
          progress: 0.0,
        ),
        child: _padded(widget.child),
      );
    }

    // AnimatedBuilder passes child through unmodified — child never repaints.
    return AnimatedBuilder(
      animation: _anim,
      child: widget.child,
      builder: (_, child) => CustomPaint(
        painter: _GradientBorderPainter(
          style: widget.style,
          variant: widget.variant,
          progress: _anim.value,
        ),
        child: _padded(child!),
      ),
    );
  }

  Widget _padded(Widget child) {
    final bw = widget.style.borderWidth;
    final glow = widget.style.glowSpread;
    final p = widget.style.padding ??
        EdgeInsets.all(bw +
            (widget.variant == KruiGradientBorderVariant.glow
                ? glow * 0.4
                : 0.0));
    return Padding(padding: p, child: child);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 5 — Painter (private)
// ─────────────────────────────────────────────────────────────────────────────

class _GradientBorderPainter extends CustomPainter {
  const _GradientBorderPainter({
    required this.style,
    required this.variant,
    required this.progress,
  });

  final KruiGradientBorderStyle style;
  final KruiGradientBorderVariant variant;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    assert(style.colors.length >= 2,
        'KRUIGradientBorderStyle: colors must have >= 2 entries.');
    switch (variant) {
      case KruiGradientBorderVariant.staticGradient:
        _static(canvas, size);
      case KruiGradientBorderVariant.rotating:
        _rotating(canvas, size);
      case KruiGradientBorderVariant.shimmer:
        _shimmer(canvas, size);
      case KruiGradientBorderVariant.breathing:
        _breathing(canvas, size);
      case KruiGradientBorderVariant.underline:
        _underline(canvas, size);
      case KruiGradientBorderVariant.dashed:
        _dashed(canvas, size);
      case KruiGradientBorderVariant.glow:
        _glow(canvas, size);
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  RRect _rr(Size s) => RRect.fromRectAndCorners(
        Rect.fromLTWH(style.borderWidth / 2, style.borderWidth / 2,
            s.width - style.borderWidth, s.height - style.borderWidth),
        topLeft: style.borderRadius.topLeft,
        topRight: style.borderRadius.topRight,
        bottomLeft: style.borderRadius.bottomLeft,
        bottomRight: style.borderRadius.bottomRight,
      );

  Paint _lp(Size s, {double opacity = 1.0}) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = style.borderWidth
    ..strokeCap = StrokeCap.round
    ..shader = LinearGradient(
      colors: style.colors
          .map((c) => c.withValues(alpha: (c.a * opacity).clamp(0.0, 1.0)))
          .toList(),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, s.width, s.height));

  // ── Variant painters ────────────────────────────────────────────────────

  void _static(Canvas c, Size s) => c.drawRRect(_rr(s), _lp(s));

  void _rotating(Canvas c, Size s) {
    c.drawRRect(
      _rr(s),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = style.borderWidth
        ..shader = SweepGradient(
          colors: style.colors,
          startAngle: 0,
          endAngle: math.pi * 2,
          transform: GradientRotation(progress * math.pi * 2),
          tileMode: TileMode.repeated,
        ).createShader(Rect.fromCenter(
          center: Offset(s.width / 2, s.height / 2),
          width: s.width,
          height: s.height,
        )),
    );
  }

  void _shimmer(Canvas c, Size s) {
    final shift = progress * (s.width + s.height);
    final stops = List<double>.generate(
      style.colors.length,
      (i) => style.colors.length < 2 ? 0.0 : i / (style.colors.length - 1),
    );
    c.drawRRect(
      _rr(s),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = style.borderWidth
        ..shader = LinearGradient(
          colors: style.colors,
          stops: stops,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: _SlideGradientTransform(shift),
          tileMode: TileMode.mirror,
        ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
    );
  }

  void _breathing(Canvas c, Size s) {
    final opacity = style.minOpacity +
        (style.maxOpacity - style.minOpacity) *
            (0.5 + 0.5 * math.sin(progress * math.pi * 2));

    if (style.glowSpread > 0) {
      c.drawRRect(
        _rr(s),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = style.borderWidth + style.glowSpread * 2
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, style.glowSpread)
          ..shader = LinearGradient(
            colors: style.colors
                .map((c) => c.withValues(alpha: (opacity * 0.35).clamp(0, 1)))
                .toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, s.width, s.height)),
      );
    }
    c.drawRRect(_rr(s), _lp(s, opacity: opacity));
  }

  void _underline(Canvas c, Size s) {
    final y = s.height - style.borderWidth / 2;
    c.drawLine(
      Offset(0, y),
      Offset(s.width, y),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = style.borderWidth
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          colors: style.colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(Rect.fromLTWH(0, s.height, s.width, 0)),
    );
  }

  void _dashed(Canvas c, Size s) {
    final path = Path()..addRRect(_rr(s));
    final paint = _lp(s);
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        c.drawPath(
            m.extractPath(d, (d + style.dashLength).clamp(0, m.length)), paint);
        d += style.dashLength + style.gapLength;
      }
    }
  }

  void _glow(Canvas c, Size s) {
    final gc = style.glowColor ?? style.colors.first;
    // Layer 1 — wide outer halo
    c.drawRRect(
        _rr(s),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = style.borderWidth + style.glowSpread * 2
          ..color = gc.withValues(alpha: 0.2)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, style.glowSpread * 2));
    // Layer 2 — mid halo
    c.drawRRect(
        _rr(s),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = style.borderWidth + style.glowSpread
          ..color = gc.withValues(alpha: 0.45)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, style.glowSpread));
    // Layer 3 — crisp gradient on top
    c.drawRRect(_rr(s), _lp(s));
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter old) =>
      old.progress != progress || old.variant != variant || old.style != style;
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION 6 — GradientTransform helper (private)
// ─────────────────────────────────────────────────────────────────────────────

class _SlideGradientTransform extends GradientTransform {
  const _SlideGradientTransform(this.slide);
  final double slide;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(slide, 0, 0);
}
