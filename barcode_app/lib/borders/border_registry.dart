import 'package:flutter/material.dart';
import 'base_border.dart';
import 'borders/classic_border.dart';
import 'borders/minimal_border.dart';
import 'borders/rounded_border.dart';
import 'borders/ornate_border.dart';
import 'borders/geometric_border.dart';
import 'borders/gradient_border.dart';
import 'borders/shadow_border.dart';
import 'borders/dotted_border.dart';
import 'borders/floral_border.dart';

/// Enumeration of all available border types in the application.
/// 
/// Each enum value corresponds to a specific DecorativeBorder implementation.
/// Use this enum with BorderRegistry to create border instances in a type-safe way.
enum BorderType {
  /// Classic double-frame border with elegant styling
  classic,
  
  /// Minimal clean border with thin lines
  minimal,
  
  /// Rounded corner border for modern aesthetic
  rounded,
  
  /// Ornate decorative border with embellishments
  ornate,
  
  /// Geometric patterns with angular designs
  geometric,
  
  /// Smooth gradient color transitions
  gradient,
  
  /// Border with drop shadow effects
  shadow,
  
  /// Dotted line pattern border
  dotted,
  
  /// Nature-inspired floral decorations
  floral,
}

/// Central registry for all decorative borders in the application.
/// 
/// This class provides a type-safe, immutable registry of all available border
/// types. It serves as a factory for creating border instances and provides
/// utilities for border discovery and selection.
/// 
/// Usage:
/// ```dart
/// // Get default border
/// final border = BorderRegistry.defaultBorder;
/// 
/// // Create specific border type
/// final classic = BorderRegistry.getBorder(BorderType.classic);
/// 
/// // Create with custom colors
/// final customBorder = BorderRegistry.getBorder(
///   BorderType.gradient,
///   color: Colors.blue,
///   secondaryColor: Colors.purple,
/// );
/// 
/// // List all available border types
/// final allTypes = BorderRegistry.allBorderTypes;
/// 
/// // Get border metadata
/// final name = BorderRegistry.getBorderName(BorderType.floral);
/// final desc = BorderRegistry.getBorderDescription(BorderType.floral);
/// ```
/// 
/// The registry is immutable and uses only static methods - it cannot be instantiated.
class BorderRegistry {
  // Private constructor prevents instantiation
  BorderRegistry._();

  /// Returns the default border type used throughout the application.
  /// 
  /// Currently set to [BorderType.classic] for a professional, timeless aesthetic.
  static BorderType get defaultBorderType => BorderType.classic;

  /// Creates and returns the default border with standard styling.
  /// 
  /// This is a convenience method equivalent to calling:
  /// ```dart
  /// BorderRegistry.getBorder(BorderRegistry.defaultBorderType)
  /// ```
  static DecorativeBorder get defaultBorder => getBorder(defaultBorderType);

  /// Returns a list of all available border types.
  /// 
  /// This list contains every border type defined in the [BorderType] enum,
  /// useful for building border selection UIs or iterating over all options.
  static List<BorderType> get allBorderTypes => BorderType.values;

