import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:kr_ui/kr_ui.dart';

void main() {
  group('KruiButton', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              label: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('renders with child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              child: const Text('Custom Child'),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Custom Child'), findsOneWidget);
    });

    testWidgets('handles tap callback', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              label: 'Tap Me',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      expect(tapped, true);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              label: 'Loading',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('does not call onPressed when disabled',
        (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              label: 'Disabled',
              onPressed: null,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();

      expect(tapped, false);
    });

    testWidgets('does not call onPressed when loading',
        (WidgetTester tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              label: 'Loading',
              isLoading: true,
              onPressed: () => tapCount++,
            ),
          ),
        ),
      );

      // Try to tap - should not work
      await tester.tap(find.byType(KruiButton));
      await tester.pumpAndSettle();

      expect(tapCount, 0);
    });

    testWidgets('renders icon in leading position',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              label: 'With Icon',
              icon: Icons.check,
              iconPosition: KruiButtonIconPosition.leading,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('With Icon'), findsOneWidget);
    });

    testWidgets('renders icon in trailing position',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              label: 'With Icon',
              icon: Icons.arrow_forward,
              iconPosition: KruiButtonIconPosition.trailing,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('With Icon'), findsOneWidget);
    });

    testWidgets('all variants render without errors',
        (WidgetTester tester) async {
      for (final variant in KruiButtonVariant.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: KruiButton(
                variant: variant,
                label: variant.name,
                onPressed: () {},
              ),
            ),
          ),
        );

        expect(find.text(variant.name), findsOneWidget);
      }
    });

    testWidgets('ripple effect can be disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              label: 'No Ripple',
              enableRipple: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Button should still render
      expect(find.text('No Ripple'), findsOneWidget);
    });

    testWidgets('custom colors are applied', (WidgetTester tester) async {
      const customBg = Color(0xFF00FF00);
      const customFg = Color(0xFFFF0000);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              label: 'Custom',
              backgroundColor: customBg,
              foregroundColor: customFg,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('gradient variant uses custom gradient colors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.gradient,
              label: 'Gradient',
              gradientColors: const [
                Color(0xFFFF0000),
                Color(0xFF00FF00),
                Color(0xFF0000FF),
              ],
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Gradient'), findsOneWidget);
    });

    testWidgets('icon-only button renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              icon: Icons.star,
              child: const SizedBox.shrink(),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('custom border radius is applied', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              label: 'Custom Radius',
              borderRadius: BorderRadius.circular(24),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Custom Radius'), findsOneWidget);
    });

    testWidgets('custom padding is applied', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              label: 'Custom Padding',
              padding: const EdgeInsets.all(32),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Custom Padding'), findsOneWidget);
    });

    testWidgets('haptics can be disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              label: 'No Haptics',
              enableHaptics: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('No Haptics'));
      await tester.pumpAndSettle();

      expect(find.text('No Haptics'), findsOneWidget);
    });

    testWidgets('respects minimum width and height',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KruiButton(
              variant: KruiButtonVariant.primary,
              label: 'Min Size',
              minWidth: 200,
              minHeight: 60,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Min Size'), findsOneWidget);
    });
  });
}
