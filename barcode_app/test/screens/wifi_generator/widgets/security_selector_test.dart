import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/screens/wifi_generator/widgets/security_selector.dart';

void main() {
  group('SecuritySelector Widget Tests', () {
    testWidgets('displays all security type options', (WidgetTester tester) async {
      SecurityType? selectedType = SecurityType.wpa2;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecuritySelector(
              selectedSecurity: selectedType,
              onChanged: (value) {
                selectedType = value;
              },
            ),
          ),
        ),
      );

      // Tap to open dropdown
      await tester.tap(find.byType(DropdownButton<SecurityType>));
      await tester.pumpAndSettle();

      // Verify all security types are present
      expect(find.text('WPA/WPA2'), findsNWidgets(2)); // One in selected, one in dropdown
      expect(find.text('WPA3'), findsOneWidget);
      expect(find.text('WEP'), findsOneWidget);
      expect(find.text('None'), findsOneWidget);
    });

    testWidgets('defaults to WPA/WPA2', (WidgetTester tester) async {
      SecurityType selectedType = SecurityType.wpa2;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecuritySelector(
              selectedSecurity: selectedType,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Verify WPA/WPA2 is selected by default
      expect(find.text('WPA/WPA2'), findsOneWidget);
    });

    testWidgets('displays label when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecuritySelector(
              selectedSecurity: SecurityType.wpa2,
              onChanged: (value) {},
              label: 'Security Type',
            ),
          ),
        ),
      );

      expect(find.text('Security Type'), findsOneWidget);
    });

    testWidgets('can select WPA3', (WidgetTester tester) async {
      SecurityType? selectedType = SecurityType.wpa2;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SecuritySelector(
                  selectedSecurity: selectedType!,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<SecurityType>));
      await tester.pumpAndSettle();

      // Select WPA3
      await tester.tap(find.text('WPA3').last);
      await tester.pumpAndSettle();

      // Verify WPA3 is now selected
      expect(selectedType, SecurityType.wpa3);
    });

    testWidgets('can select WEP', (WidgetTester tester) async {
      SecurityType? selectedType = SecurityType.wpa2;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SecuritySelector(
                  selectedSecurity: selectedType!,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<SecurityType>));
      await tester.pumpAndSettle();

      // Select WEP
      await tester.tap(find.text('WEP').last);
      await tester.pumpAndSettle();

      // Verify WEP is now selected
      expect(selectedType, SecurityType.wep);
    });

    testWidgets('can select None', (WidgetTester tester) async {
      SecurityType? selectedType = SecurityType.wpa2;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SecuritySelector(
                  selectedSecurity: selectedType!,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<SecurityType>));
      await tester.pumpAndSettle();

      // Select None
      await tester.tap(find.text('None').last);
      await tester.pumpAndSettle();

      // Verify None is now selected
      expect(selectedType, SecurityType.none);
    });

    testWidgets('displays security icons for each type', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecuritySelector(
              selectedSecurity: SecurityType.wpa2,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Tap to open dropdown
      await tester.tap(find.byType(DropdownButton<SecurityType>));
      await tester.pumpAndSettle();

      // Verify icons are present (shield, security, lock_outline, lock_open)
      expect(find.byIcon(Icons.shield), findsWidgets);
      expect(find.byIcon(Icons.security), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.lock_open), findsOneWidget);
    });

    testWidgets('shows checkmark for selected option', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecuritySelector(
              selectedSecurity: SecurityType.wpa2,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      // Tap to open dropdown
      await tester.tap(find.byType(DropdownButton<SecurityType>));
      await tester.pumpAndSettle();

      // Verify checkmark is shown (there will be 2: one in the dropdown item and one in the selected value display)
      expect(find.byIcon(Icons.check_circle), findsAtLeastNWidgets(1));
    });

    testWidgets('shows error message when errorText is provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecuritySelector(
              selectedSecurity: SecurityType.wpa2,
              onChanged: (value) {},
              errorText: 'Please select a security type',
            ),
          ),
        ),
      );

      expect(find.text('Please select a security type'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows security hints for non-WPA2 types', (WidgetTester tester) async {
      // Test WPA3 hint
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecuritySelector(
              selectedSecurity: SecurityType.wpa3,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('Most secure option - recommended for modern devices'), findsOneWidget);
    });

    testWidgets('can be disabled', (WidgetTester tester) async {
      bool callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecuritySelector(
              selectedSecurity: SecurityType.wpa2,
              onChanged: (value) {
                callbackCalled = true;
              },
              enabled: false,
            ),
          ),
        ),
      );

      // Try to tap dropdown
      await tester.tap(find.byType(DropdownButton<SecurityType>));
      await tester.pumpAndSettle();

      // Callback should not be called
      expect(callbackCalled, false);
    });

    testWidgets('SecurityType enum has correct values', (WidgetTester tester) async {
      expect(SecurityType.wpa2.label, 'WPA/WPA2');
      expect(SecurityType.wpa2.value, 'WPAOWPA2');
      
      expect(SecurityType.wpa3.label, 'WPA3');
      expect(SecurityType.wpa3.value, 'WPA3');
      
      expect(SecurityType.wep.label, 'WEP');
      expect(SecurityType.wep.value, 'WEP');
      
      expect(SecurityType.none.label, 'None');
      expect(SecurityType.none.value, 'nopass');
    });
  });
}
