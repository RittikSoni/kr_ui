import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiCountdownInfo = ComponentInfo(
  id: 'countdown',
  name: 'KruiCountdown',
  displayName: 'Countdown',
  description:
      'A versatile countdown timer component for OTP resends, fitness workouts, event launches, and ecommerce deals. Supports multiple visual variants including glassmorphism and circular progress.',
  videoUrl: 'https://youtube.com/shorts/y0oLXe8-n-Y',
  category: 'Utilities',
  icon: Icons.timer_outlined,
  properties: [
    const PropertyInfo(
      name: 'duration',
      type: 'Duration',
      defaultValue: 'required',
      description: 'Total countdown duration',
    ),
    const PropertyInfo(
      name: 'controller',
      type: 'KruiCountdownController',
      defaultValue: 'required',
      description: 'Controller to start/pause/reset and observe ticks',
    ),
    const PropertyInfo(
      name: 'variant',
      type: 'KruiCountdownVariant',
      defaultValue: 'simple',
      description: 'Visual style (simple, liquidGlass, circularProgress, etc.)',
    ),
    const PropertyInfo(
      name: 'format',
      type: 'KruiCountdownFormat',
      defaultValue: 'mmSs',
      description: 'Time display format (seconds, mmSs, hhMmSs, days, etc.)',
    ),
    const PropertyInfo(
      name: 'label',
      type: 'String?',
      defaultValue: 'null',
      description: 'Optional label displayed below or beside the timer',
    ),
    const PropertyInfo(
      name: 'actionLabel',
      type: 'String?',
      defaultValue: 'null',
      description: 'Label for the action button shown after completion',
    ),
    const PropertyInfo(
      name: 'onAction',
      type: 'VoidCallback?',
      defaultValue: 'null',
      description: 'Callback when the action button is tapped',
    ),
    const PropertyInfo(
      name: 'size',
      type: 'double',
      defaultValue: '56.0',
      description: 'Base size/diameter of the widget',
    ),
  ],
  basicExample: '''KruiCountdown(
  duration: const Duration(minutes: 2),
  controller: KruiCountdownController(
    initialDuration: const Duration(minutes: 2),
  ),
)''',
  advancedExample: '''final _controller = KruiCountdownController(
  initialDuration: const Duration(seconds: 30),
  hapticOnComplete: true,
);

KruiCountdown.circularProgress(
  duration: const Duration(seconds: 30),
  controller: _controller,
  label: "Resend in",
  actionLabel: "Resend Code",
  onAction: () => _controller.restart(),
  primaryColor: Colors.blueAccent,
)''',
  presets: [
    PresetInfo(
      name: 'OTP Resend',
      description: 'Standard OTP verification pattern with a progress ring',
      code: '''KruiCountdown.otpResend(
  duration: const Duration(seconds: 60),
  controller: KruiCountdownController(
    initialDuration: const Duration(seconds: 60),
  ),
  onResend: () => print("Resending OTP..."),
)''',
      builder: () => const _KruiCountdownWrapper(
        variant: 'otp',
      ),
    ),
    PresetInfo(
      name: 'Fitness Pulse',
      description: 'Bold fitness-style timer with a pulsing animation',
      code: '''KruiCountdown.fitness(
  duration: const Duration(seconds: 45),
  controller: KruiCountdownController(
    initialDuration: const Duration(seconds: 45),
  ),
  label: "REST",
  primaryColor: Colors.greenAccent,
)''',
      builder: () => const _KruiCountdownWrapper(
        variant: 'fitness',
      ),
    ),
    PresetInfo(
      name: 'Event Launch',
      description: 'Segmented countdown for product launches or events',
      code: '''KruiCountdown.segments(
  duration: const Duration(days: 2, hours: 5),
  controller: KruiCountdownController(
    initialDuration: const Duration(days: 2, hours: 5),
  ),
  label: "LAUNCHING SOON",
)''',
      builder: () => const _KruiCountdownWrapper(
        variant: 'segments',
      ),
    ),
    PresetInfo(
      name: 'Ecommerce Flash Deal',
      description: 'High-visibility deal timer with glassmorphism',
      code: '''KruiCountdown.liquidGlass(
  duration: const Duration(hours: 4),
  controller: KruiCountdownController(
    initialDuration: const Duration(hours: 4),
  ),
  label: "FLASH SALE ENDS",
  primaryColor: Colors.orangeAccent,
  format: KruiCountdownFormat.hhMmSs,
)''',
      builder: () => const _KruiCountdownWrapper(
        variant: 'ecommerce',
      ),
    ),
    PresetInfo(
      name: 'Custom Formatter',
      description:
          'Fully custom display string using the formatBuilder property',
      code: '''KruiCountdown.simple(
  duration: const Duration(minutes: 5),
  controller: KruiCountdownController(initialDuration: const Duration(minutes: 5)),
  formatBuilder: (remaining) {
    if (remaining.inSeconds <= 0) return "TIME'S UP!";
    final m = remaining.inMinutes;
    final s = remaining.inSeconds % 60;
    return "Hurry! Ends in \${m}m \${s}s";
  },
  primaryColor: Colors.redAccent,
)''',
      builder: () => const _KruiCountdownWrapper(
        variant: 'custom',
      ),
    ),
    PresetInfo(
      name: 'Minimal Inline',
      description: 'Compact text-only countdown for subtle UIs',
      code: '''KruiCountdown.minimal(
  duration: const Duration(minutes: 5),
  controller: KruiCountdownController(
    initialDuration: const Duration(minutes: 5),
  ),
)''',
      builder: () => const _KruiCountdownWrapper(
        variant: 'minimal',
      ),
    ),
  ],
  demoBuilder: () => const _KruiCountdownDemo(),
);

