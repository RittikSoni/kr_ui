import 'package:flutter/material.dart';

import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

final kruiOtpFieldInfo = ComponentInfo(
  id: 'otp-field',
  name: 'KruiOtpField',
  displayName: 'OTP Field',
  description:
      'A customizable OTP (One-Time Password) input field supporting single and multi-node input layouts with built-in animations, auto-focus, paste support, and various styles (glassy, outlined, filled).',
  videoUrl: 'https://youtube.com/shorts/bC3D09cUfKk?si=6uccW1NBgtT4iKUY',
  category: 'Forms',
  icon: Icons.password,
  properties: [
    const PropertyInfo(
      name: 'length',
      type: 'int',
      defaultValue: '4',
      description: 'Number of OTP digits',
    ),
    const PropertyInfo(
      name: 'controller',
      type: 'KruiOtpController?',
      defaultValue: 'null',
      description: 'Controller to manage OTP state (clear, set value)',
    ),
    const PropertyInfo(
      name: 'onChanged',
      type: 'ValueChanged<String>?',
      defaultValue: 'null',
      description: 'Callback when value changes',
    ),
    const PropertyInfo(
      name: 'onCompleted',
      type: 'ValueChanged<String>?',
      defaultValue: 'null',
      description: 'Callback when all digits are entered',
    ),
    const PropertyInfo(
      name: 'obscureText',
      type: 'bool',
      defaultValue: 'false',
      description: 'Whether to hide the input (e.g. for passwords)',
    ),
    const PropertyInfo(
      name: 'keyboardType',
      type: 'TextInputType',
      defaultValue: 'number',
      description: 'Type of keyboard to display',
    ),
    const PropertyInfo(
      name: 'hasError',
      type: 'bool',
      defaultValue: 'false',
      description: 'Shows error state styling',
    ),
    const PropertyInfo(
      name: 'hasSuccess',
      type: 'bool',
      defaultValue: 'false',
      description: 'Shows success state styling',
    ),
    const PropertyInfo(
      name: 'decoration',
      type: 'KruiOtpDecoration',
      defaultValue: 'default',
      description: 'Custom styling for the OTP fields',
    ),
  ],
  basicExample: '''KruiOtpField(
  length: 4,
  onCompleted: (pin) {
    print("Completed: \$pin");
  },
)''',
  advancedExample: '''final KruiOtpController _controller = KruiOtpController();

KruiOtpField(
  length: 6,
  controller: _controller,
  obscureText: true,
  decoration: KruiOtpDecoration(
    borderRadius: 12,
    activeBorderColor: Colors.blueAccent,
    activeShadowColor: Colors.blueAccent,
    showShadow: true,
  ),
  onCompleted: (pin) {
    if (pin != "123456") {
      // Handle error state externally
    }
  },
)''',
  presets: [
    PresetInfo(
      name: 'Modern Glassmorphism',
      description: 'Subtle transparency & interactive border glows',
      code: '''KruiOtpField(
  length: 4,
  decoration: KruiOtpDecoration(
    borderRadius: 16,
    backgroundColor: Colors.white.withValues(alpha:  alpha: 0.05),
    activeBorderColor: Colors.blueAccent,
    activeShadowColor: Colors.blueAccent,
    inactiveBorderColor: Colors.white.withValues(alpha:  alpha: 0.1),
    showShadow: true,
    activeBorderWidth: 2,
  ),
  style: const TextStyle(color: Colors.white, fontSize: 24),
  cursorColor: Colors.blueAccent,
)''',
      builder: () => KruiOtpField(
        length: 4,
        decoration: KruiOtpDecoration(
          borderRadius: 16,
          backgroundColor: Colors.white.withValues(alpha: 0.05),
          activeBorderColor: Colors.blueAccent,
          activeShadowColor: Colors.blueAccent,
          inactiveBorderColor: Colors.white.withValues(alpha: 0.1),
          showShadow: true,
          activeBorderWidth: 2,
        ),
        style: const TextStyle(color: Colors.white, fontSize: 24),
        cursorColor: Colors.blueAccent,
      ),
    ),
    PresetInfo(
      name: 'Neon Pulse',
      description: 'Vibrant colors for high-conversion forms',
      code: '''KruiOtpField(
  length: 4,
  decoration: const KruiOtpDecoration(
    shape: KruiOtpShape.box,
    borderRadius: 12,
    activeBorderWidth: 3,
    activeBorderColor: Color(0xFF22D3EE),
    activeShadowColor: Color(0xFF22D3EE),
    inactiveBorderColor: Color(0xFF334155),
    filledBorderColor: Color(0xFF0EA5E9),
    showShadow: true,
  ),
  style: TextStyle(
    color: Color(0xFF22D3EE),
    fontWeight: FontWeight.bold,
    fontSize: 24,
  ),
  cursorColor: const Color(0xFF22D3EE),
)''',
      builder: () => KruiOtpField(
        length: 4,
        decoration: const KruiOtpDecoration(
          shape: KruiOtpShape.box,
          borderRadius: 12,
          activeBorderWidth: 3,
          activeBorderColor: Color(0xFF22D3EE),
          activeShadowColor: Color(0xFF22D3EE),
          inactiveBorderColor: Color(0xFF334155),
          filledBorderColor: Color(0xFF0EA5E9),
          showShadow: true,
        ),
        style: const TextStyle(
          color: Color(0xFF22D3EE),
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        cursorColor: const Color(0xFF22D3EE),
      ),
    ),
    PresetInfo(
      name: 'Minimalist Underline',
      description: 'Clean, professional, and elegant',
      code: '''KruiOtpField(
  length: 4,
  decoration: const KruiOtpDecoration(
    shape: KruiOtpShape.underline,
    activeBorderColor: Colors.white,
    inactiveBorderColor: Color(0xFF475569),
    activeBorderWidth: 3,
    showShadow: false,
  ),
  style: const TextStyle(color: Colors.white, fontSize: 24),
  cursorColor: Colors.white,
)''',
      builder: () => KruiOtpField(
        length: 4,
        decoration: const KruiOtpDecoration(
          shape: KruiOtpShape.underline,
          activeBorderColor: Colors.white,
          inactiveBorderColor: Color(0xFF475569),
          activeBorderWidth: 3,
          showShadow: false,
        ),
        style: const TextStyle(color: Colors.white, fontSize: 24),
        cursorColor: Colors.white,
      ),
    ),
    PresetInfo(
      name: 'Obscured Security',
      description: 'Hidden characters for sensitive transactions',
      code: '''KruiOtpField(
  length: 4,
  obscureText: true,
  decoration: KruiOtpDecoration(
    activeBorderColor: Colors.amber,
    showShadow: true,
  ),
  cursorColor: Colors.amber,
)''',
      builder: () => KruiOtpField(
        length: 4,
        obscureText: true,
        decoration: const KruiOtpDecoration(
          activeBorderColor: Colors.amber,
          showShadow: true,
        ),
        cursorColor: Colors.amber,
      ),
    ),
  ],
  demoBuilder: () => const _KruiOtpFieldDemo(),
);

class _KruiOtpFieldDemo extends StatefulWidget {
  const _KruiOtpFieldDemo();

  @override
  State<_KruiOtpFieldDemo> createState() => _KruiOtpFieldDemoState();
}

class _KruiOtpFieldDemoState extends State<_KruiOtpFieldDemo> {
  final KruiOtpController _controller = KruiOtpController();
  bool _hasError = false;
  bool _hasSuccess = false;
  bool _isObscured = false;

  void _triggerError() {
    setState(() => _hasError = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _hasError = false);
    });
  }

  void _triggerSuccess() {
    setState(() => _hasSuccess = true);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _hasSuccess = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final bgColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.05);
    final inactiveBorder = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.1);

    return Column(
      children: [
        KruiOtpField(
          length: 4,
          controller: _controller,
          obscureText: _isObscured,
          decoration: KruiOtpDecoration(
            borderRadius: 16,
            backgroundColor: bgColor,
            activeBorderColor: _hasError
                ? Colors.redAccent
                : _hasSuccess
                    ? Colors.greenAccent
                    : Colors.blueAccent,
            activeShadowColor: _hasError
                ? Colors.redAccent
                : _hasSuccess
                    ? Colors.greenAccent
                    : Colors.blueAccent,
            inactiveBorderColor: inactiveBorder,
            showShadow: true,
            activeBorderWidth: 2,
          ),
          style: TextStyle(color: textColor, fontSize: 24),
          cursorColor: Colors.blueAccent,
          hasError: _hasError,
          hasSuccess: _hasSuccess,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: _isObscured,
              onChanged: (v) => setState(() => _isObscured = v ?? false),
            ),
            GestureDetector(
                onTap: () => setState(() => _isObscured = !_isObscured),
                child: const Text("Obscure Text")),
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _triggerError,
              icon: const Icon(Icons.error_outline),
              label: const Text("Error"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                foregroundColor: Colors.redAccent,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _triggerSuccess,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text("Success"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.withValues(alpha: 0.1),
                foregroundColor: Colors.greenAccent,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _controller.clear(),
              icon: const Icon(Icons.refresh),
              label: const Text("Reset"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