  /// Factory method to create a border instance by type.
  /// 
  /// This is the primary method for creating borders in a type-safe manner.
  /// Parameters vary by border type - not all borders support all parameters.
  /// 
  /// Parameters:
  /// - [type]: The type of border to create (required)
  /// - [color]: Primary border color (default: Colors.black)
  /// - [secondaryColor]: Secondary color for gradients/dual-tone effects
  /// - [thickness]: Border line thickness in logical pixels
  /// - [padding]: Space between content and border
  /// - [cornerRadius]: Radius for rounded corners (0.0 = sharp)
  /// - [hasShadow]: Whether to render with shadow effect
  /// - [shadowBlur]: Shadow blur radius (only if hasShadow = true)
  /// - [shadowOpacity]: Shadow transparency (0.0 to 1.0)
  /// - [patternSpacing]: Spacing between pattern elements
  /// - [patternSize]: Size of pattern elements
  /// 
  /// Returns a fully configured [DecorativeBorder] instance ready to use.
  /// 
  /// Example:
  /// ```dart
  /// final border = BorderRegistry.getBorder(
  ///   BorderType.classic,
  ///   color: Colors.blue,
  ///   thickness: 5.0,
  /// );
  /// ```
  static DecorativeBorder getBorder(
    BorderType type, {
    Color color = Colors.black,
    Color? secondaryColor,
    double? thickness,
    double? padding,
    double? cornerRadius,
    bool? hasShadow,
    double? shadowBlur,
    double? shadowOpacity,
    double? patternSpacing,
    double? patternSize,
  }) {
    switch (type) {
      case BorderType.classic:
        return ClassicBorder(
          color: color,
          secondaryColor: secondaryColor,
          thickness: thickness ?? 3.0,
          padding: padding ?? 20.0,
          cornerRadius: cornerRadius ?? 0.0,
          hasShadow: hasShadow ?? false,
          shadowBlur: shadowBlur ?? 4.0,
          shadowOpacity: shadowOpacity ?? 0.3,
        );

      case BorderType.minimal:
        return MinimalBorder(
          color: color,
          thickness: thickness ?? 1.5,
          padding: padding ?? 32.0,
          cornerRadius: cornerRadius ?? 8.0,
        );

      case BorderType.rounded:
        return RoundedBorder(
          color: color,
          secondaryColor: secondaryColor,
          thickness: thickness ?? 4.0,
          padding: padding ?? 16.0,
          cornerRadius: cornerRadius ?? 16.0,
          hasShadow: hasShadow ?? false,
          shadowBlur: shadowBlur ?? 8.0,
          shadowOpacity: shadowOpacity ?? 0.15,
          patternSpacing: patternSpacing,
          patternSize: patternSize,
        );

      case BorderType.ornate:
        return OrnateBorder(
          color: color,
          secondaryColor: secondaryColor,
          thickness: thickness ?? 5.0,
          padding: padding ?? 20.0,
          cornerRadius: cornerRadius ?? 8.0,
          hasShadow: hasShadow ?? true,
          shadowBlur: shadowBlur ?? 6.0,
          shadowOpacity: shadowOpacity ?? 0.25,
          patternSpacing: patternSpacing ?? 40.0,
          patternSize: patternSize ?? 16.0,
        );

      case BorderType.geometric:
        return GeometricBorder(
          color: color,
          secondaryColor: secondaryColor,
          thickness: thickness ?? 3.0,
          padding: padding ?? 20.0,
          cornerRadius: cornerRadius ?? 8.0,
          hasShadow: hasShadow ?? false,
        );

      case BorderType.gradient:
        return GradientBorder(
          startColor: color,
          endColor: secondaryColor ?? Colors.blue,
          thickness: thickness ?? 4.0,
          padding: padding ?? 18.0,
          cornerRadius: cornerRadius ?? 8.0,
          hasShadow: hasShadow ?? false,
          shadowBlur: shadowBlur ?? 4.0,
          shadowOpacity: shadowOpacity ?? 0.3,
        );

      case BorderType.shadow:
        return ShadowBorder(
          color: color,
          thickness: thickness ?? 2.0,
          padding: padding ?? 20.0,
          cornerRadius: cornerRadius ?? 12.0,
          hasShadow: true, // Shadow border always has shadow
          shadowBlur: shadowBlur ?? 8.0,
          shadowOpacity: shadowOpacity ?? 0.25,
        );

      case BorderType.dotted:
        return DottedBorder(
          color: color,
          secondaryColor: secondaryColor,
          thickness: thickness ?? 4.0,
          padding: padding ?? 16.0,
          cornerRadius: cornerRadius ?? 0.0,
          hasShadow: hasShadow ?? false,
          shadowBlur: shadowBlur ?? 4.0,
          shadowOpacity: shadowOpacity ?? 0.3,
          patternSpacing: patternSpacing,
          patternSize: patternSize,
        );

      case BorderType.floral:
        return FloralBorder(
          color: color,
          secondaryColor: secondaryColor,
          thickness: thickness ?? 3.0,
          padding: padding ?? 20.0,
          cornerRadius: cornerRadius ?? 4.0,
          hasShadow: hasShadow ?? false,
          shadowBlur: shadowBlur ?? 4.0,
          shadowOpacity: shadowOpacity ?? 0.2,
        );
    }
  }

