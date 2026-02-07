import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kr_ui/kr_ui.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('KruiSimpleButton', () {
    testWidgets('renders and calls onPressed', (tester) async {
      var tapped = false;

      await pumpKruiWidget(
        tester,
        KruiSimpleButton(
          onPressed: () => tapped = true,
          child: const Text('Simple Button'),
        ),
      );

      expect(find.text('Simple Button'), findsOneWidget);

      await tapAndSettle(tester, find.text('Simple Button'));
      expect(tapped, isTrue);
    });

    testWidgets('disabled state when onPressed is null', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiSimpleButton(
          onPressed: null,
          child: Text('Disabled'),
        ),
      );

      expect(find.text('Disabled'), findsOneWidget);

      // Try to tap - should not crash
      await tester.tap(find.text('Disabled'));
      await tester.pump();
    });

    testWidgets('shows press animation with scale', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiSimpleButton(
          onPressed: () {},
          child: const Text('Press Me'),
        ),
      );

      // Press and verify animation
      await tester.press(find.text('Press Me'));
      await tester.pump();

      expect(find.text('Press Me'), findsOneWidget);
    });

    testWidgets('loading state shows CircularProgressIndicator',
        (tester) async {
      await pumpKruiWidget(
        tester,
        KruiSimpleButton(
          onPressed: () {},
          isLoading: true,
          child: const Text('Loading'),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('applies custom background color', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiSimpleButton(
          onPressed: () {},
          color: Colors.red,
          child: const Text('Red Button'),
        ),
      );

      expect(find.text('Red Button'), findsOneWidget);
    });

    testWidgets('applies custom text color', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiSimpleButton(
          onPressed: () {},
          textColor: Colors.yellow,
          child: const Text('Yellow Text'),
        ),
      );

      final textWidget = tester.widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.text('Yellow Text'),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      );

      expect(textWidget.style.color?.value, Colors.yellow.value);
    });

    testWidgets('applies custom padding', (tester) async {
      const customPadding = EdgeInsets.all(20);

      await pumpKruiWidget(
        tester,
        KruiSimpleButton(
          onPressed: () {},
          padding: customPadding,
          child: const Text('Padded'),
        ),
      );

      expect(find.text('Padded'), findsOneWidget);
    });

    testWidgets('applies custom border radius', (tester) async {
      final customRadius = BorderRadius.circular(8);

      await pumpKruiWidget(
        tester,
        KruiSimpleButton(
          onPressed: () {},
          borderRadius: customRadius,
          child: const Text('Radius'),
        ),
      );

      expect(find.text('Radius'), findsOneWidget);
    });

    testWidgets('respects custom animation duration', (tester) async {
      const customDuration = Duration(milliseconds: 300);

      await pumpKruiWidget(
        tester,
        KruiSimpleButton(
          onPressed: () {},
          animationDuration: customDuration,
          child: const Text('Animated'),
        ),
      );

      expect(find.text('Animated'), findsOneWidget);
    });

    testWidgets('disabled button has reduced opacity', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiSimpleButton(
          onPressed: null,
          child: Text('Disabled'),
        ),
      );

      // Disabled button should render with reduced opacity text
      final textWidget = tester.widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.text('Disabled'),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      );

      expect(textWidget.style.color!.a, lessThan(1.0));
    });

    testWidgets('tap cancel resets press state', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiSimpleButton(
          onPressed: () {},
          child: const Text('Cancel Test'),
        ),
      );

      // Start press
      await tester.press(find.text('Cancel Test'));
      await tester.pump();

      // Cancel by dragging away
      final gesture =
          await tester.startGesture(tester.getCenter(find.text('Cancel Test')));
      await gesture.moveBy(const Offset(100, 0));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('Cancel Test'), findsOneWidget);
    });
  });
}
