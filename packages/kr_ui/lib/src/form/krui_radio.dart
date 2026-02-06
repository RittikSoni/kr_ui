import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A single radio option for [KruiRadioGroup].
class KruiRadioOption<T> {
  final T value;
  final String label;
  final String? subtitle;

  const KruiRadioOption(
      {required this.value, required this.label, this.subtitle});
}

/// Modern radio group with clear selection state.
class KruiRadioGroup<T> extends StatelessWidget {
  final T? value;
  final List<KruiRadioOption<T>> options;
  final ValueChanged<T?> onChanged;
  final String? label;
  final bool enabled;
  final Axis direction;

  const KruiRadioGroup({
    super.key,
    required this.options,
    required this.onChanged,
    this.value,
    this.label,
    this.enabled = true,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Wrap the entire group layout in a RadioGroup.
    // This widget manages the group value and selection changes for its descendants.
    Widget w = RadioGroup<T>(
      groupValue: value,
      onChanged: onChanged,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: theme.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
          ],
          if (direction == Axis.vertical)
            ...options.map((o) => _RadioTile<T>(
                  option: o,
                  onChanged: enabled ? onChanged : null,
                ))
          else
            Wrap(
              spacing: 24,
              runSpacing: 8,
              children: options
                  .map((o) => _RadioTile<T>(
                        option: o,
                        onChanged: enabled ? onChanged : null,
                      ))
                  .toList(),
            ),
        ],
      ),
    );

    if (!enabled) {
      return IgnorePointer(
        child: Opacity(
          opacity: 0.5,
          child: w,
        ),
      );
    }
    return w;
  }
}

class _RadioTile<T> extends StatelessWidget {
  final KruiRadioOption<T> option;
  final ValueChanged<T?>? onChanged;

  const _RadioTile({required this.option, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onChanged != null
          ? () {
              HapticFeedback.selectionClick();
              onChanged!(option.value);
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Radio<T>(
                value: option.value,
                // groupValue removed -> handled by ancestor RadioGroup
                // onChanged removed -> handled by ancestor RadioGroup
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: option.subtitle != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(option.label, style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 2),
                        Text(
                          option.subtitle!,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.hintColor),
                        ),
                      ],
                    )
                  : Text(option.label, style: theme.textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}
