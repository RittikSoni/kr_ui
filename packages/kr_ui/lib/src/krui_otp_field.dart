import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// A highly customizable and robust OTP/PIN input field with advanced animations.
///
/// Features:
/// - Auto-focus management
/// - Backspace support to move focus back
/// - Smart paste support (splits code into fields)
/// - Shake animation on error
/// - Haptic feedback on interactions
/// - SMS Auto-fill support
class KruiOtpField extends StatefulWidget {
  final int length;
  final double fieldWidth;
  final double fieldHeight;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final TextStyle? style;
  final KruiOtpDecoration decoration;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? cursorColor;
  final bool hasError;
  final bool hasSuccess;
  final bool hapticFeedback;
  final KruiOtpController? controller;

  const KruiOtpField({
    super.key,
    this.length = 4,
    this.fieldWidth = 50,
    this.fieldHeight = 60,
    this.onChanged,
    this.onCompleted,
    this.style,
    this.decoration = const KruiOtpDecoration(),
    this.obscureText = false,
    this.keyboardType = TextInputType.number,
    this.activeColor,
    this.inactiveColor,
    this.cursorColor,
    this.hasError = false,
    this.hasSuccess = false,
    this.hapticFeedback = true,
    this.controller,
  });

  @override
  State<KruiOtpField> createState() => _KruiOtpFieldState();
}

class _KruiOtpFieldState extends State<KruiOtpField>
    with SingleTickerProviderStateMixin {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String> _otpValues;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _otpValues = List.filled(widget.length, "");

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    // Attach controller if provided
    widget.controller?._attach(this);

    // Add listeners to detect backspace and handle focus
    for (int i = 0; i < widget.length; i++) {
      _focusNodes[i].onKeyEvent = (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace) {
          _handleBackspace(i);
        }
        return KeyEventResult.ignored;
      };
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _controllers[i].selection = TextSelection.fromPosition(
            TextPosition(offset: _controllers[i].text.length),
          );
        }
        setState(() {}); // Rebuild to update border color
      });
    }
  }

  @override
  void didUpdateWidget(KruiOtpField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) {
      _shake();
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }
  }

  void _shake() {
    _shakeController.forward(from: 0.0);
    if (widget.hapticFeedback) {
      HapticFeedback.vibrate();
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  void _onTextChanged(int index, String value) {
    if (value.isEmpty) {
      _otpValues[index] = "";
      widget.onChanged?.call(_getOtp());
      return;
    }

    // Handle paste or multi-character input
    if (value.length > 1) {
      _handleDistributedInput(index, value);
      return;
    }

    // Enforce numeric only if specified. If not numeric, allow anything.
    if (widget.keyboardType == TextInputType.number &&
        !RegExp(r'[0-9]').hasMatch(value)) {
      _controllers[index].text = _otpValues[index]; // Revert
      return;
    }

    _otpValues[index] = value;
    _controllers[index].text = value; // Update text explicitly to ensure sync
    final otp = _getOtp();
    widget.onChanged?.call(otp);

    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
      if (widget.hapticFeedback) {
        HapticFeedback.lightImpact();
      }
    }

    if (otp.length == widget.length) {
      widget.onCompleted?.call(otp);
      if (widget.hapticFeedback) {
        HapticFeedback.mediumImpact();
      }
    }
  }

  void _handleBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      if (widget.hapticFeedback) {
        HapticFeedback.lightImpact();
      }
    }
  }

  void _handleDistributedInput(int startIndex, String value) {
    // Only extract digits if numeric keyboard, otherwise allow all
    final cleanValue = widget.keyboardType == TextInputType.number
        ? value.replaceAll(RegExp(r'[^0-9]'), '')
        : value;

    if (cleanValue.isEmpty) {
      _controllers[startIndex].text =
          _otpValues[startIndex]; // Revert current controller
      return;
    }

    for (int i = 0; i < cleanValue.length; i++) {
      int targetIndex = startIndex + i;
      if (targetIndex < widget.length) {
        _controllers[targetIndex].text = cleanValue[i];
        _otpValues[targetIndex] = cleanValue[i];
      }
    }

    // Ensure state sync
    _controllers[startIndex].text = _otpValues[startIndex];

    final otp = _getOtp();
    widget.onChanged?.call(otp);

    // Focus management after distributed input
    int nextFocusIndex = startIndex + cleanValue.length;
    if (nextFocusIndex < widget.length) {
      _focusNodes[nextFocusIndex].requestFocus();
    } else {
      _focusNodes[widget.length - 1].requestFocus();
      if (otp.length == widget.length) {
        widget.onCompleted?.call(otp);
      }
    }

    if (widget.hapticFeedback) {
      HapticFeedback.mediumImpact();
    }
  }

  String _getOtp() {
    return _otpValues.join();
  }

  void _syncState() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final double offset = math.sin(_shakeAnimation.value * math.pi * 4) *
            (10.0 - _shakeAnimation.value);
        return Transform.translate(offset: Offset(offset, 0), child: child);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.fieldWidth,
            height: widget.fieldHeight,
            margin: EdgeInsets.symmetric(horizontal: widget.decoration.gap / 2),
            decoration: widget.decoration.toBoxDecoration(
              isActive: _focusNodes[index].hasFocus,
              hasValue: _otpValues[index].isNotEmpty,
              hasSuccess: widget.hasSuccess,
              hasError: widget.hasError,
              defaultActiveColor:
                  widget.activeColor ?? Theme.of(context).primaryColor,
              defaultInactiveColor:
                  widget.inactiveColor ?? Colors.grey.withValues(alpha: 0.3),
              defaultErrorColor: Colors.redAccent,
              defaultSuccessColor: Colors.greenAccent,
            ),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              autofillHints: const [AutofillHints.oneTimeCode],
              style: widget.style ??
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              cursorColor: widget.cursorColor ?? Theme.of(context).primaryColor,
              decoration: const InputDecoration(
                counterText: "",
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => _onTextChanged(index, value),
            ),
          );
        }),
      ),
    );
  }
}

