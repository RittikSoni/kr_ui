import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';
import '../../config/component_models.dart';

/// Stateful calendar preview: holds selected date/dates/range and updates on interaction.
class _FunctionalCalendar extends StatefulWidget {
  final KruiCalendarSelectionMode selectionMode;
  final bool hideNavigation;
  final bool monthDropdown;
  final bool yearDropdown;
  final KruiCalendarThemeData? theme;
  final bool showWeekNumbers;
  final bool showOutsideDays;
  final bool fixedWeeks;
  final bool hideWeekdayNames;

  const _FunctionalCalendar({
    this.selectionMode = KruiCalendarSelectionMode.single,
    this.hideNavigation = false,
    this.monthDropdown = false,
    this.yearDropdown = false,
    this.theme,
    this.showWeekNumbers = false,
    this.showOutsideDays = false,
    this.fixedWeeks = true,
    this.hideWeekdayNames = false,
  });

  @override
  State<_FunctionalCalendar> createState() => _FunctionalCalendarState();
}

class _FunctionalCalendarState extends State<_FunctionalCalendar> {
  DateTime? _selectedDate;
  Set<DateTime> _selectedDates = {};
  DateTimeRange? _selectedRange;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    return KruiCalendar(
      selectionMode: widget.selectionMode,
      selectedDate: _selectedDate,
      onDateSelected: (d) => setState(() {
        _selectedDate = d;
        _selectedDates = {};
        _selectedRange = null;
      }),
      selectedDates: _selectedDates,
      onMultipleSelected: (s) => setState(() {
        _selectedDates = Set.from(s.map(_dateOnly));
        _selectedDate = null;
        _selectedRange = null;
      }),
      selectedRange: _selectedRange,
      onRangeSelected: (r) => setState(() {
        _selectedRange = r;
        _selectedDate = null;
        _selectedDates = {};
      }),
      hideNavigation: widget.hideNavigation,
      monthDropdown: widget.monthDropdown,
      yearDropdown: widget.yearDropdown,
      theme: widget.theme,
      showWeekNumbers: widget.showWeekNumbers,
      showOutsideDays: widget.showOutsideDays,
      fixedWeeks: widget.fixedWeeks,
      hideWeekdayNames: widget.hideWeekdayNames,
    );
  }
}

