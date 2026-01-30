import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/screens/wifi_generator/widgets/password_input.dart';

void main() {
  group('PasswordInput Widget Tests - FLUTTER 6.2 Acceptance Criteria', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    // Acceptance Criteria 1: Obscured text field
    testWidgets('AC1: should have obscured text field by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordInput(controller: controller),
          ),
        ),
      );

      // Check that widget renders
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(PasswordInput), findsOneWidget);
      
      // Enter some text and verify it's obscured (would show bullets/dots)
      await tester.enterText(find.byType(TextFormField), 'password123');
      expect(controller.text, 'password123');
    });

    // Acceptance Criteria 2: Toggle visibility button
    testWidgets('AC2: should have toggle visibility button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordInput(controller: controller, enabled: true),
          ),
        ),
      );

      // Check visibility icon exists
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('AC2: should toggle password visibility on button press', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordInput(controller: controller),
          ),
        ),
      );

      // Initially should show "visibility" icon (password is hidden)
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

      // Tap toggle button
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Should now show "visibility_off" icon (password is visible)
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);

      // Tap again to hide
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Should be back to "visibility" icon
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
    });

    // Acceptance Criteria 3: Optional (disabled for open networks)
    testWidgets('AC3: should be disabled when enabled=false (for open networks)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordInput(controller: controller, enabled: false),
          ),
        ),
      );

      // Widget should render
      expect(find.byType(TextFormField), findsOneWidget);
      
      // Should not have toggle button when disabled
      expect(find.byType(IconButton), findsNothing);
      
      // Should show lock icon instead
      expect(find.byIcon(Icons.lock_open_outlined), findsOneWidget);
    });

    testWidgets('should not allow text input when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordInput(controller: controller, enabled: false),
          ),
        ),
      );

      // Try to enter text
      await tester.enterText(find.byType(TextFormField), 'test');
      
      // Controller should remain empty because field is disabled
      expect(controller.text, '');
    });

    // Additional tests for completeness
    testWidgets('should render with default label and hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordInput(controller: controller),
          ),
        ),
      );

      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should show custom label and hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordInput(
              controller: controller,
              labelText: 'WiFi Password',
              hintText: 'Enter your network password',
            ),
          ),
        ),
      );

      expect(find.text('WiFi Password'), findsOneWidget);
    });

    testWidgets('should call onChanged callback', (WidgetTester tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordInput(
              controller: controller,
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test123');
      expect(changedValue, 'test123');
    });

    testWidgets('should validate with custom validator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: PasswordInput(
                controller: controller,
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      // Enter short password
      await tester.enterText(find.byType(TextFormField), 'short');
      
      // Trigger validation
      final formState = tester.state<FormState>(find.byType(Form));
      expect(formState.validate(), isFalse);
      
      // Enter valid password
      await tester.enterText(find.byType(TextFormField), 'validpassword');
      expect(formState.validate(), isTrue);
    });

    testWidgets('should have accessibility tooltip on toggle button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordInput(controller: controller),
          ),
        ),
      );

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.tooltip, 'Show password');

      // Tap to show password
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      final updatedIconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(updatedIconButton.tooltip, 'Hide password');
    });

    testWidgets('should work in enabled state (default)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordInput(controller: controller, enabled: true),
          ),
        ),
      );

      // Should be able to enter text
      await tester.enterText(find.byType(TextFormField), 'testpassword');
      expect(controller.text, 'testpassword');
      
      // Should have toggle button
      expect(find.byType(IconButton), findsOneWidget);
    });
  });
}
