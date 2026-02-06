import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Trigger button that opens the platform time picker.
class KruiTimePicker extends StatelessWidget {
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool enabled;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const KruiTimePicker({
    super.key,
    required this.onTimeChanged,
    this.value,
    this.label,
    this.hint,
    this.errorText,
    this.enabled = true,
    this.padding,
    this.borderRadius,
  });

  static String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  Future<void> _openPicker(BuildContext context) async {
    if (!enabled) return;
    HapticFeedback.lightImpact();
    final theme = Theme.of(context);
    final picked = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
      builder: (context, child) => Theme(data: theme, child: child!),
    );
    if (picked != null) onTimeChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final radius = borderRadius ?? BorderRadius.circular(12);
    final padding = this.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
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
                Icon(Icons.schedule_outlined, size: 20, color: theme.hintColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value != null ? _formatTime(value!) : (hint ?? 'Select time'),
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
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
          ),
        ],
      ],
    );
  }
}