class _KruiCountdownWrapper extends StatefulWidget {
  final String variant;
  const _KruiCountdownWrapper({required this.variant});

  @override
  State<_KruiCountdownWrapper> createState() => _KruiCountdownWrapperState();
}

class _KruiCountdownWrapperState extends State<_KruiCountdownWrapper> {
  late KruiCountdownController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    final duration = switch (widget.variant) {
      'otp' => const Duration(seconds: 60),
      'fitness' => const Duration(seconds: 45),
      'segments' => const Duration(days: 1, hours: 12, minutes: 30),
      'ecommerce' => const Duration(hours: 3),
      'custom' => const Duration(minutes: 5),
      _ => const Duration(minutes: 5),
    };
    _controller = KruiCountdownController(initialDuration: duration);
  }

  @override
  void didUpdateWidget(_KruiCountdownWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.variant != widget.variant) {
      _controller.dispose();
      _initController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: switch (widget.variant) {
        'otp' => KruiCountdown.otpResend(
            duration: const Duration(seconds: 60),
            controller: _controller,
            onResend: () => _controller.restart(),
          ),
        'fitness' => KruiCountdown.fitness(
            duration: const Duration(seconds: 45),
            controller: _controller,
            label: "REST",
            primaryColor: Colors.greenAccent,
          ),
        'segments' => KruiCountdown.segments(
            duration: const Duration(days: 1, hours: 12, minutes: 30),
            controller: _controller,
            label: "LAUNCHING SOON",
            size: 48,
          ),
        'ecommerce' => KruiCountdown.liquidGlass(
            duration: const Duration(hours: 3),
            controller: _controller,
            label: "FLASH SALE ENDS",
            primaryColor: Colors.orangeAccent,
            format: KruiCountdownFormat.hhMmSs,
          ),
        'custom' => KruiCountdown.simple(
            duration: const Duration(minutes: 5),
            controller: _controller,
            formatBuilder: (remaining) {
              if (remaining.inSeconds <= 0) return "TIME'S UP!";
              final m = remaining.inMinutes;
              final s = remaining.inSeconds % 60;
              return "Hurry! Ends in ${m}m ${s}s";
            },
            primaryColor: Colors.redAccent,
          ),
        _ => KruiCountdown.minimal(
            duration: const Duration(minutes: 5),
            controller: _controller,
          ),
      },
    );
  }
}

class _KruiCountdownDemo extends StatefulWidget {
  const _KruiCountdownDemo();

  @override
  State<_KruiCountdownDemo> createState() => _KruiCountdownDemoState();
}

class _KruiCountdownDemoState extends State<_KruiCountdownDemo> {
  late KruiCountdownController _controller;

  @override
  void initState() {
    super.initState();
    _controller = KruiCountdownController(
      initialDuration: const Duration(minutes: 2),
      hapticOnComplete: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        KruiCountdown.liquidGlass(
          duration: _controller.initialDuration,
          controller: _controller,
          label: "COUNTDOWN",
          primaryColor: Colors.blueAccent,
          onComplete: () =>
              setState(() {}), // Refresh UI on completion for label/color
          onAction: () => _controller.restart(), // Example action
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              onPressed: () {
                if (_controller.isRunning) {
                  _controller.pause();
                } else {
                  _controller.start();
                }
                setState(() {});
              },
              icon:
                  Icon(_controller.isRunning ? Icons.pause : Icons.play_arrow),
              tooltip: _controller.isRunning ? 'Pause' : 'Start',
            ),
            const SizedBox(width: 16),
            IconButton.filledTonal(
              onPressed: () {
                _controller.restart();
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
              tooltip: 'Restart',
            ),
          ],
        ),
      ],
    );
  }
}
