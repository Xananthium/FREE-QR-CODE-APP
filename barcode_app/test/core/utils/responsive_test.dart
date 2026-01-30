import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/core/utils/responsive.dart';

void main() {
  group('Breakpoints', () {
    test('should define correct breakpoint values', () {
      expect(Breakpoints.small, 600);
      expect(Breakpoints.medium, 1200);
      expect(Breakpoints.large, 1200);
      expect(Breakpoints.extraLarge, 1600);
    });
  });

  group('Responsive', () {
    testWidgets('should identify phone screen correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final responsive = Responsive(context);
              expect(responsive.isPhone, true);
              expect(responsive.isTablet, false);
              expect(responsive.isDesktop, false);
              expect(responsive.deviceType, DeviceType.phone);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should provide correct responsive values for phone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final responsive = Responsive(context);
              
              // Test value selector
              final value = responsive.value(
                phone: 16.0,
                tablet: 24.0,
                desktop: 32.0,
              );
              expect(value, 16.0);
              
              // Test grid columns
              expect(responsive.gridColumns, 1);
              
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should provide correct responsive padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final responsive = Responsive(context);
              
              // Test horizontal padding
              expect(responsive.horizontalPadding.horizontal, 32.0); // 16*2
              
              // Test padding
              expect(responsive.padding.top, 16.0);
              
              // Test spacing
              expect(responsive.spacing, 8.0);
              expect(responsive.cardSpacing, 16.0);
              
              return Container();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveExtension', () {
    testWidgets('should provide context extension', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final responsive = context.responsive;
              expect(responsive, isA<Responsive>());
              return Container();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveBuilder', () {
    testWidgets('should build with correct device type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveBuilder(
            builder: (context, deviceType) {
              expect(deviceType, DeviceType.phone);
              return const Text('Phone');
            },
          ),
        ),
      );
      
      expect(find.text('Phone'), findsOneWidget);
    });
  });

  group('ResponsiveLayout', () {
    testWidgets('should show phone layout on small screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveLayout(
            phone: Text('Phone Layout'),
            tablet: Text('Tablet Layout'),
            desktop: Text('Desktop Layout'),
          ),
        ),
      );
      
      expect(find.text('Phone Layout'), findsOneWidget);
      expect(find.text('Tablet Layout'), findsNothing);
      expect(find.text('Desktop Layout'), findsNothing);
    });
  });

  group('ResponsiveCenter', () {
    testWidgets('should constrain content width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveCenter(
            child: Text('Centered Content'),
          ),
        ),
      );
      
      expect(find.text('Centered Content'), findsOneWidget);
      expect(find.byType(ConstrainedBox), findsOneWidget);
    });
  });

  group('ResponsiveRowColumn', () {
    testWidgets('should render as column on phone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveRowColumn(
            children: [
              const Text('Item 1'),
              const Text('Item 2'),
            ],
          ),
        ),
      );
      
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });
  });

  group('Responsive screen size simulation', () {
    testWidgets('tablet size detection', (tester) async {
      // Set tablet screen size
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final responsive = Responsive(context);
              expect(responsive.isTablet, true);
              expect(responsive.isPhone, false);
              expect(responsive.deviceType, DeviceType.tablet);
              
              // Test grid columns for tablet
              expect(responsive.gridColumns, 2);
              
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('desktop size detection', (tester) async {
      // Set desktop screen size
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final responsive = Responsive(context);
              expect(responsive.isDesktop, true);
              expect(responsive.isPhone, false);
              expect(responsive.isTablet, false);
              expect(responsive.deviceType, DeviceType.desktop);
              
              // Test grid columns for desktop
              expect(responsive.gridColumns, 3);
              
              return Container();
            },
          ),
        ),
      );
    });
  });
}
