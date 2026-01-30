import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/models/export_options.dart';
import 'package:barcode_app/screens/export/widgets/resolution_picker.dart';

void main() {
  group('ResolutionPicker', () {
    testWidgets('displays all resolution options', (WidgetTester tester) async {
      ExportResolution? selectedResolution = ExportResolution.medium;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResolutionPicker(
              selectedResolution: selectedResolution,
              onChanged: (value) {
                selectedResolution = value;
              },
            ),
          ),
        ),
      );

      // Verify all resolutions are displayed
      expect(find.text('Small'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Large'), findsOneWidget);
      expect(find.text('Extra'), findsOneWidget);

      // Verify pixel dimensions are shown
      expect(find.text('512×512 px'), findsOneWidget);
      expect(find.text('1024×1024 px'), findsOneWidget);
      expect(find.text('2048×2048 px'), findsOneWidget);
      expect(find.text('4096×4096 px'), findsOneWidget);
    });

    testWidgets('displays medium as default selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResolutionPicker(
              selectedResolution: ExportResolution.medium,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Check that medium is selected (check icon should be present for medium)
      final checkIcons = find.byIcon(Icons.check_circle);
      expect(checkIcons, findsOneWidget);
    });

    testWidgets('calls onChanged when resolution is tapped', (WidgetTester tester) async {
      ExportResolution selectedResolution = ExportResolution.medium;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ResolutionPicker(
                  selectedResolution: selectedResolution,
                  onChanged: (value) {
                    setState(() {
                      selectedResolution = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Initially medium is selected
      expect(selectedResolution, ExportResolution.medium);

      // Tap on Large resolution
      await tester.tap(find.text('Large'));
      await tester.pumpAndSettle();

      // Verify selection changed to large
      expect(selectedResolution, ExportResolution.large);
    });

    testWidgets('displays optional label when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResolutionPicker(
              selectedResolution: ExportResolution.medium,
              onChanged: (value) {},
              label: 'Export Resolution',
            ),
          ),
        ),
      );

      expect(find.text('Export Resolution'), findsOneWidget);
    });

    testWidgets('does not display label when not provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResolutionPicker(
              selectedResolution: ExportResolution.medium,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Only resolution names should be present, no separate label
      expect(find.text('Small'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
    });

    testWidgets('shows appropriate hint text for each resolution', (WidgetTester tester) async {
      ExportResolution selectedResolution = ExportResolution.small;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ResolutionPicker(
                  selectedResolution: selectedResolution,
                  onChanged: (value) {
                    setState(() {
                      selectedResolution = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Check hint for small resolution
      expect(find.text('Best for quick sharing and web use'), findsOneWidget);

      // Change to medium
      await tester.tap(find.text('Medium'));
      await tester.pumpAndSettle();

      // Check hint for medium resolution
      expect(find.text('Recommended for most uses'), findsOneWidget);

      // Change to large
      await tester.tap(find.text('Large'));
      await tester.pumpAndSettle();

      // Check hint for large resolution
      expect(find.text('High quality for print and detailed scanning'), findsOneWidget);

      // Change to extra large
      await tester.tap(find.text('Extra'));
      await tester.pumpAndSettle();

      // Check hint for extra large resolution
      expect(find.text('Maximum quality for professional printing'), findsOneWidget);
    });

    testWidgets('does not call onChanged when disabled', (WidgetTester tester) async {
      ExportResolution selectedResolution = ExportResolution.medium;
      var callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResolutionPicker(
              selectedResolution: selectedResolution,
              onChanged: (value) {
                callbackCalled = true;
              },
              enabled: false,
            ),
          ),
        ),
      );

      // Try to tap on Large resolution
      await tester.tap(find.text('Large'));
      await tester.pumpAndSettle();

      // Verify callback was not called
      expect(callbackCalled, false);
      expect(selectedResolution, ExportResolution.medium);
    });

    testWidgets('displays all resolution icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResolutionPicker(
              selectedResolution: ExportResolution.medium,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Verify resolution icons are present
      expect(find.byIcon(Icons.photo_size_select_small), findsOneWidget);
      expect(find.byIcon(Icons.photo_size_select_large), findsOneWidget);
      expect(find.byIcon(Icons.photo_size_select_actual), findsOneWidget);
      expect(find.byIcon(Icons.high_quality), findsOneWidget);
    });
  });
}
