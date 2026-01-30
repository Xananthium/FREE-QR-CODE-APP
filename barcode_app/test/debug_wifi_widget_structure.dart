import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:barcode_app/screens/wifi_generator_screen.dart';
import 'package:barcode_app/providers/qr_provider.dart';

void main() {
  testWidgets('debug WiFi widget structure', (WidgetTester tester) async {
    final qrProvider = QRProvider();
    
    await tester.pumpWidget(
      ChangeNotifierProvider<QRProvider>.value(
        value: qrProvider,
        child: MaterialApp(
          home: Scaffold(
            body: const WifiGeneratorScreen(),
          ),
        ),
      ),
    );
    
    await tester.pumpAndSettle();
    
    // Print all widgets
    debugPrint('\n=== ALL TEXTFORMFIELD WIDGETS ===');
    final textFields = find.byType(TextFormField);
    debugPrint('Found ${textFields.evaluate().length} TextFormField widgets');
    
    for (int i = 0; i < textFields.evaluate().length; i++) {
      final widget = tester.widget<TextFormField>(textFields.at(i));
      debugPrint('TextFormField $i: hint=${widget.decoration?.hintText}');
    }
    
    debugPrint('\n=== ALL BUTTONS ===');
    final buttons = find.byType(ElevatedButton);
    debugPrint('Found ${buttons.evaluate().length} ElevatedButton widgets');
    
    debugPrint('\n=== ALL TEXT WIDGETS WITH "Network" ===');
    final networkTexts = find.textContaining('Network', findRichText: true);
    debugPrint('Found ${networkTexts.evaluate().length} widgets with "Network"');
  });
}
