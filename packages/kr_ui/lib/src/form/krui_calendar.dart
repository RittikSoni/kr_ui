import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Selection mode for [KruiCalendar].
enum KruiCalendarSelectionMode {
  /// Single date selection.
  single,

  /// Multiple dates selection.
  multiple,

  /// Date range selection (start and end).
  range,
}

/// Theme data for [KruiCalendar] colors and text styles.
///
/// All fields are optional; missing values fall back to [ThemeData].
class KruiCalendarThemeData {
  final Color? selectedDayColor;
  final Color? selectedDayTextColor;
  final Color? rangeHighlightColor;
  final Color? todayColor;
  final Color? todayBorderColor;
  final Color? weekdayColor;
  final Color? outsideDayColor;
  final Color? disabledDayColor;
  final Color? headerColor;
  final Color? headerBackgroundColor;
  final Color? navigationButtonColor;
  final Color? weekNumberColor;
  final double? dayCellBorderRadius;
  final TextStyle? headerTextStyle;
  final TextStyle? weekdayTextStyle;
  final TextStyle? dayTextStyle;

  const KruiCalendarThemeData({
    this.selectedDayColor,
    this.selectedDayTextColor,
    this.rangeHighlightColor,
    this.todayColor,
    this.todayBorderColor,
    this.weekdayColor,
    this.outsideDayColor,
    this.disabledDayColor,
    this.headerColor,
    this.headerBackgroundColor,
    this.navigationButtonColor,
    this.weekNumberColor,
    this.dayCellBorderRadius,
    this.headerTextStyle,
    this.weekdayTextStyle,
    this.dayTextStyle,
  });

  /// Create a theme from [ThemeData], overriding with non-null fields.
  KruiCalendarThemeData resolveWith(ThemeData theme) {
    return KruiCalendarThemeData(
      selectedDayColor: selectedDayColor ?? theme.colorScheme.primary,
      selectedDayTextColor: selectedDayTextColor ?? theme.colorScheme.onPrimary,
      rangeHighlightColor: rangeHighlightColor ??
          theme.colorScheme.primary.withValues(alpha: 0.2),
      todayColor:
          todayColor ?? theme.colorScheme.primary.withValues(alpha: 0.15),
      todayBorderColor: todayBorderColor ?? theme.colorScheme.primary,
      weekdayColor: weekdayColor ?? theme.hintColor,
      outsideDayColor:
          outsideDayColor ?? theme.hintColor.withValues(alpha: 0.6),
      disabledDayColor:
          disabledDayColor ?? theme.hintColor.withValues(alpha: 0.5),
      headerColor: headerColor ?? theme.colorScheme.onSurface,
      headerBackgroundColor: headerBackgroundColor,
      navigationButtonColor:
          navigationButtonColor ?? theme.colorScheme.onSurface,
      weekNumberColor: weekNumberColor ?? theme.hintColor,
      dayCellBorderRadius: dayCellBorderRadius ?? 8,
      headerTextStyle: headerTextStyle ??
          theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      weekdayTextStyle: weekdayTextStyle ??
          theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
      dayTextStyle: dayTextStyle ?? theme.textTheme.bodyMedium,
    );
  }
}

/// A configurable calendar widget with single, multiple, or range selection.
///
/// Options: [monthDropdown] and [yearDropdown] for month/year selectors;
/// [hideNavigation] hides only prev/next (month and year still shown);
/// week numbers, outside days (default off), fixed weeks, weekday names;
/// [theme] ([KruiCalendarThemeData]) for colors and styles.
///
/// ## Basic usage
///
/// ```dart
/// KruiCalendar(
///   selectedDate: selected,
///   onDateSelected: (d) => setState(() => selected = d),
/// )
/// ```
///
/// ## With options
///
/// ```dart
/// KruiCalendar(
///   selectionMode: KruiCalendarSelectionMode.range,
///   selectedRange: range,
///   onRangeSelected: (r) => setState(() => range = r),
///   showWeekNumbers: true,
///   showOutsideDays: false,
///   fixedWeeks: true,
///   hideWeekdayNames: false,
///   hideNavigation: false,
/// )
/// ```
class KruiCalendar extends StatefulWidget {
  /// Single selected date (when [selectionMode] is [KruiCalendarSelectionMode.single]).
  final DateTime? selectedDate;

  /// Callback when a single date is selected.
  final ValueChanged<DateTime>? onDateSelected;

