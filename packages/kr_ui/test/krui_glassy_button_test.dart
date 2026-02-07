import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kr_ui/kr_ui.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('KruiGlassyButton', () {
    testWidgets('renders with child widget', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiGlassyButton(
          onPressed: () {},
          child: const Text('Click Me'),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      expectGlassEffect(tester);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;

      await pumpKruiWidget(
        tester,
        KruiGlassyButton(
          onPressed: () => tapped = true,
          child: const Text('Tap Test'),
        ),
      );

      await tapAndSettle(tester, find.text('Tap Test'));
      expect(tapped, isTrue);
    });

    testWidgets('disabled state when onPressed is null', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiGlassyButton(
          onPressed: null,
          child: Text('Disabled'),
        ),
      );

      expect(find.text('Disabled'), findsOneWidget);

      // Try to tap - should not crash
      await tester.tap(find.text('Disabled'));
      await tester.pump();
    });

    testWidgets('shows pressed state visual changes', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiGlassyButton(
          onPressed: () {},
          child: const Text('Press Test'),
        ),
      );

      // Trigger press
      await tester.press(find.text('Press Test'));
      await tester.pump();

      // Button should still be visible during press
      expect(find.text('Press Test'), findsOneWidget);
    });

    testWidgets('applies custom blur and opacity', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiGlassyButton(
          onPressed: () {},
          blur: 20,
          opacity: 0.3,
          child: const Text('Custom Glass'),
        ),
      );

      expect(find.text('Custom Glass'), findsOneWidget);
      expectGlassEffect(tester);
    });

    testWidgets('applies custom padding', (tester) async {
      const customPadding = EdgeInsets.all(24);

      await pumpKruiWidget(
        tester,
        KruiGlassyButton(
          onPressed: () {},
          padding: customPadding,
          child: const Text('Padding Test'),
        ),
      );

      expect(find.text('Padding Test'), findsOneWidget);
    });

    testWidgets('applies custom border radius', (tester) async {
      final customRadius = BorderRadius.circular(20);

      await pumpKruiWidget(
        tester,
        KruiGlassyButton(
          onPressed: () {},
          borderRadius: customRadius,
          child: const Text('Radius Test'),
        ),
      );

      expect(find.text('Radius Test'), findsOneWidget);
    });

    testWidgets('applies custom color', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiGlassyButton(
          onPressed: () {},
          color: Colors.blue,
          child: const Text('Color Test'),
        ),
      );

      expect(find.text('Color Test'), findsOneWidget);
    });

    group('Presets', () {
      testWidgets('primary preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyButtonPresets.primary(
            onPressed: () {},
            child: const Text('Primary'),
          ),
        );

        expect(find.text('Primary'), findsOneWidget);
      });

      testWidgets('secondary preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyButtonPresets.secondary(
            onPressed: () {},
            child: const Text('Secondary'),
          ),
        );

        expect(find.text('Secondary'), findsOneWidget);
      });

      testWidgets('danger preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyButtonPresets.danger(
            onPressed: () {},
            child: const Text('Danger'),
          ),
        );

        expect(find.text('Danger'), findsOneWidget);
      });

      testWidgets('success preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyButtonPresets.success(
            onPressed: () {},
            child: const Text('Success'),
          ),
        );

        expect(find.text('Success'), findsOneWidget);
      });

      testWidgets('icon preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyButtonPresets.icon(
            onPressed: () {},
            icon: const Icon(Icons.favorite),
          ),
        );

        expect(find.byIcon(Icons.favorite), findsOneWidget);
      });

      testWidgets('outline preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyButtonPresets.outline(
            onPressed: () {},
            child: const Text('Outline'),
          ),
        );

        expect(find.text('Outline'), findsOneWidget);
      });

      testWidgets('ghost preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyButtonPresets.ghost(
            onPressed: () {},
            child: const Text('Ghost'),
          ),
        );

        expect(find.text('Ghost'), findsOneWidget);
      });

      testWidgets('link preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyButtonPresets.link(
            onPressed: () {},
            child: const Text('Link'),
          ),
        );

        expect(find.text('Link'), findsOneWidget);
      });

      testWidgets('gradient preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyButtonPresets.gradient(
            onPressed: () {},
            colors: const [Colors.purple, Colors.blue],
            child: const Text('Gradient'),
          ),
        );

        expect(find.text('Gradient'), findsOneWidget);
      });
    });
  });
}
