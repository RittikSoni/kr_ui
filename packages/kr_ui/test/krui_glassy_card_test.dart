import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kr_ui/kr_ui.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('KruiGlassyCard', () {
    testWidgets('renders with default parameters', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiGlassyCard(
          child: Text('Test Content'),
        ),
      );

      expect(find.text('Test Content'), findsOneWidget);
      expectGlassEffect(tester);
    });

    testWidgets('displays child widget correctly', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiGlassyCard(
          child: Column(
            children: [
              Icon(Icons.star),
              Text('Star Content'),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Star Content'), findsOneWidget);
    });

    testWidgets('applies blur effect with BackdropFilter', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiGlassyCard(
          blur: 15,
          child: Text('Blurred'),
        ),
      );

      tester.widget<BackdropFilter>(
        find.byType(BackdropFilter),
      );

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('respects custom blur value', (tester) async {
      const customBlur = 20.0;

      await pumpKruiWidget(
        tester,
        const KruiGlassyCard(
          blur: customBlur,
          child: Text('Custom Blur'),
        ),
      );

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('applies opacity correctly', (tester) async {
      const customOpacity = 0.3;

      await pumpKruiWidget(
        tester,
        const KruiGlassyCard(
          opacity: customOpacity,
          color: Colors.white,
          child: Text('Opacity Test'),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(KruiGlassyCard),
              matching: find.byType(Container),
            )
            .last,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color!.a, closeTo(customOpacity, 0.01));
    });

    testWidgets('uses custom border radius', (tester) async {
      final customRadius = BorderRadius.circular(24);

      await pumpKruiWidget(
        tester,
        KruiGlassyCard(
          borderRadius: customRadius,
          child: const Text('Radius Test'),
        ),
      );

      final clipRRect = tester.widget<ClipRRect>(
        find.byType(ClipRRect),
      );

      expect(clipRRect.borderRadius, customRadius);
    });

    testWidgets('applies padding correctly', (tester) async {
      const customPadding = EdgeInsets.all(32);

      await pumpKruiWidget(
        tester,
        const KruiGlassyCard(
          padding: customPadding,
          child: Text('Padding Test'),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(KruiGlassyCard),
              matching: find.byType(Container),
            )
            .last,
      );

      expect(container.padding, customPadding);
    });

    testWidgets('applies margin correctly', (tester) async {
      const customMargin = EdgeInsets.all(20);

      await pumpKruiWidget(
        tester,
        const KruiGlassyCard(
          margin: customMargin,
          child: Text('Margin Test'),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(KruiGlassyCard),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.margin, customMargin);
    });

    testWidgets('renders shadow when enabled', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiGlassyCard(
          enableShadow: true,
          child: Text('Shadow Test'),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(KruiGlassyCard),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.boxShadow, isNotNull);
      expect(decoration?.boxShadow, isNotEmpty);
    });

    testWidgets('no shadow when disabled', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiGlassyCard(
          enableShadow: false,
          child: Text('No Shadow Test'),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(KruiGlassyCard),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.decoration, isNull);
    });

    testWidgets('respects width and height parameters', (tester) async {
      const width = 200.0;
      const height = 150.0;

      await pumpKruiWidget(
        tester,
        const KruiGlassyCard(
          width: width,
          height: height,
          child: Text('Size Test'),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(KruiGlassyCard),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.constraints?.maxWidth, width);
      expect(container.constraints?.maxHeight, height);
    });

    testWidgets('applies custom color tint', (tester) async {
      const customColor = Colors.blue;

      await pumpKruiWidget(
        tester,
        const KruiGlassyCard(
          color: customColor,
          opacity: 0.2,
          child: Text('Color Test'),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(KruiGlassyCard),
              matching: find.byType(Container),
            )
            .last,
      );

      final decoration = container.decoration as BoxDecoration;
      expect((decoration.color!.r * 255.0).round().clamp(0, 255),
          (customColor.r * 255.0).round().clamp(0, 255));
      expect((decoration.color!.g * 255.0).round().clamp(0, 255),
          (customColor.g * 255.0).round().clamp(0, 255));
      expect((decoration.color!.b * 255.0).round().clamp(0, 255),
          (customColor.b * 255.0).round().clamp(0, 255));
    });

    group('Presets', () {
      testWidgets('subtle preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyCardPresets.subtle(
            child: const Text('Subtle'),
          ),
        );

        expect(find.text('Subtle'), findsOneWidget);
        expectGlassEffect(tester);
      });

      testWidgets('standard preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyCardPresets.standard(
            child: const Text('Standard'),
          ),
        );

        expect(find.text('Standard'), findsOneWidget);
        expectGlassEffect(tester);
      });

      testWidgets('strong preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyCardPresets.strong(
            child: const Text('Strong'),
          ),
        );

        expect(find.text('Strong'), findsOneWidget);
        expectGlassEffect(tester);
      });

      testWidgets('dark preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyCardPresets.dark(
            child: const Text('Dark'),
          ),
        );

        expect(find.text('Dark'), findsOneWidget);
        expectGlassEffect(tester);
      });

      testWidgets('colored preset renders correctly', (tester) async {
        await pumpKruiWidget(
          tester,
          GlassyCardPresets.colored(
            color: Colors.purple,
            child: const Text('Colored'),
          ),
        );

        expect(find.text('Colored'), findsOneWidget);
        expectGlassEffect(tester);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles minimum blur value', (tester) async {
        await pumpKruiWidget(
          tester,
          const KruiGlassyCard(
            blur: 0,
            child: Text('Min Blur'),
          ),
        );

        expect(find.text('Min Blur'), findsOneWidget);
      });

      testWidgets('handles maximum blur value', (tester) async {
        await pumpKruiWidget(
          tester,
          const KruiGlassyCard(
            blur: 30,
            child: Text('Max Blur'),
          ),
        );

        expect(find.text('Max Blur'), findsOneWidget);
      });

      testWidgets('handles minimum opacity', (tester) async {
        await pumpKruiWidget(
          tester,
          const KruiGlassyCard(
            opacity: 0.0,
            child: Text('Min Opacity'),
          ),
        );

        expect(find.text('Min Opacity'), findsOneWidget);
      });

      testWidgets('handles maximum opacity', (tester) async {
        await pumpKruiWidget(
          tester,
          const KruiGlassyCard(
            opacity: 1.0,
            child: Text('Max Opacity'),
          ),
        );

        expect(find.text('Max Opacity'), findsOneWidget);
      });
    });
  });
}