final kruiCalendarInfo = ComponentInfo(
  id: 'calendar',
  name: 'KruiCalendar',
  displayName: 'Calendar',
  description:
      'A configurable calendar with single, multiple, or range selection. Month/year dropdowns, hide navigation (month and year still shown), week numbers, outside days, fixed weeks, and KruiCalendarThemeData for colors and styles.',
  category: 'Forms',
  icon: Icons.calendar_month_outlined,
  properties: [
    const PropertyInfo(
      name: 'selectionMode',
      type: 'KruiCalendarSelectionMode',
      defaultValue: 'KruiCalendarSelectionMode.single',
      description: 'single, multiple, or range',
    ),
    const PropertyInfo(
      name: 'selectedDate',
      type: 'DateTime?',
      defaultValue: 'null',
      description: 'Single selected date (when selectionMode is single)',
    ),
    const PropertyInfo(
      name: 'onDateSelected',
      type: 'ValueChanged<DateTime>?',
      defaultValue: 'null',
      description: 'Callback when a single date is selected',
    ),
    const PropertyInfo(
      name: 'selectedDates',
      type: 'Set<DateTime>?',
      defaultValue: 'null',
      description: 'Multiple selected dates (when selectionMode is multiple)',
    ),
    const PropertyInfo(
      name: 'onMultipleSelected',
      type: 'ValueChanged<Set<DateTime>>?',
      defaultValue: 'null',
      description: 'Callback when multiple selection changes',
    ),
    const PropertyInfo(
      name: 'selectedRange',
      type: 'DateTimeRange?',
      defaultValue: 'null',
      description: 'Selected range (when selectionMode is range)',
    ),
    const PropertyInfo(
      name: 'onRangeSelected',
      type: 'ValueChanged<DateTimeRange>?',
      defaultValue: 'null',
      description: 'Callback when range is selected',
    ),
    const PropertyInfo(
      name: 'hideNavigation',
      type: 'bool',
      defaultValue: 'false',
      description:
          'Hide only prev/next buttons; month and year are still shown',
    ),
    const PropertyInfo(
      name: 'monthDropdown',
      type: 'bool',
      defaultValue: 'false',
      description: 'Show month as a dropdown selector',
    ),
    const PropertyInfo(
      name: 'yearDropdown',
      type: 'bool',
      defaultValue: 'false',
      description: 'Show year as a dropdown selector',
    ),
    const PropertyInfo(
      name: 'theme',
      type: 'KruiCalendarThemeData?',
      defaultValue: 'null',
      description:
          'Custom colors and styles (selectedDayColor, rangeHighlightColor, todayColor, etc.)',
    ),
    const PropertyInfo(
      name: 'showWeekNumbers',
      type: 'bool',
      defaultValue: 'false',
      description: 'Show ISO week numbers column on the left',
    ),
    const PropertyInfo(
      name: 'showOutsideDays',
      type: 'bool',
      defaultValue: 'false',
      description: 'Show days from adjacent months in the grid',
    ),
    const PropertyInfo(
      name: 'fixedWeeks',
      type: 'bool',
      defaultValue: 'true',
      description: 'Always show 6 weeks so calendar height does not change',
    ),
    const PropertyInfo(
      name: 'hideWeekdayNames',
      type: 'bool',
      defaultValue: 'false',
      description: 'Hide the row with weekday names (Mon, Tue, …)',
    ),
    const PropertyInfo(
      name: 'firstDate',
      type: 'DateTime?',
      defaultValue: 'null',
      description: 'Earliest selectable date',
    ),
    const PropertyInfo(
      name: 'lastDate',
      type: 'DateTime?',
      defaultValue: 'null',
      description: 'Latest selectable date',
    ),
    const PropertyInfo(
      name: 'initialMonth',
      type: 'DateTime?',
      defaultValue: 'null',
      description: 'Initial month to display',
    ),
  ],
  basicExample: '''KruiCalendar(
  selectedDate: selectedDate,
  onDateSelected: (d) => setState(() => selectedDate = d),
)''',
  advancedExample: '''KruiCalendar(
  selectionMode: KruiCalendarSelectionMode.range,
  selectedRange: range,
  onRangeSelected: (r) => setState(() => range = r),
  monthDropdown: true,
  yearDropdown: true,
  theme: KruiCalendarThemeData(
    selectedDayColor: Colors.blue,
    rangeHighlightColor: Colors.blue.withValues(alpha:0.2),
  ),
  showWeekNumbers: true,
  hideNavigation: false,
)''',
  presets: [
    PresetInfo(
      name: 'Single',
      description: 'Default single-date selection',
      code: '''KruiCalendar(
  selectedDate: date,
  onDateSelected: (d) => setState(() => date = d),
)''',
      builder: () => _CalendarDemo(
        child: const _FunctionalCalendar(),
      ),
    ),
    PresetInfo(
      name: 'Multiple',
      description: 'Select multiple dates',
      code: '''KruiCalendar(
  selectionMode: KruiCalendarSelectionMode.multiple,
  selectedDates: dates,
  onMultipleSelected: (s) => setState(() => dates = s),
)''',
      builder: () => _CalendarDemo(
        child: const _FunctionalCalendar(
          selectionMode: KruiCalendarSelectionMode.multiple,
        ),
      ),
    ),
    PresetInfo(
      name: 'Range',
      description: 'Select a date range (start and end)',
      code: '''KruiCalendar(
  selectionMode: KruiCalendarSelectionMode.range,
  selectedRange: range,
  onRangeSelected: (r) => setState(() => range = r),
)''',
      builder: () => _CalendarDemo(
        child: const _FunctionalCalendar(
          selectionMode: KruiCalendarSelectionMode.range,
        ),
      ),
    ),
    PresetInfo(
      name: 'Hide navigation',
      description: 'No prev/next buttons; month and year still shown',
      code: '''KruiCalendar(
  hideNavigation: true,
  selectedDate: date,
  onDateSelected: (d) => setState(() => date = d),
)''',
      builder: () => _CalendarDemo(
        child: const _FunctionalCalendar(hideNavigation: true),
      ),
    ),
    PresetInfo(
      name: 'Dropdown months',
      description: 'Month selector as dropdown',
      code: '''KruiCalendar(
  monthDropdown: true,
  selectedDate: date,
  onDateSelected: (d) => setState(() => date = d),
)''',
      builder: () => _CalendarDemo(
        child: const _FunctionalCalendar(monthDropdown: true),
      ),
    ),
    PresetInfo(
      name: 'Dropdown years',
      description: 'Year selector as dropdown',
      code: '''KruiCalendar(
  yearDropdown: true,
  selectedDate: date,
  onDateSelected: (d) => setState(() => date = d),
)''',
      builder: () => _CalendarDemo(
        child: const _FunctionalCalendar(yearDropdown: true),
      ),
    ),
    PresetInfo(
      name: 'Dropdown month & year',
      description: 'Both month and year as dropdowns',
      code: '''KruiCalendar(
  monthDropdown: true,
  yearDropdown: true,
  selectedDate: date,
  onDateSelected: (d) => setState(() => date = d),
)''',
      builder: () => _CalendarDemo(
        child: const _FunctionalCalendar(
          monthDropdown: true,
          yearDropdown: true,
        ),
      ),
    ),
    PresetInfo(
      name: 'Custom theme',
      description: 'Custom colors: selected day, range highlight, today',
      code: '''KruiCalendar(
  selectedDate: date,
  onDateSelected: (d) => setState(() => date = d),
  theme: KruiCalendarThemeData(
    selectedDayColor: Colors.deepPurple,
    selectedDayTextColor: Colors.white,
    rangeHighlightColor: Colors.deepPurple.withValues(alpha:0.2),
    todayColor: Colors.deepPurple.withValues(alpha:0.1),
    todayBorderColor: Colors.deepPurple,
    weekdayColor: Colors.grey,
  ),
)''',
      builder: () => _CalendarDemo(
        child: _FunctionalCalendar(
          theme: KruiCalendarThemeData(
            selectedDayColor: Colors.deepPurple,
            selectedDayTextColor: Colors.white,
            rangeHighlightColor: Colors.deepPurple.withValues(alpha: 0.2),
            todayColor: Colors.deepPurple.withValues(alpha: 0.1),
            todayBorderColor: Colors.deepPurple,
            weekdayColor: Colors.grey,
          ),
        ),
      ),
    ),
    PresetInfo(
      name: 'Show week numbers',
      description: 'ISO week numbers on the left',
      code: '''KruiCalendar(
  showWeekNumbers: true,
  selectedDate: date,
  onDateSelected: (d) => setState(() => date = d),
)''',
      builder: () => _CalendarDemo(
        child: const _FunctionalCalendar(showWeekNumbers: true),
      ),
    ),
    PresetInfo(
      name: 'Show outside days',
      description: 'Show days from previous/next month in grid',
      code: '''KruiCalendar(
  showOutsideDays: true,
  selectedDate: date,
  onDateSelected: (d) => setState(() => date = d),
)''',
      builder: () => _CalendarDemo(
        child: const _FunctionalCalendar(showOutsideDays: true),
      ),
    ),
    PresetInfo(
      name: 'Fixed weeks',
      description: 'Always 6 weeks (consistent height)',
      code: '''KruiCalendar(
  fixedWeeks: true,
  selectedDate: date,
  onDateSelected: (d) => setState(() => date = d),
)''',
      builder: () => _CalendarDemo(
        child: const _FunctionalCalendar(fixedWeeks: true),
      ),
    ),
    PresetInfo(
      name: 'Hide weekday names',
      description: 'No Mon, Tue, Wed… row',
      code: '''KruiCalendar(
  hideWeekdayNames: true,
  selectedDate: date,
  onDateSelected: (d) => setState(() => date = d),
)''',
      builder: () => _CalendarDemo(
        child: const _FunctionalCalendar(hideWeekdayNames: true),
      ),
    ),
    PresetInfo(
      name: 'All options combined',
      description:
          'Multiple selection, week numbers, outside days, fixed weeks',
      code: '''KruiCalendar(
  selectionMode: KruiCalendarSelectionMode.multiple,
  selectedDates: dates,
  onMultipleSelected: (s) => setState(() => dates = s),
  showWeekNumbers: true,
  showOutsideDays: true,
  fixedWeeks: true,
)''',
      builder: () => _CalendarDemo(
        child: const _FunctionalCalendar(
          selectionMode: KruiCalendarSelectionMode.multiple,
          showWeekNumbers: true,
          showOutsideDays: true,
          fixedWeeks: true,
        ),
      ),
    ),
  ],
  demoBuilder: () => _CalendarDemo(
    child: const _FunctionalCalendar(
      showWeekNumbers: true,
      fixedWeeks: true,
    ),
  ),
);

class _CalendarDemo extends StatefulWidget {
  final Widget child;

  const _CalendarDemo({required this.child});

  @override
  State<_CalendarDemo> createState() => _CalendarDemoState();
}

class _CalendarDemoState extends State<_CalendarDemo> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: widget.child,
        ),
      ),
    );
  }
}
