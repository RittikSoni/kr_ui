import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test helper utilities for kr_ui widget tests

/// Pumps a widget wrapped in MaterialApp for testing
Future<void> pumpKruiWidget(
  WidgetTester tester,
  Widget widget, {
  ThemeData? theme,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: theme ?? ThemeData.light(),
      home: Scaffold(
        body: widget,
      ),
    ),
  );
}

/// Taps a widget and waits for animations to settle
Future<void> tapAndSettle(
  WidgetTester tester,
  Finder finder,
) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Verifies a BackdropFilter is present (for glass effects)
void expectGlassEffect(WidgetTester tester) {
  expect(
    find.byType(BackdropFilter),
    findsWidgets,
    reason: 'Glass effect should use BackdropFilter',
  );
}

/// Finds a widget by its text descendant
Finder findWidgetByText(String text) {
  return find.ancestor(
    of: find.text(text),
    matching: find.byType(Widget),
  );
}

/// Waits for a duration and pumps
Future<void> waitAndPump(
  WidgetTester tester,
  Duration duration,
) async {
  await tester.pump(duration);
}

/// Enters text into a TextField
Future<void> enterText(
  WidgetTester tester,
  Finder finder,
  String text,
) async {
  await tester.enterText(finder, text);
  await tester.pump();
}

/// Verifies widget has specific decoration color
void expectDecorationColor(
  WidgetTester tester,
  Finder finder,
  Color expectedColor,
) {
  final container = tester.widget<Container>(finder);
  final decoration = container.decoration as BoxDecoration?;
  expect(
    decoration?.color,
    expectedColor,
    reason: 'Container should have the expected color',
  );
}
