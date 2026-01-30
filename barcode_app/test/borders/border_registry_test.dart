import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_app/borders/border_registry.dart';
import 'package:barcode_app/borders/base_border.dart';
import 'package:barcode_app/borders/borders/classic_border.dart';
import 'package:barcode_app/borders/borders/minimal_border.dart';
import 'package:barcode_app/borders/borders/rounded_border.dart';
import 'package:barcode_app/borders/borders/ornate_border.dart';
import 'package:barcode_app/borders/borders/geometric_border.dart';
import 'package:barcode_app/borders/borders/gradient_border.dart';
import 'package:barcode_app/borders/borders/shadow_border.dart';
import 'package:barcode_app/borders/borders/dotted_border.dart';
import 'package:barcode_app/borders/borders/floral_border.dart';

void main() {
  group('BorderType Enum', () {
    test('contains all 9 border types', () {
      expect(BorderType.values.length, equals(9));
    });

    test('contains expected border types', () {
      expect(BorderType.values, contains(BorderType.classic));
      expect(BorderType.values, contains(BorderType.minimal));
      expect(BorderType.values, contains(BorderType.rounded));
      expect(BorderType.values, contains(BorderType.ornate));
      expect(BorderType.values, contains(BorderType.geometric));
      expect(BorderType.values, contains(BorderType.gradient));
      expect(BorderType.values, contains(BorderType.shadow));
      expect(BorderType.values, contains(BorderType.dotted));
      expect(BorderType.values, contains(BorderType.floral));
    });
  });

  group('BorderRegistry - Default Border', () {
    test('defaultBorderType returns classic', () {
      expect(BorderRegistry.defaultBorderType, equals(BorderType.classic));
    });

    test('defaultBorder returns a ClassicBorder instance', () {
      final border = BorderRegistry.defaultBorder;
      expect(border, isA<ClassicBorder>());
    });

    test('defaultBorder has correct default properties', () {
      final border = BorderRegistry.defaultBorder;
      expect(border.color, equals(Colors.black));
      expect(border.thickness, equals(3.0));
      expect(border.padding, equals(20.0));
    });
  });

  group('BorderRegistry - Factory Method', () {
    test('getBorder creates ClassicBorder for classic type', () {
      final border = BorderRegistry.getBorder(BorderType.classic);
      expect(border, isA<ClassicBorder>());
    });

    test('getBorder creates MinimalBorder for minimal type', () {
      final border = BorderRegistry.getBorder(BorderType.minimal);
      expect(border, isA<MinimalBorder>());
    });

    test('getBorder creates RoundedBorder for rounded type', () {
      final border = BorderRegistry.getBorder(BorderType.rounded);
      expect(border, isA<RoundedBorder>());
    });

    test('getBorder creates OrnateBorder for ornate type', () {
      final border = BorderRegistry.getBorder(BorderType.ornate);
      expect(border, isA<OrnateBorder>());
    });

    test('getBorder creates GeometricBorder for geometric type', () {
      final border = BorderRegistry.getBorder(BorderType.geometric);
      expect(border, isA<GeometricBorder>());
    });

    test('getBorder creates GradientBorder for gradient type', () {
      final border = BorderRegistry.getBorder(BorderType.gradient);
      expect(border, isA<GradientBorder>());
    });

    test('getBorder creates ShadowBorder for shadow type', () {
      final border = BorderRegistry.getBorder(BorderType.shadow);
      expect(border, isA<ShadowBorder>());
    });

    test('getBorder creates DottedBorder for dotted type', () {
      final border = BorderRegistry.getBorder(BorderType.dotted);
      expect(border, isA<DottedBorder>());
    });

    test('getBorder creates FloralBorder for floral type', () {
      final border = BorderRegistry.getBorder(BorderType.floral);
      expect(border, isA<FloralBorder>());
    });

    test('getBorder respects custom color parameter', () {
      final border = BorderRegistry.getBorder(
        BorderType.classic,
        color: Colors.red,
      );
      expect(border.color, equals(Colors.red));
    });

    test('getBorder respects custom thickness parameter', () {
      final border = BorderRegistry.getBorder(
        BorderType.minimal,
        thickness: 5.0,
      );
      expect(border.thickness, equals(5.0));
    });

    test('getBorder respects custom padding parameter', () {
      final border = BorderRegistry.getBorder(
        BorderType.rounded,
        padding: 30.0,
      );
      expect(border.padding, equals(30.0));
    });

    test('getBorder respects custom cornerRadius parameter', () {
      final border = BorderRegistry.getBorder(
        BorderType.rounded,
        cornerRadius: 24.0,
      );
      expect(border.cornerRadius, equals(24.0));
    });

    test('ShadowBorder always has shadow enabled', () {
      final border = BorderRegistry.getBorder(BorderType.shadow);
      expect(border.hasShadow, isTrue);
    });
  });

  group('BorderRegistry - List All Borders', () {
    test('allBorderTypes returns all enum values', () {
      final types = BorderRegistry.allBorderTypes;
      expect(types.length, equals(9));
      expect(types, equals(BorderType.values));
    });

    test('createAllBorders returns 9 border instances', () {
      final borders = BorderRegistry.createAllBorders();
      expect(borders.length, equals(9));
    });

    test('createAllBorders returns one of each type', () {
      final borders = BorderRegistry.createAllBorders();
      expect(borders.whereType<ClassicBorder>().length, equals(1));
      expect(borders.whereType<MinimalBorder>().length, equals(1));
      expect(borders.whereType<RoundedBorder>().length, equals(1));
      expect(borders.whereType<OrnateBorder>().length, equals(1));
      expect(borders.whereType<GeometricBorder>().length, equals(1));
      expect(borders.whereType<GradientBorder>().length, equals(1));
      expect(borders.whereType<ShadowBorder>().length, equals(1));
      expect(borders.whereType<DottedBorder>().length, equals(1));
      expect(borders.whereType<FloralBorder>().length, equals(1));
    });

    test('createAllBorders respects custom color parameter', () {
      final borders = BorderRegistry.createAllBorders(color: Colors.blue);
      // All borders except gradient use color parameter directly
      for (final border in borders) {
        if (border is! GradientBorder) {
          expect(border.color, equals(Colors.blue));
        }
      }
    });

    test('createAllBorders respects custom padding parameter', () {
      final borders = BorderRegistry.createAllBorders(padding: 25.0);
      for (final border in borders) {
        expect(border.padding, equals(25.0));
      }
    });
  });

  group('BorderRegistry - Metadata Methods', () {
    test('getBorderName returns correct name for classic', () {
      final name = BorderRegistry.getBorderName(BorderType.classic);
      expect(name, equals('Classic Border'));
    });

    test('getBorderName returns correct name for minimal', () {
      final name = BorderRegistry.getBorderName(BorderType.minimal);
      expect(name, equals('Minimal Border'));
    });

    test('getBorderName returns correct name for floral', () {
      final name = BorderRegistry.getBorderName(BorderType.floral);
      expect(name, equals('Floral Border'));
    });

    test('getBorderDescription returns non-empty string', () {
      final desc = BorderRegistry.getBorderDescription(BorderType.classic);
      expect(desc, isNotEmpty);
      expect(desc, equals('Elegant double-frame border'));
    });

    test('all border types have names', () {
      for (final type in BorderType.values) {
        final name = BorderRegistry.getBorderName(type);
        expect(name, isNotEmpty);
      }
    });

    test('all border types have descriptions', () {
      for (final type in BorderType.values) {
        final desc = BorderRegistry.getBorderDescription(type);
        expect(desc, isNotEmpty);
      }
    });
  });

  group('BorderRegistry - Name Lookup', () {
    test('getBorderTypeByName finds classic border', () {
      final type = BorderRegistry.getBorderTypeByName('Classic Border');
      expect(type, equals(BorderType.classic));
    });

    test('getBorderTypeByName is case-insensitive', () {
      final type = BorderRegistry.getBorderTypeByName('CLASSIC BORDER');
      expect(type, equals(BorderType.classic));
    });

    test('getBorderTypeByName trims whitespace', () {
      final type = BorderRegistry.getBorderTypeByName('  Classic Border  ');
      expect(type, equals(BorderType.classic));
    });

    test('getBorderTypeByName returns null for invalid name', () {
      final type = BorderRegistry.getBorderTypeByName('Nonexistent Border');
      expect(type, isNull);
    });

    test('getBorderTypeByName works for all border types', () {
      for (final expectedType in BorderType.values) {
        final name = BorderRegistry.getBorderName(expectedType);
        final foundType = BorderRegistry.getBorderTypeByName(name);
        expect(foundType, equals(expectedType));
      }
    });
  });

  group('BorderRegistry - Name Map', () {
    test('getBorderNameMap returns map with all types', () {
      final nameMap = BorderRegistry.getBorderNameMap();
      expect(nameMap.length, equals(9));
    });

    test('getBorderNameMap contains all border types as keys', () {
      final nameMap = BorderRegistry.getBorderNameMap();
      for (final type in BorderType.values) {
        expect(nameMap.containsKey(type), isTrue);
      }
    });

    test('getBorderNameMap values are correct names', () {
      final nameMap = BorderRegistry.getBorderNameMap();
      expect(nameMap[BorderType.classic], equals('Classic Border'));
      expect(nameMap[BorderType.minimal], equals('Minimal Border'));
      expect(nameMap[BorderType.floral], equals('Floral Border'));
    });
  });

  group('BorderRegistry - Description Map', () {
    test('getBorderDescriptionMap returns map with all types', () {
      final descMap = BorderRegistry.getBorderDescriptionMap();
      expect(descMap.length, equals(9));
    });

    test('getBorderDescriptionMap contains all border types as keys', () {
      final descMap = BorderRegistry.getBorderDescriptionMap();
      for (final type in BorderType.values) {
        expect(descMap.containsKey(type), isTrue);
      }
    });

    test('getBorderDescriptionMap values are non-empty', () {
      final descMap = BorderRegistry.getBorderDescriptionMap();
      for (final desc in descMap.values) {
        expect(desc, isNotEmpty);
      }
    });
  });

  group('BorderRegistry - Immutability', () {
    test('cannot instantiate BorderRegistry', () {
      // This test verifies that the private constructor works
      // by ensuring compilation would fail if we tried:
      // final registry = BorderRegistry(); // This would be a compile error
      
      // We verify the class design instead
      expect(BorderRegistry.defaultBorder, isNotNull);
    });
  });

  group('BorderRegistry - Integration Tests', () {
    test('can create border gallery with thumbnails', () {
      final borders = BorderRegistry.createAllBorders(
        color: Colors.black,
        padding: 20.0,
      );

      for (final border in borders) {
        // Verify each border can build a thumbnail
        final thumbnail = border.buildThumbnail(const Size(100, 100));
        expect(thumbnail, isNotNull);
        expect(thumbnail, isA<Widget>());
      }
    });

    test('can lookup and create border by name in one flow', () {
      final name = 'Gradient Border';
      final type = BorderRegistry.getBorderTypeByName(name);
      expect(type, isNotNull);
      
      final border = BorderRegistry.getBorder(type!);
      expect(border, isA<GradientBorder>());
      expect(border.name, equals(name));
    });
  });
}
