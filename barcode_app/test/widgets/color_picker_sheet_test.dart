import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/screens/customize/widgets/color_picker_sheet.dart';

void main() {
  group('ColorPickerSheet', () {
    testWidgets('renders with initial colors', (WidgetTester tester) async {
      Color? selectedPrimary;
      Color? selectedSecondary;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerSheet(
              initialPrimaryColor: Colors.red,
              initialSecondaryColor: Colors.blue,
              onColorsSelected: (primary, secondary) {
                selectedPrimary = primary;
                selectedSecondary = secondary;
              },
            ),
          ),
        ),
      );

      // Wait for the sheet to render
      await tester.pumpAndSettle();

      // Verify the sheet title exists
      expect(find.text('Select Colors'), findsOneWidget);

      // Verify tabs exist
      expect(find.text('Primary Color'), findsOneWidget);
      expect(find.text('Secondary Color'), findsOneWidget);

      // Verify preset colors section exists
      expect(find.text('Preset Colors'), findsAtLeastNWidgets(1));

      // Verify custom color picker section exists
      expect(find.text('Custom Color'), findsAtLeastNWidgets(1));

      // Verify apply button exists
      expect(find.text('Apply Colors'), findsOneWidget);
    });

    testWidgets('can switch between primary and secondary tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerSheet(
              initialPrimaryColor: Colors.red,
              initialSecondaryColor: Colors.blue,
              onColorsSelected: (primary, secondary) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on secondary color tab
      await tester.tap(find.text('Secondary Color'));
      await tester.pumpAndSettle();

      // Should still show the color picker content
      expect(find.text('Preset Colors'), findsAtLeastNWidgets(1));
    });

    testWidgets('calls onColorsSelected when apply button is tapped',
        (WidgetTester tester) async {
      Color? selectedPrimary;
      Color? selectedSecondary;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerSheet(
              initialPrimaryColor: Colors.red,
              initialSecondaryColor: Colors.blue,
              onColorsSelected: (primary, secondary) {
                selectedPrimary = primary;
                selectedSecondary = secondary;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap apply button
      await tester.tap(find.text('Apply Colors'));
      await tester.pumpAndSettle();

      // Verify callback was called with initial colors
      expect(selectedPrimary, Colors.red);
      expect(selectedSecondary, Colors.blue);
    });

    testWidgets('shows draggable handle bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerSheet(
              initialPrimaryColor: Colors.red,
              initialSecondaryColor: Colors.blue,
              onColorsSelected: (primary, secondary) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The handle bar should be rendered (checking for the container)
      // It's a visual element without specific text/icon, so we verify the sheet structure
      expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    });

    testWidgets('static show method works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ColorPickerSheet.show(
                    context: context,
                    initialPrimaryColor: Colors.red,
                    initialSecondaryColor: Colors.blue,
                    onColorsSelected: (primary, secondary) {},
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      // Tap button to open sheet
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Verify sheet is shown
      expect(find.text('Select Colors'), findsOneWidget);
    });
  });
}
