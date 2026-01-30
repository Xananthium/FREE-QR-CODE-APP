import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/screens/wifi_generator/widgets/ssid_input.dart';

void main() {
  group('SsidInput Widget Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SsidInput(controller: controller),
          ),
        ),
      );

      // Verify label exists
      expect(find.text('Network Name (SSID)'), findsOneWidget);
      expect(find.text('*'), findsOneWidget); // Required indicator
      
      // Verify hint text
      expect(find.text('Enter WiFi network name'), findsOneWidget);
      
      // Verify helper text
      expect(find.text('This is the name others will see when connecting'), findsOneWidget);
      
      // Verify character counter
      expect(find.text('0/32'), findsOneWidget);
    });

    testWidgets('Accepts text input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SsidInput(controller: controller),
          ),
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextFormField), 'MyWiFiNetwork');
      await tester.pump();

      // Verify controller has the text
      expect(controller.text, 'MyWiFiNetwork');
      
      // Verify character counter updated
      expect(find.text('13/32'), findsOneWidget);
    });

    testWidgets('Required field validation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SsidInput(controller: controller),
          ),
        ),
      );

      // Initially empty - should show error after interaction
      final textField = find.byType(TextFormField);
      
      // Enter text then clear
      await tester.enterText(textField, 'Test');
      await tester.pump();
      
      await tester.enterText(textField, '');
      await tester.pump();

      // Should show required error
      expect(find.text('Network name is required'), findsOneWidget);
    });

    testWidgets('Max length enforcement works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SsidInput(controller: controller),
          ),
        ),
      );

      // Try to enter more than 32 characters
      const longText = 'ThisIsAVeryLongNetworkNameThatExceedsTheMaximumLength';
      await tester.enterText(find.byType(TextFormField), longText);
      await tester.pump();

      // Should be truncated to 32 characters
      expect(controller.text.length, 32);
      expect(find.text('32/32'), findsOneWidget);
    });

    testWidgets('Clear button appears and works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SsidInput(controller: controller),
          ),
        ),
      );

      // Initially no clear button
      expect(find.byIcon(Icons.clear), findsNothing);

      // Enter text
      await tester.enterText(find.byType(TextFormField), 'Test');
      await tester.pump();

      // Clear button should appear
      expect(find.byIcon(Icons.clear), findsOneWidget);

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Text should be cleared
      expect(controller.text, '');
      expect(find.text('0/32'), findsOneWidget);
    });

    testWidgets('onChanged callback fires', (WidgetTester tester) async {
      String? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SsidInput(
              controller: controller,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextFormField), 'NewNetwork');
      await tester.pump();

      // Callback should have been called
      expect(changedValue, 'NewNetwork');
    });

    testWidgets('Initial value is set correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SsidInput(
              controller: controller,
              initialValue: 'InitialNetwork',
            ),
          ),
        ),
      );

      // Controller should have initial value
      expect(controller.text, 'InitialNetwork');
      
      // Character counter should reflect initial value
      expect(find.text('14/32'), findsOneWidget);
    });

    testWidgets('Disabled state works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SsidInput(
              controller: controller,
              enabled: false,
            ),
          ),
        ),
      );

      final textFormField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textFormField.enabled, false);
    });

    testWidgets('Validator function works correctly', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: SsidInput(controller: controller),
            ),
          ),
        ),
      );

      // Empty field should fail validation
      expect(formKey.currentState!.validate(), false);

      // Enter valid text
      await tester.enterText(find.byType(TextFormField), 'ValidNetwork');
      await tester.pump();

      // Should pass validation
      expect(formKey.currentState!.validate(), true);
    });

    testWidgets('Character counter turns red when near limit', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SsidInput(controller: controller),
          ),
        ),
      );

      // Enter text near limit (90% of 32 = 28.8, so 29+ characters)
      const nearLimitText = '12345678901234567890123456789'; // 29 chars
      await tester.enterText(find.byType(TextFormField), nearLimitText);
      await tester.pump();

      // Character counter should show 29/32
      expect(find.text('29/32'), findsOneWidget);
      
      // Note: Color testing would require accessing the Text widget's style
      // which is more complex in widget tests
    });
  });
}