  /// Creates instances of all border types with the specified styling.
  /// 
  /// This is useful for generating border galleries or selection UIs where
  /// you want to display all available options with consistent styling.
  /// 
  /// All parameters are optional and will use defaults appropriate for each type.
  /// 
  /// Example:
  /// ```dart
  /// final allBorders = BorderRegistry.createAllBorders(
  ///   color: Colors.blue,
  ///   padding: 20.0,
  /// );
  /// 
  /// // Use in a grid or list
  /// ListView.builder(
  ///   itemCount: allBorders.length,
  ///   itemBuilder: (context, index) {
  ///     final border = allBorders[index];
  ///     return border.buildThumbnail(Size(100, 100));
  ///   },
  /// );
  /// ```
  static List<DecorativeBorder> createAllBorders({
    Color color = Colors.black,
    Color? secondaryColor,
    double? thickness,
    double? padding,
    double? cornerRadius,
    bool? hasShadow,
    double? shadowBlur,
    double? shadowOpacity,
    double? patternSpacing,
    double? patternSize,
  }) {
    return allBorderTypes
        .map((type) => getBorder(
              type,
              color: color,
              secondaryColor: secondaryColor,
              thickness: thickness,
              padding: padding,
              cornerRadius: cornerRadius,
              hasShadow: hasShadow,
              shadowBlur: shadowBlur,
              shadowOpacity: shadowOpacity,
              patternSpacing: patternSpacing,
              patternSize: patternSize,
            ))
        .toList();
  }

  /// Returns the human-readable name for a border type.
  /// 
  /// This retrieves the name by creating a default instance of the border
  /// and reading its `name` property. The result is cached internally by
  /// the border instances.
  /// 
  /// Example:
  /// ```dart
  /// final name = BorderRegistry.getBorderName(BorderType.floral);
  /// print(name); // "Floral Border"
  /// ```
  static String getBorderName(BorderType type) {
    return getBorder(type).name;
  }

  /// Returns the description for a border type.
  /// 
  /// This retrieves the description by creating a default instance of the border
  /// and reading its `description` property.
  /// 
  /// Example:
  /// ```dart
  /// final desc = BorderRegistry.getBorderDescription(BorderType.floral);
  /// print(desc); // "Nature-inspired floral decorations"
  /// ```
  static String getBorderDescription(BorderType type) {
    return getBorder(type).description;
  }

  /// Attempts to find a border type by its name (case-insensitive).
  /// 
  /// This is useful when loading border preferences from storage or
  /// parsing user input. Returns null if no matching border is found.
  /// 
  /// Example:
  /// ```dart
  /// final type = BorderRegistry.getBorderTypeByName('Classic Border');
  /// if (type != null) {
  ///   final border = BorderRegistry.getBorder(type);
  /// }
  /// ```
  static BorderType? getBorderTypeByName(String name) {
    final normalizedName = name.toLowerCase().trim();
    
    for (final type in allBorderTypes) {
      if (getBorderName(type).toLowerCase() == normalizedName) {
        return type;
      }
    }
    
    return null;
  }

  /// Creates a map of border types to their display names.
  /// 
  /// Useful for building dropdown menus or selection dialogs.
  /// 
  /// Example:
  /// ```dart
  /// final nameMap = BorderRegistry.getBorderNameMap();
  /// DropdownButton<BorderType>(
  ///   items: nameMap.entries.map((entry) {
  ///     return DropdownMenuItem(
  ///       value: entry.key,
  ///       child: Text(entry.value),
  ///     );
  ///   }).toList(),
  /// );
  /// ```
  static Map<BorderType, String> getBorderNameMap() {
    return Map.fromEntries(
      allBorderTypes.map((type) => MapEntry(type, getBorderName(type))),
    );
  }

  /// Creates a map of border types to their descriptions.
  /// 
  /// Useful for building informative selection UIs with descriptions.
  /// 
  /// Example:
  /// ```dart
  /// final descMap = BorderRegistry.getBorderDescriptionMap();
  /// // Display in a list with subtitles
  /// ```
  static Map<BorderType, String> getBorderDescriptionMap() {
    return Map.fromEntries(
      allBorderTypes.map((type) => MapEntry(type, getBorderDescription(type))),
    );
  }
}
