import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/screens/wifi_generator/widgets/hidden_toggle.dart';

void main() {
  group('HiddenNetworkToggle', () {
    testWidgets('should display with initial value false', (WidgetTester tester) async {
      bool currentValue = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HiddenNetworkToggle(
              value: currentValue,
              onChanged: (value) {
                currentValue = value;
              },
            ),
          ),
        ),
      );

      expect(find.byType(HiddenNetworkToggle), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text('Hidden Network'), findsOneWidget);
      expect(find.text('Network SSID will be visible to devices'), findsOneWidget);
      
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, false);
    });

    testWidgets('should display with initial value true', (WidgetTester tester) async {
      bool currentValue = true;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HiddenNetworkToggle(
              value: currentValue,
              onChanged: (value) {
                currentValue = value;
              },
            ),
          ),
        ),
      );

      expect(find.text('Network SSID will not be broadcast'), findsOneWidget);
      
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, true);
    });

    testWidgets('should call onChanged when switch is tapped', (WidgetTester tester) async {
      bool currentValue = false;
      bool wasChanged = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HiddenNetworkToggle(
              value: currentValue,
              onChanged: (value) {
                currentValue = value;
                wasChanged = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(wasChanged, true);
      expect(currentValue, true);
    });

    testWidgets('should not trigger onChanged when disabled', (WidgetTester tester) async {
      bool currentValue = false;
      bool wasChanged = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HiddenNetworkToggle(
              value: currentValue,
              enabled: false,
              onChanged: (value) {
                currentValue = value;
                wasChanged = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(wasChanged, false);
      expect(currentValue, false);
    });

    testWidgets('should show correct icon for hidden state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HiddenNetworkToggle(
              value: true,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('should show correct icon for visible state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HiddenNetworkToggle(
              value: false,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });
  });

  group('HiddenNetworkToggleCompact', () {
    testWidgets('should display with initial value false', (WidgetTester tester) async {
      bool currentValue = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HiddenNetworkToggleCompact(
              value: currentValue,
              onChanged: (value) {
                currentValue = value;
              },
            ),
          ),
        ),
      );

      expect(find.byType(HiddenNetworkToggleCompact), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text('Hidden Network'), findsOneWidget);
      expect(find.text('SSID visible'), findsOneWidget);
    });

    testWidgets('should display with initial value true', (WidgetTester tester) async {
      bool currentValue = true;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HiddenNetworkToggleCompact(
              value: currentValue,
              onChanged: (value) {
                currentValue = value;
              },
            ),
          ),
        ),
      );

      expect(find.text('SSID not broadcast'), findsOneWidget);
      
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, true);
    });

    testWidgets('should call onChanged when tapped', (WidgetTester tester) async {
      bool currentValue = false;
      bool wasChanged = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HiddenNetworkToggleCompact(
              value: currentValue,
              onChanged: (value) {
                currentValue = value;
                wasChanged = true;
              },
            ),
          ),
        ),
      );

      // Tap on the InkWell area instead of just the switch
      await tester.tap(find.byType(HiddenNetworkToggleCompact));
      await tester.pumpAndSettle();

      expect(wasChanged, true);
      expect(currentValue, true);
    });

    testWidgets('should not trigger onChanged when disabled', (WidgetTester tester) async {
      bool currentValue = false;
      bool wasChanged = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HiddenNetworkToggleCompact(
              value: currentValue,
              enabled: false,
              onChanged: (value) {
                currentValue = value;
                wasChanged = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(HiddenNetworkToggleCompact));
      await tester.pumpAndSettle();

      expect(wasChanged, false);
      expect(currentValue, false);
    });
  });
}
