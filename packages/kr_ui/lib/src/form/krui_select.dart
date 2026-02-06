import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Option for [KruiSelect]. [category] is optional for grouping.
class KruiSelectOption<T> {
  final T value;
  final String label;
  final String? category;

  const KruiSelectOption({required this.value, required this.label, this.category});
}

/// A modern dropdown/select with optional search, scrollable list, and categories.
///
/// Use [options] for flat list, or set [category] on options for grouped display.
/// Set [searchable: true] to filter options by typing.
class KruiSelect<T> extends StatefulWidget {
  final T? value;
  final List<KruiSelectOption<T>> options;
  final ValueChanged<T?> onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool searchable;
  final String? searchHint;
  final bool enabled;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double? dropdownMaxHeight;

  const KruiSelect({
    super.key,
    required this.options,
    required this.onChanged,
    this.value,
    this.label,
    this.hint,
    this.errorText,
    this.searchable = false,
    this.searchHint,
    this.enabled = true,
    this.padding,
    this.borderRadius,
    this.dropdownMaxHeight,
  });

  @override
  State<KruiSelect<T>> createState() => _KruiSelectState<T>();
}

class _KruiSelectState<T> extends State<KruiSelect<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleOverlay() {
    if (!widget.enabled) return;
    HapticFeedback.lightImpact();
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
    setState(() => _isOpen = !_isOpen);
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => _SelectOverlay<T>(
        layerLink: _layerLink,
        options: widget.options,
        value: widget.value,
        onSelected: (v) {
          widget.onChanged(v);
          _removeOverlay();
          setState(() => _isOpen = false);
        },
        onDismiss: () {
          _removeOverlay();
          setState(() => _isOpen = false);
        },
        searchable: widget.searchable,
        searchHint: widget.searchHint,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        maxHeight: widget.dropdownMaxHeight ?? 280,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final radius = widget.borderRadius ?? BorderRadius.circular(12);
    final padding = widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final selectedOption = widget.options.cast<KruiSelectOption<T>?>().firstWhere(
          (o) => o?.value == widget.value,
          orElse: () => null,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: hasError ? theme.colorScheme.error : null,
            ),
          ),
          const SizedBox(height: 8),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleOverlay,
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
                  Expanded(
                    child: Text(
                      selectedOption?.label ?? widget.hint ?? 'Select...',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: selectedOption != null ? null : theme.hintColor,
                      ),
                    ),
                  ),
                  Icon(
                    _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: theme.hintColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
          ),
        ],
      ],
    );
  }
}

class _SelectOverlay<T> extends StatefulWidget {
  final LayerLink layerLink;
  final List<KruiSelectOption<T>> options;
  final T? value;
  final ValueChanged<T?> onSelected;
  final VoidCallback onDismiss;
  final bool searchable;
  final String? searchHint;
  final BorderRadius borderRadius;
  final double maxHeight;

  const _SelectOverlay({
    required this.layerLink,
    required this.options,
    required this.value,
    required this.onSelected,
    required this.onDismiss,
    required this.searchable,
    this.searchHint,
    required this.borderRadius,
    required this.maxHeight,
  });

  @override
  State<_SelectOverlay<T>> createState() => _SelectOverlayState<T>();
}

class _SelectOverlayState<T> extends State<_SelectOverlay<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<KruiSelectOption<T>> get _filtered {
    if (_query.trim().isEmpty) return widget.options;
    final q = _query.trim().toLowerCase();
    return widget.options.where((o) => o.label.toLowerCase().contains(q)).toList();
  }

  Map<String, List<KruiSelectOption<T>>> get _grouped {
    final map = <String, List<KruiSelectOption<T>>>{};
    for (final o in _filtered) {
      final cat = o.category ?? '';
      map.putIfAbsent(cat, () => []).add(o);
    }
    return map;
  }

  bool get _hasCategories => widget.options.any((o) => o.category != null && o.category!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF2C2C2E) : Colors.white;

    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onDismiss,
          child: const SizedBox.expand(),
        ),
        Positioned(
          width: 240,
          child: CompositedTransformFollower(
            link: widget.layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 52),
            child: Material(
              elevation: 8,
              borderRadius: widget.borderRadius,
              color: surface,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: widget.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.searchable)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (q) => setState(() => _query = q),
                          decoration: InputDecoration(
                            hintText: widget.searchHint ?? 'Search...',
                            isDense: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        children: _hasCategories
                            ? _grouped.entries.expand((e) {
                                return [
                                  if (e.key.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                                      child: Text(
                                        e.key,
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.hintColor,
                                        ),
                                      ),
                                    ),
                                  ...e.value.map((o) => _optionTile(o)),
                                ];
                              }).toList()
                            : _filtered.map((o) => _optionTile(o)).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _optionTile(KruiSelectOption<T> option) {
    final selected = option.value == widget.value;
    return ListTile(
      dense: true,
      title: Text(option.label),
      selected: selected,
      onTap: () => widget.onSelected(option.value),
    );
  }
}