/// Decoration configuration for [KruiOtpField].
class KruiOtpDecoration {
  final double borderRadius;
  final double borderWidth;
  final double activeBorderWidth;
  final double gap;
  final KruiOtpShape shape;
  final Color? backgroundColor;
  final bool showShadow;

  // Custom colors
  final Color? activeBorderColor;
  final Color? inactiveBorderColor;
  final Color? errorBorderColor;
  final Color? successBorderColor;
  final Color? filledBorderColor;
  final Color? activeShadowColor;
  final Color? errorShadowColor;
  final Color? successShadowColor;

  const KruiOtpDecoration({
    this.borderRadius = 8,
    this.borderWidth = 1,
    this.activeBorderWidth = 2,
    this.gap = 10,
    this.shape = KruiOtpShape.box,
    this.backgroundColor,
    this.showShadow = true,
    this.activeBorderColor,
    this.inactiveBorderColor,
    this.errorBorderColor,
    this.successBorderColor,
    this.filledBorderColor,
    this.activeShadowColor,
    this.errorShadowColor,
    this.successShadowColor,
  });

  BoxDecoration toBoxDecoration({
    required bool isActive,
    required bool hasValue,
    required bool hasError,
    required bool hasSuccess,
    required Color defaultActiveColor,
    required Color defaultInactiveColor,
    required Color defaultErrorColor,
    required Color defaultSuccessColor,
  }) {
    // Resolve colors with precedence: Custom properties > Component overrides > Theme defaults
    final Color activeCol = activeBorderColor ?? defaultActiveColor;
    final Color inactiveCol = inactiveBorderColor ?? defaultInactiveColor;
    final Color errorCol = errorBorderColor ?? defaultErrorColor;
    final Color successCol = successBorderColor ?? defaultSuccessColor;
    final Color filledCol =
        filledBorderColor ?? activeCol.withValues(alpha: 0.5);

    Color borderColor = hasError
        ? errorCol
        : (hasSuccess
            ? successCol
            : (isActive ? activeCol : (hasValue ? filledCol : inactiveCol)));

    double currentBorderWidth =
        isActive || hasError || hasSuccess ? activeBorderWidth : borderWidth;

    return BoxDecoration(
      color: backgroundColor ?? Colors.transparent,
      border: shape == KruiOtpShape.box
          ? Border.all(color: borderColor, width: currentBorderWidth)
          : Border(
              bottom: BorderSide(color: borderColor, width: currentBorderWidth),
            ),
      borderRadius: shape == KruiOtpShape.box
          ? BorderRadius.circular(borderRadius)
          : null,
      boxShadow: showShadow && (isActive || hasError || hasSuccess)
          ? [
              BoxShadow(
                color: (hasError
                        ? (errorShadowColor ?? errorCol)
                        : (hasSuccess
                            ? (successShadowColor ?? successCol)
                            : (activeShadowColor ?? activeCol)))
                    .withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ]
          : null,
    );
  }
}

enum KruiOtpShape { box, underline }

/// A controller for [KruiOtpField] to programmatically manage the OTP input.
class KruiOtpController {
  final Set<_KruiOtpFieldState> _states = {};

  void _attach(_KruiOtpFieldState state) {
    _states.add(state);
  }

  void _detach(_KruiOtpFieldState state) {
    _states.remove(state);
  }

  /// Returns the current OTP value of the first attached field.
  String get otp => _states.isNotEmpty ? _states.first._getOtp() : "";

  /// Clears all fields in all attached OTP inputs.
  void clear() {
    for (var state in _states) {
      for (var controller in state._controllers) {
        controller.clear();
      }
      for (int i = 0; i < state._otpValues.length; i++) {
        state._otpValues[i] = "";
      }
      state._focusNodes[0].requestFocus();
      state._syncState();
    }
  }

  /// Sets the OTP value programmatically for all attached fields.
  void setOtp(String value) {
    for (var state in _states) {
      state._handleDistributedInput(0, value);
    }
  }
}
