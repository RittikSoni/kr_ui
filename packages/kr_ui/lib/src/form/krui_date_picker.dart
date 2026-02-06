import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Trigger button that opens the platform date picker.
///
/// Use [value] for the initial/selected date and [onDateChanged] to get the picked date.
/// [firstDate], [lastDate] constrain the picker range.
class KruiDatePicker extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime> onDateChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool enabled;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final KruiDateFormat? format;

  const KruiDatePicker({
    super.key,
    required this.onDateChanged,
    this.value,
    this.firstDate,
    this.lastDate,
    this.label,
    this.hint,
    this.errorText,
    this.enabled = true,
    this.padding,
    this.borderRadius,
    this.format,
  });

  static String _formatDate(DateTime d, KruiDateFormat? f) {
    if (f != null) return f.format(d);
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _openPicker(BuildContext context) async {
    if (!enabled) return;
    HapticFeedback.lightImpact();
    final theme = Theme.of(context);
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) => Theme(data: theme, child: child!),
    );
    if (picked != null) onDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final radius = borderRadius ?? BorderRadius.circular(12);
    final padding = this.padding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: hasError ? theme.colorScheme.error : null,
            ),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: () => _openPicker(context),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade50,
              borderRadius: radius,
              border: Border.all(
                color: hasError
                    ? theme.colorScheme.error
                    : (isDark ? Colors.white24 : Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 20, color: theme.hintColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value != null
                        ? _formatDate(value!, format)
                        : (hint ?? 'Select date'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: value != null ? null : theme.hintColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.error),
          ),
        ],
      ],
    );
  }
}

/// Simple date format helper for display (no intl dependency).
class KruiDateFormat {
  final String pattern;
  const KruiDateFormat(this.pattern);
  String format(DateTime d) {
    return pattern
        .replaceAll('yyyy', d.year.toString())
        .replaceAll('MM', d.month.toString().padLeft(2, '0'))
        .replaceAll('dd', d.day.toString().padLeft(2, '0'));
  }
}