  /// Multiple selected dates (when [selectionMode] is [KruiCalendarSelectionMode.multiple]).
  final Set<DateTime>? selectedDates;

  /// Callback when multiple selection changes.
  final ValueChanged<Set<DateTime>>? onMultipleSelected;

  /// Selected range (when [selectionMode] is [KruiCalendarSelectionMode.range]).
  final DateTimeRange? selectedRange;

  /// Callback when a range is selected.
  final ValueChanged<DateTimeRange>? onRangeSelected;

  /// Selection mode: single, multiple, or range.
  final KruiCalendarSelectionMode selectionMode;

  /// Initial month to display (defaults to current month or selected date's month).
  final DateTime? initialMonth;

  /// Earliest selectable date.
  final DateTime? firstDate;

  /// Latest selectable date.
  final DateTime? lastDate;

  /// When true, hide only the prev/next arrows. Month and year are still shown (as text or dropdowns).
  final bool hideNavigation;

  /// Show month as a dropdown instead of text.
  final bool monthDropdown;

  /// Show year as a dropdown instead of text.
  final bool yearDropdown;

  /// Optional theme for calendar colors and styles. Falls back to [Theme.of(context)].
  final KruiCalendarThemeData? theme;

  /// Show week numbers column on the left (ISO week).
  final bool showWeekNumbers;

  /// Show days from adjacent months in the grid. Default false.
  final bool showOutsideDays;

  /// Use a fixed number of weeks (6) so calendar height doesn't change.
  final bool fixedWeeks;

  /// Hide the row with weekday names (Mon, Tue, ...).
  final bool hideWeekdayNames;

  /// First day of week (1 = Monday, 7 = Sunday). Default 1 (Monday).
  final int firstDayOfWeek;

  /// Custom header builder for the month/year row. If null, default text is used.
  final Widget Function(DateTime month)? headerBuilder;

  /// Custom day cell builder. If null, default styling is used.
  final Widget Function(
    BuildContext context,
    DateTime day,
    bool isSelected,
    bool isInRange,
    bool isOutside,
    bool isDisabled,
  )? dayBuilder;

  const KruiCalendar({
    super.key,
    this.selectedDate,
    this.onDateSelected,
    this.selectedDates,
    this.onMultipleSelected,
    this.selectedRange,
    this.onRangeSelected,
    this.selectionMode = KruiCalendarSelectionMode.single,
    this.initialMonth,
    this.firstDate,
    this.lastDate,
    this.hideNavigation = false,
    this.monthDropdown = false,
    this.yearDropdown = false,
    this.theme,
    this.showWeekNumbers = false,
    this.showOutsideDays = false,
    this.fixedWeeks = true,
    this.hideWeekdayNames = false,
    this.firstDayOfWeek = 1,
    this.headerBuilder,
    this.dayBuilder,
  })  : assert(firstDayOfWeek >= 1 && firstDayOfWeek <= 7),
        assert(
          selectionMode != KruiCalendarSelectionMode.multiple ||
              onMultipleSelected != null,
        ),
        assert(
          selectionMode != KruiCalendarSelectionMode.range ||
              onRangeSelected != null,
        );

  @override
  State<KruiCalendar> createState() => _KruiCalendarState();
}

class _KruiCalendarState extends State<KruiCalendar> {
  late DateTime _currentMonth;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool _isBefore(DateTime a, DateTime b) =>
      _dateOnly(a).isBefore(_dateOnly(b));

  static bool _isAfter(DateTime a, DateTime b) =>
      _dateOnly(a).isAfter(_dateOnly(b));

  bool _isDisabled(DateTime day) {
    final d = _dateOnly(day);
    if (widget.firstDate != null && d.isBefore(_dateOnly(widget.firstDate!))) {
      return true;
    }
    if (widget.lastDate != null && d.isAfter(_dateOnly(widget.lastDate!))) {
      return true;
    }
    return false;
  }

  bool _isSelected(DateTime day) {
    final d = _dateOnly(day);
    switch (widget.selectionMode) {
      case KruiCalendarSelectionMode.single:
        return widget.selectedDate != null &&
            _isSameDay(d, _dateOnly(widget.selectedDate!));
      case KruiCalendarSelectionMode.multiple:
        return widget.selectedDates?.any((x) => _isSameDay(d, _dateOnly(x))) ??
            false;
      case KruiCalendarSelectionMode.range:
        if (widget.selectedRange == null) return false;
        final start = _dateOnly(widget.selectedRange!.start);
        final end = _dateOnly(widget.selectedRange!.end);
        return (_isSameDay(d, start) || _isSameDay(d, end)) ||
            (_isAfter(d, start) && _isBefore(d, end));
    }
  }

