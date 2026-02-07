import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kr_ui/kr_ui.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('KruiTextField', () {
    testWidgets('renders with label', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiTextField(
          name: 'email',
          label: 'Email Address',
        ),
      );

      expect(find.text('Email Address'), findsOneWidget);
    });

    testWidgets('accepts text input', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiTextField(
          name: 'username',
          label: 'Username',
        ),
      );

      await tester.enterText(find.byType(TextField), 'john_doe');
      expect(find.text('john_doe'), findsOneWidget);
    });

    testWidgets('shows hint text', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiTextField(
          name: 'phone',
          label: 'Phone',
          hint: 'Enter your phone number',
        ),
      );

      expect(find.text('Enter your phone number'), findsOneWidget);
    });

    testWidgets('controller integration works', (tester) async {
      final controller = TextEditingController();

      await pumpKruiWidget(
        tester,
        KruiTextField(
          name: 'test',
          label: 'Test',
          controller: controller,
        ),
      );

      controller.text = 'Test Value';
      await tester.pump();

      expect(find.text('Test Value'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('controller sets initial value', (tester) async {
      final controller = TextEditingController(text: 'test@example.com');

      await pumpKruiWidget(
        tester,
        KruiTextField(
          name: 'email',
          label: 'Email',
          controller: controller,
        ),
      );

      expect(find.text('test@example.com'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('disabled state prevents input', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiTextField(
          name: 'disabled',
          label: 'Disabled Field',
          enabled: false,
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('obscure text for password field', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiTextField(
          name: 'password',
          label: 'Password',
          obscureText: true,
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets('prefix icon displays correctly', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiTextField(
          name: 'search',
          label: 'Search',
          prefixIcon: Icon(Icons.search),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('suffix icon displays correctly', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiTextField(
          name: 'password',
          label: 'Password',
          suffixIcon: Icon(Icons.visibility),
        ),
      );

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('max length enforcement', (tester) async {
      await pumpKruiWidget(
        tester,
        const KruiTextField(
          name: 'code',
          label: 'Code',
          maxLength: 6,
        ),
      );

      await tester.enterText(find.byType(TextField), '1234567890');
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLength, 6);
    });

    testWidgets('email validation type', (tester) async {
      const testField = KruiTextField(
        name: 'email',
        label: 'Email',
        validation: KruiTextFieldValidation.email,
      );

      // Valid email
      final validResult = testField.validate('test@example.com');
      expect(validResult, isNull);

      // Invalid email
      final invalidResult = testField.validate('invalid-email');
      expect(invalidResult, isNotNull);
    });

    testWidgets('password validation type', (tester) async {
      final testField = KruiTextField(
        name: 'password',
        label: 'Password',
        validation: KruiTextFieldValidation.password,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          if (value.length < 8) {
            return 'Password must be at least 8 characters';
          }
          return null;
        },
      );

      // Valid password (8+ chars)
      final validResult = testField.validate('password123');
      expect(validResult, isNull);

      // Invalid password (too short)
      final invalidResult = testField.validate('pass');
      expect(invalidResult, isNotNull);
    });

    testWidgets('custom validator function', (tester) async {
      final testField = KruiTextField(
        name: 'username',
        label: 'Username',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Username is required';
          }
          if (value.length < 3) {
            return 'Username must be at least 3 characters';
          }
          return null;
        },
      );

      expect(testField.validate('ab'), isNotNull);
      expect(testField.validate('abc'), isNull);
    });
  });
}
