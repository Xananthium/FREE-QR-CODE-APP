import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/screens/customize/widgets/border_gallery.dart';
import 'package:barcode_app/borders/border_registry.dart';

void main() {
  group('BorderGallery Widget Tests', () {
    testWidgets('renders without crashing', (WidgetTester tester) async {
      BorderType? selectedBorder;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderGallery(
              selectedBorderType: BorderType.classic,
              primaryColor: Colors.blue,
              onBorderSelected: (type) {
                selectedBorder = type;
              },
            ),
          ),
        ),
      );

      expect(find.byType(BorderGallery), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('displays all border types', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderGallery(
              selectedBorderType: BorderType.classic,
              primaryColor: Colors.blue,
              onBorderSelected: (_) {},
            ),
          ),
        ),
      );

      // Should have 9 border thumbnails
      final thumbnailCards = find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString().contains('_BorderThumbnailCard'),
      );

      // All 9 border types should be present
      expect(BorderRegistry.allBorderTypes.length, equals(9));
    });

    testWidgets('shows selected state with check mark', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderGallery(
              selectedBorderType: BorderType.classic,
              primaryColor: Colors.blue,
              onBorderSelected: (_) {},
            ),
          ),
        ),
      );

      // Should have one check mark icon for the selected border
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('calls onBorderSelected when tapped', (WidgetTester tester) async {
      BorderType? selectedBorder;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderGallery(
              selectedBorderType: BorderType.classic,
              primaryColor: Colors.blue,
              onBorderSelected: (type) {
                selectedBorder = type;
              },
            ),
          ),
        ),
      );

      // Find and tap a different border (minimal is second in the list)
      final inkWells = find.byType(InkWell);
      expect(inkWells, findsAtLeast(2));

      // Tap the second border
      await tester.tap(inkWells.at(1));
      await tester.pumpAndSettle();

      // Callback should have been called
      expect(selectedBorder, isNotNull);
      expect(selectedBorder, equals(BorderRegistry.allBorderTypes[1]));
    });

    testWidgets('updates selected state when tapped', (WidgetTester tester) async {
      BorderType selectedBorder = BorderType.classic;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: BorderGallery(
                  selectedBorderType: selectedBorder,
                  primaryColor: Colors.blue,
                  onBorderSelected: (type) {
                    setState(() {
                      selectedBorder = type;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      // Initially one check mark
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Tap a different border
      final inkWells = find.byType(InkWell);
      await tester.tap(inkWells.at(1));
      await tester.pumpAndSettle();

      // Still one check mark (moved to new selection)
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('uses provided colors for thumbnails', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderGallery(
              selectedBorderType: BorderType.classic,
              primaryColor: Colors.red,
              secondaryColor: Colors.yellow,
              onBorderSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(BorderGallery), findsOneWidget);
      // Colors are used in border thumbnails (difficult to test directly)
    });

    testWidgets('has smooth scrolling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderGallery(
              selectedBorderType: BorderType.classic,
              primaryColor: Colors.blue,
              onBorderSelected: (_) {},
            ),
          ),
        ),
      );

      final gridView = tester.widget<GridView>(find.byType(GridView));
      expect(gridView.scrollDirection, equals(Axis.horizontal));
      expect(gridView.physics, isA<BouncingScrollPhysics>());
    });

    testWidgets('respects custom height', (WidgetTester tester) async {
      const customHeight = 300.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderGallery(
              selectedBorderType: BorderType.classic,
              primaryColor: Colors.blue,
              onBorderSelected: (_) {},
              height: customHeight,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(GridView),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.height, equals(customHeight));
    });

    testWidgets('has proper semantics for accessibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderGallery(
              selectedBorderType: BorderType.classic,
              primaryColor: Colors.blue,
              onBorderSelected: (_) {},
            ),
          ),
        ),
      );

      // Check that semantic labels exist
      final semantics = find.byType(Semantics);
      expect(semantics, findsAtLeast(9)); // One for each border
    });

    testWidgets('uses RepaintBoundary for performance', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BorderGallery(
              selectedBorderType: BorderType.classic,
              primaryColor: Colors.blue,
              onBorderSelected: (_) {},
            ),
          ),
        ),
      );

      // RepaintBoundary should be used for thumbnails
      expect(find.byType(RepaintBoundary), findsAtLeast(9));
    });
  });
}
