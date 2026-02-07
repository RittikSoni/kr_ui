import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kr_ui/kr_ui.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('KruiCheckbox', () {
    testWidgets('renders checked state', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiCheckbox(
          value: true,
          onChanged: (_) {},
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('renders unchecked state', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiCheckbox(
          value: false,
          onChanged: (_) {},
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isFalse);
    });

    testWidgets('toggles on tap', (tester) async {
      var currentValue = false;

      await pumpKruiWidget(
        tester,
        StatefulBuilder(
          builder: (context, setState) {
            return KruiCheckbox(
              value: currentValue,
              onChanged: (val) {
                setState(() => currentValue = val ?? false);
              },
            );
          },
        ),
      );

      // Tap to check
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(currentValue, isTrue);
    });

    testWidgets('calls onChange callback', (tester) async {
      bool? changedValue;

      await pumpKruiWidget(
        tester,
        KruiCheckbox(
          value: false,
          onChanged: (val) => changedValue = val,
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(changedValue, isTrue);
    });

    testWidgets('disabled state prevents interaction', (tester) async {
      var tapped = false;

      await pumpKruiWidget(
        tester,
        KruiCheckbox(
          value: false,
          onChanged: (_) => tapped = true,
          enabled: false,
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('displays label text', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiCheckbox(
          value: false,
          onChanged: (_) {},
          label: 'Accept terms',
        ),
      );

      expect(find.text('Accept terms'), findsOneWidget);
    });

    testWidgets('displays subtitle text', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiCheckbox(
          value: false,
          onChanged: (_) {},
          label: 'Subscribe',
          subtitle: 'Receive newsletter updates',
        ),
      );

      expect(find.text('Subscribe'), findsOneWidget);
      expect(find.text('Receive newsletter updates'), findsOneWidget);
    });

    testWidgets('leading checkbox position', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiCheckbox(
          value: false,
          onChanged: (_) {},
          label: 'Option',
          checkboxPosition: KruiCheckboxPosition.leading,
        ),
      );

      expect(find.text('Option'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('trailing checkbox position', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiCheckbox(
          value: false,
          onChanged: (_) {},
          label: 'Option',
          checkboxPosition: KruiCheckboxPosition.trailing,
        ),
      );

      expect(find.text('Option'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('custom active color', (tester) async {
      await pumpKruiWidget(
        tester,
        KruiCheckbox(
          value: true,
          onChanged: (_) {},
          activeColor: Colors.red,
        ),
      );

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.activeColor, Colors.red);
    });

    testWidgets('label link is tappable', (tester) async {
      var linkTapped = false;

      await pumpKruiWidget(
        tester,
        KruiCheckbox(
          value: false,
          onChanged: (_) {},
          label: 'I agree to the Terms and Conditions',
          labelLinkText: 'Terms and Conditions',
          onLabelLinkTap: () => linkTapped = true,
        ),
      );

      // Find and tap the TextSpan link directly by tapping the RichText
      final richTextFinder = find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('Terms and Conditions'),
      );

      expect(richTextFinder, findsOneWidget);

      await tester.tap(richTextFinder);
      await tester.pump();

      expect(linkTapped, isTrue);
    });
  });
}
