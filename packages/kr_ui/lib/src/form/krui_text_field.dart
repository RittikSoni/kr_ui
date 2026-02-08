import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'krui_form.dart';

/// Validation type for [KruiTextField].
enum KruiTextFieldValidation {
  none,
  email,
  password,
  url,
  number,
  phone,
  custom,
}

/// A modern text field with label, hint, error, and built-in validation.
///
/// Supports email, password, url, number, phone, and custom regex validation.
/// Use [validator] for custom validation; when [autovalidate] is true (default),
/// validation runs on change and the error is shown automatically.
/// Optional prefix/suffix, obscuring for password, and theme colors.
///
/// When used inside [KruiForm], set [name] or [id] to bind this field to the form
/// (value and errors come from [KruiFormController]). The **field key** is
/// [id] if set, otherwise [name]; use the same key in controller.initialValues
/// and controller.validate().
class KruiTextField extends StatefulWidget {
  /// Form field key when inside [KruiForm]. Links to controller.getValue(key),
  /// getTextController(key), getError(key). Same key as in initialValues/validate.
  final String? name;

  /// Alias for [name]. When set, used as the form field key (takes precedence over [name]).
  final String? id;
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final KruiTextFieldValidation validation;

  /// Custom validator. When set, [autovalidate] controls whether it runs on every change.
  final String? Function(String?)? validator;

  /// When true (default) and [validator] is set, validation runs on every change and error is shown.
  final bool autovalidate;
  final RegExp? customPattern;
  final String? customPatternError;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Border? border;
  final Color? fillColor;
  final Color? focusBorderColor;
  final Color? errorBorderColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? helperTextColor;

  const KruiTextField({
    super.key,
    this.name,
    this.id,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.validation = KruiTextFieldValidation.none,
    this.validator,
    this.autovalidate = true,
    this.customPattern,
    this.customPatternError,
    this.padding,
    this.borderRadius,
    this.border,
    this.fillColor,
    this.focusBorderColor,
    this.errorBorderColor,
    this.labelColor,
    this.hintColor,
    this.textColor,
    this.helperTextColor,
  });

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp _urlRegex = RegExp(
    r'^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b',
  );
  static final RegExp _numberRegex = RegExp(r'^-?\d*\.?\d*$');
  static final RegExp _phoneRegex = RegExp(r'^[\d\s\-\+\(\)]{10,}$');

  /// Validates value against [validation] and optional [validator]. Returns error string or null.
  String? validate(String? value) {
    if (validator != null) {
      final custom = validator!(value);
      if (custom != null) return custom;
    }
    if (value == null || value.trim().isEmpty) return null;
    switch (validation) {
      case KruiTextFieldValidation.email:
        if (!_emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
        break;
      case KruiTextFieldValidation.url:
        if (!_urlRegex.hasMatch(value.trim())) return 'Enter a valid URL';
        break;
      case KruiTextFieldValidation.number:
        if (!_numberRegex.hasMatch(value)) return 'Enter a valid number';
        break;
      case KruiTextFieldValidation.phone:
        if (!_phoneRegex.hasMatch(value)) return 'Enter a valid phone number';
        break;
      case KruiTextFieldValidation.custom:
        if (customPattern != null && !customPattern!.hasMatch(value)) {
          return customPatternError ?? 'Invalid format';
        }
        break;
      case KruiTextFieldValidation.password:
      case KruiTextFieldValidation.none:
        break;
    }
    return null;
  }

  @override
  State<KruiTextField> createState() => _KruiTextFieldState();
}

class _KruiTextFieldState extends State<KruiTextField> {
  late TextEditingController _controller;
  bool _obscureText = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _obscureText = widget.obscureText;
    if (widget.autovalidate && widget.validator != null) {
      _validationError = widget.validate(_controller.text);
    }
  }

  @override
  void didUpdateWidget(KruiTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && widget.controller != _controller) {
      _controller = widget.controller!;
    }
    if (!widget.obscureText) _obscureText = false;
    if (widget.errorText != null && widget.errorText!.isNotEmpty) {
      _validationError = null;
    }
  }

  void _onChanged(String value) {
    if (widget.autovalidate && widget.validator != null) {
      setState(() => _validationError = widget.validate(value));
    }
    widget.onChanged?.call(value);
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final radius = widget.borderRadius ?? BorderRadius.circular(12);
    final padding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
    final formKey = widget.id ?? widget.name;
    final form = KruiForm.of(context);
    final formBound = formKey != null && form != null;
    final effectiveController = formBound
        ? form.getTextController(formKey)
        : (widget.controller ?? _controller);
    final effectiveErrorText =
        formBound ? form.getError(formKey) : widget.errorText;
    final hasError =
        (effectiveErrorText != null && effectiveErrorText.isNotEmpty) ||
            (_validationError != null && _validationError!.isNotEmpty);
    final errorMessage =
        (effectiveErrorText != null && effectiveErrorText.isNotEmpty)
            ? effectiveErrorText
            : _validationError;
    final focusColor = widget.focusBorderColor ?? theme.colorScheme.primary;
    final errorColor = widget.errorBorderColor ?? theme.colorScheme.error;
    final fill = widget.fillColor ??
        (isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade50);
    final labelColor = widget.labelColor ?? (hasError ? errorColor : null);
    final hintColor = widget.hintColor ?? theme.hintColor;
    final textColor = widget.textColor;
    final helperColor = widget.helperTextColor ?? theme.hintColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: effectiveController,
          onChanged: _onChanged,
          onSubmitted: widget.onSubmitted,
          obscureText: widget.obscureText && _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          style: TextStyle(
            color: textColor ?? (isDark ? Colors.white : Colors.black87),
          ),
          keyboardType: widget.keyboardType ??
              (widget.validation == KruiTextFieldValidation.email
                  ? TextInputType.emailAddress
                  : (widget.validation == KruiTextFieldValidation.url
                      ? TextInputType.url
                      : (widget.validation == KruiTextFieldValidation.number ||
                              widget.validation == KruiTextFieldValidation.phone
                          ? TextInputType.number
                          : null))),
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: hintColor),
            filled: true,
            fillColor: fill,
            contentPadding: padding,
            border: OutlineInputBorder(borderRadius: radius),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(
                  color: isDark ? Colors.white24 : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: focusColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: errorColor, width: 2),
            ),
            prefixIcon: widget.prefixIcon,
            prefix: widget.prefix,
            suffix: widget.suffix,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(_obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  )
                : widget.suffixIcon,
            counterText: widget.maxLength != null ? null : '',
          ),
        ),
        if (widget.helperText != null && !hasError) ...[
          const SizedBox(height: 6),
          Text(
            widget.helperText!,
            style: theme.textTheme.bodySmall?.copyWith(color: helperColor),
          ),
        ],
        if (hasError && errorMessage != null) ...[
          const SizedBox(height: 6),
          Text(
            errorMessage,
            style: theme.textTheme.bodySmall?.copyWith(color: errorColor),
          ),
        ],
      ],
    );
  }
}