  bool _isInRange(DateTime day) {
    if (widget.selectionMode != KruiCalendarSelectionMode.range ||
        widget.selectedRange == null) {
      return false;
    }
    final d = _dateOnly(day);
    final start = _dateOnly(widget.selectedRange!.start);
    final end = _dateOnly(widget.selectedRange!.end);
    if (_isSameDay(d, start) || _isSameDay(d, end)) return false;
    return _isAfter(d, start) && _isBefore(d, end);
  }

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialMonth ??
        widget.selectedDate ??
        widget.selectedRange?.start ??
        DateTime.now();
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month);
  }

  @override
  void didUpdateWidget(covariant KruiCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMonth != null &&
        widget.initialMonth != oldWidget.initialMonth) {
      _currentMonth = DateTime(
        widget.initialMonth!.year,
        widget.initialMonth!.month,
      );
    }
  }

  void _prevMonth() {
    HapticFeedback.lightImpact();
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    HapticFeedback.lightImpact();
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _onDayTapped(DateTime day) {
    final d = _dateOnly(day);
    if (_isDisabled(day)) return;
    HapticFeedback.lightImpact();

    switch (widget.selectionMode) {
      case KruiCalendarSelectionMode.single:
        widget.onDateSelected?.call(d);
        break;
      case KruiCalendarSelectionMode.multiple:
        {
          final set = Set<DateTime>.from(
            widget.selectedDates?.map(_dateOnly) ?? [],
          );
          if (set.contains(d)) {
            set.remove(d);
          } else {
            set.add(d);
          }
          widget.onMultipleSelected?.call(set);
          break;
        }
      case KruiCalendarSelectionMode.range:
        {
          final range = widget.selectedRange;
          if (range == null) {
            widget.onRangeSelected?.call(DateTimeRange(start: d, end: d));
            return;
          }
          final start = _dateOnly(range.start);
          final end = _dateOnly(range.end);
          if (_isSameDay(d, start) || _isSameDay(d, end)) {
            widget.onRangeSelected?.call(DateTimeRange(start: d, end: d));
          } else if (d.isBefore(start)) {
            widget.onRangeSelected?.call(DateTimeRange(start: d, end: end));
          } else {
            widget.onRangeSelected?.call(DateTimeRange(start: start, end: d));
          }
          break;
        }
    }
  }

  /// ISO week number (1-53).
  static int _isoWeekNumber(DateTime date) {
    final d = DateTime.utc(date.year, date.month, date.day);
    final thursday = d.add(Duration(days: 4 - (d.weekday % 7)));
    final jan1 = DateTime.utc(thursday.year, 1, 1);
    return 1 + ((thursday.difference(jan1).inDays) / 7).floor();
  }

  List<DateTime> _buildMonthDays() {
    final year = _currentMonth.year;
    final month = _currentMonth.month;
    final first = DateTime(year, month, 1);
    // Column index for the 1st (0 = first day of week).
    final leading = (first.weekday - widget.firstDayOfWeek + 7) % 7;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final totalCells =
        widget.fixedWeeks ? 42 : (((leading + daysInMonth) + 6) ~/ 7) * 7;
    final trailing = totalCells - leading - daysInMonth;

    final list = <DateTime>[];
    final prevMonth =
        month == 1 ? DateTime(year - 1, 12) : DateTime(year, month - 1);
    final prevDays = DateTime(prevMonth.year, prevMonth.month + 1, 0).day;

    for (var i = 0; i < leading; i++) {
      final day = prevDays - leading + 1 + i;
      list.add(DateTime(prevMonth.year, prevMonth.month, day));
    }
    for (var i = 1; i <= daysInMonth; i++) {
      list.add(DateTime(year, month, i));
    }
    for (var i = 0; i < trailing; i++) {
      list.add(DateTime(year, month + 1, i + 1));
    }
    return list;
  }

  List<int> _weekNumbersForRows() {
    final days = _buildMonthDays();
    final weeks = <int>[];
    for (var i = 0; i < days.length; i += 7) {
      if (i < days.length) {
        weeks.add(_isoWeekNumber(days[i]));
      }
    }
    return weeks;
  }

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  bool get _canGoPrev {
    if (widget.firstDate == null) return true;
    final limit = DateTime(_currentMonth.year, _currentMonth.month);
    return limit.isAfter(_dateOnly(widget.firstDate!));
  }

  bool get _canGoNext {
    if (widget.lastDate == null) return true;
    final limit = DateTime(_currentMonth.year, _currentMonth.month);
    return limit.isBefore(_dateOnly(widget.lastDate!));
  }

  List<int> _yearsForDropdown() {
    final first = widget.firstDate?.year ?? _currentMonth.year - 10;
    final last = widget.lastDate?.year ?? _currentMonth.year + 10;
    return List.generate(last - first + 1, (i) => first + i);
  }

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calTheme =
        (widget.theme ?? KruiCalendarThemeData()).resolveWith(theme);
    final days = _buildMonthDays();
    final weekNumbers = widget.showWeekNumbers ? _weekNumbersForRows() : null;

    Widget calendar = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(theme, calTheme),
        const SizedBox(height: 12),
        if (!widget.hideWeekdayNames) _buildWeekdayRow(calTheme),
        if (!widget.hideWeekdayNames) const SizedBox(height: 4),
        ..._buildWeekRows(theme, calTheme, days, weekNumbers),
      ],
    );

    return calendar;
  }

  Widget _buildHeader(ThemeData theme, KruiCalendarThemeData calTheme) {
    if (widget.headerBuilder != null) {
      return widget.headerBuilder!(_currentMonth);
    }
    final useDropdownMonth = widget.monthDropdown;
    final useDropdownYear = widget.yearDropdown;

    Widget monthWidget = useDropdownMonth
        ? _MonthDropdown(
            value: _currentMonth.month,
            theme: calTheme,
            onChanged: (m) {
              HapticFeedback.lightImpact();
              setState(() => _currentMonth = DateTime(_currentMonth.year, m));
            },
          )
        : Text(
            _monthNames[_currentMonth.month - 1],
            style:
                calTheme.headerTextStyle?.copyWith(color: calTheme.headerColor),
          );

    Widget yearWidget = useDropdownYear
        ? _YearDropdown(
            value: _currentMonth.year,
            years: _yearsForDropdown(),
            theme: calTheme,
            onChanged: (y) {
              HapticFeedback.lightImpact();
              setState(() => _currentMonth = DateTime(y, _currentMonth.month));
            },
          )
        : Text(
            '${_currentMonth.year}',
            style:
                calTheme.headerTextStyle?.copyWith(color: calTheme.headerColor),
          );

    Widget centerContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        monthWidget,
        const SizedBox(width: 8),
        yearWidget,
      ],
    );

    if (widget.hideNavigation) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: calTheme.headerBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: centerContent),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        KruiCalendarNavButton(
          icon: Icons.chevron_left,
          color: calTheme.navigationButtonColor,
          onPressed: _canGoPrev ? _prevMonth : null,
        ),
        Expanded(child: Center(child: centerContent)),
        KruiCalendarNavButton(
          icon: Icons.chevron_right,
          color: calTheme.navigationButtonColor,
          onPressed: _canGoNext ? _nextMonth : null,
        ),
      ],
    );
  }

  Widget _buildWeekdayRow(KruiCalendarThemeData calTheme) {
    final labels = List<String>.generate(7, (i) {
      final idx = (widget.firstDayOfWeek - 1 + i) % 7;
      return _weekdays[idx];
    });
    return Row(
      children: [
        if (widget.showWeekNumbers)
          SizedBox(
            width: 28,
            child: Center(
              child: Text(
                '#',
                style: calTheme.weekdayTextStyle
                    ?.copyWith(color: calTheme.weekNumberColor),
              ),
            ),
          ),
        ...labels.map((l) => Expanded(
              child: Center(
                child: Text(
                  l,
                  style: calTheme.weekdayTextStyle
                      ?.copyWith(color: calTheme.weekdayColor),
                ),
              ),
            )),
      ],
    );
  }

  List<Widget> _buildWeekRows(ThemeData theme, KruiCalendarThemeData calTheme,
      List<DateTime> days, List<int>? weekNumbers) {
    final today = _dateOnly(DateTime.now());
    final rows = <Widget>[];
    for (var r = 0; r < days.length; r += 7) {
      final rowDays =
          days.sublist(r, r + 7 > days.length ? days.length : r + 7);
      final weekNum = weekNumbers != null && (r ~/ 7) < weekNumbers.length
          ? weekNumbers[r ~/ 7]
          : null;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              if (widget.showWeekNumbers)
                SizedBox(
                  width: 28,
                  child: Center(
                    child: Text(
                      weekNum?.toString() ?? '',
                      style: calTheme.weekdayTextStyle
                          ?.copyWith(color: calTheme.weekNumberColor),
                    ),
                  ),
                ),
              ...rowDays.map((day) {
                final isCurrentMonth = day.month == _currentMonth.month;
                final isOutside = !isCurrentMonth;
                final showCell = widget.showOutsideDays || isCurrentMonth;
                final isDisabled = _isDisabled(day);
                final isSelected = _isSelected(day);
                final isInRange = _isInRange(day);
                final isToday = _isSameDay(_dateOnly(day), today);

                if (!showCell) {
                  return const Expanded(child: SizedBox());
                }

                if (widget.dayBuilder != null) {
                  return Expanded(
                    child: widget.dayBuilder!(
                      context,
                      day,
                      isSelected,
                      isInRange,
                      isOutside,
                      isDisabled,
                    ),
                  );
                }

                return Expanded(
                  child: _DefaultDayCell(
                    day: day.day,
                    isSelected: isSelected,
                    isInRange: isInRange,
                    isOutside: isOutside,
                    isDisabled: isDisabled,
                    isToday: isToday,
                    calTheme: calTheme,
                    dayTextStyle: calTheme.dayTextStyle,
                    onTap: () => _onDayTapped(day),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    }
    return rows;
  }
}

class KruiCalendarNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;

  const KruiCalendarNavButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = color ?? theme.colorScheme.onSurface;
    return Material(
      color: Colors.transparent,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon,
            size: 24, color: onPressed != null ? c : c.withValues(alpha: 0.4)),
        style: IconButton.styleFrom(
          foregroundColor: c,
          minimumSize: const Size(40, 40),
          disabledForegroundColor: c.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _MonthDropdown extends StatelessWidget {
  final int value;
  final KruiCalendarThemeData theme;
  final ValueChanged<int> onChanged;

  const _MonthDropdown({
    required this.value,
    required this.theme,
    required this.onChanged,
  });

  static const _names = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: value,
      isDense: true,
      underline: const SizedBox(),
      style: theme.headerTextStyle?.copyWith(color: theme.headerColor),
      items: List.generate(12, (i) => i + 1).map((m) {
        return DropdownMenuItem<int>(
          value: m,
          child: Text(_names[m - 1]),
        );
      }).toList(),
      onChanged: (m) => m != null ? onChanged(m) : null,
    );
  }
}

class _YearDropdown extends StatelessWidget {
  final int value;
  final List<int> years;
  final KruiCalendarThemeData theme;
  final ValueChanged<int> onChanged;

  const _YearDropdown({
    required this.value,
    required this.years,
    required this.theme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: years.contains(value) ? value : null,
      isDense: true,
      underline: const SizedBox(),
      style: theme.headerTextStyle?.copyWith(color: theme.headerColor),
      items: years.map((y) {
        return DropdownMenuItem<int>(
          value: y,
          child: Text('$y'),
        );
      }).toList(),
      onChanged: (y) => y != null ? onChanged(y) : null,
    );
  }
}

class _DefaultDayCell extends StatelessWidget {
  final int day;
  final bool isSelected;
  final bool isInRange;
  final bool isOutside;
  final bool isDisabled;
  final bool isToday;
  final KruiCalendarThemeData calTheme;
  final TextStyle? dayTextStyle;
  final VoidCallback onTap;

  const _DefaultDayCell({
    required this.day,
    required this.isSelected,
    required this.isInRange,
    required this.isOutside,
    required this.isDisabled,
    required this.isToday,
    required this.calTheme,
    this.dayTextStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = calTheme.dayCellBorderRadius ?? 8;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: isInRange ? calTheme.rangeHighlightColor : Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? calTheme.selectedDayColor
                  : (isToday ? calTheme.todayColor : null),
              borderRadius: BorderRadius.circular(radius),
              border: isToday && !isSelected
                  ? Border.all(
                      color: calTheme.todayBorderColor ??
                          calTheme.selectedDayColor!,
                      width: 1.5,
                    )
                  : null,
            ),
            child: Text(
              '$day',
              style: (dayTextStyle ?? calTheme.dayTextStyle)?.copyWith(
                color: isDisabled
                    ? calTheme.disabledDayColor
                    : isOutside
                        ? calTheme.outsideDayColor
                        : isSelected
                            ? calTheme.selectedDayTextColor
                            : null,
                fontWeight: isSelected ? FontWeight.w600 : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
