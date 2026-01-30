import 'package:flutter/material.dart';

/// Enum representing different border/frame styles for QR codes
enum BorderType {
  // Basic styles
  none,
  solid,
  dashed,
  dotted,
  double,
  
  // Rounded variations
  lightRounded,
  mediumRounded,
  heavyRounded,
  
  // Geometric shapes
  circle,
  roundedSquare,
  shield,
  badge,
  hexagon,
  octagon,
  diamond,
  star,
  heart,
  
  // Decorative styles
  vintage,
  baroque,
  artDeco,
  minimal,
  modern,
  retro,
  classic,
  elegant,
  
  // Corner styles
  cutCorners,
  ornateCorners,
  fanCorners,
  roundedCorners,
  chamferedCorners,
  
  // Themed styles
  tech,
  digital,
  nature,
  floral,
  geometric,
  abstract,
  playful,
  professional,
  casual,
  formal,
  
  // Pattern styles
  dottedPattern,
  stripedPattern,
  wavyPattern,
  zigzagPattern,
  checkeredPattern,
  dashedPattern,
  crosshatch,
  
  // Special effects
  neon,
  gradient,
  threeD,
  embossed,
  outlined,
  inset,
  raised,
  shadow,
  glow,
  
  // Additional creative styles
  polaroid,
  filmStrip,
  stamp,
  ticket,
  certificate,
  postcard,
}

/// Immutable model representing border/frame styling for QR codes
@immutable
class BorderStyle {
  /// The type/preset of border style
  final BorderType type;
  
  /// Primary border color
  final Color color;
  
  /// Border thickness/width in logical pixels
  final double thickness;
  
  /// Padding between QR code and border in logical pixels
  final double padding;
  
  /// Corner radius for rounded styles (0 = sharp corners)
  final double cornerRadius;
  
  /// Whether the border has a shadow effect
  final bool hasShadow;
  
  /// Shadow blur radius (only applies if hasShadow is true)
  final double shadowBlur;
  
  /// Shadow opacity (0.0 to 1.0, only applies if hasShadow is true)
  final double shadowOpacity;
  
  /// Secondary color for gradient/multi-color borders (optional)
  final Color? secondaryColor;
  
  /// Pattern spacing for patterned borders (e.g., dash spacing)
  final double? patternSpacing;
  
  /// Pattern size for patterned borders (e.g., dot size)
  final double? patternSize;

  const BorderStyle({
    required this.type,
    required this.color,
    this.thickness = 4.0,
    this.padding = 16.0,
    this.cornerRadius = 0.0,
    this.hasShadow = false,
    this.shadowBlur = 4.0,
    this.shadowOpacity = 0.3,
    this.secondaryColor,
    this.patternSpacing,
    this.patternSize,
  });

  /// Factory: No border
  factory BorderStyle.none() {
    return const BorderStyle(
      type: BorderType.none,
      color: Colors.transparent,
      thickness: 0.0,
      padding: 0.0,
    );
  }

  /// Factory: Simple solid border
  factory BorderStyle.simple({
    Color color = Colors.black,
    double thickness = 4.0,
    double padding = 16.0,
  }) {
    return BorderStyle(
      type: BorderType.solid,
      color: color,
      thickness: thickness,
      padding: padding,
    );
  }

  /// Factory: Rounded border
  factory BorderStyle.rounded({
    Color color = Colors.black,
    double thickness = 4.0,
    double padding = 16.0,
    double cornerRadius = 12.0,
  }) {
    return BorderStyle(
      type: BorderType.mediumRounded,
      color: color,
      thickness: thickness,
      padding: padding,
      cornerRadius: cornerRadius,
    );
  }

  /// Factory: Circle border
  factory BorderStyle.circle({
    Color color = Colors.black,
    double thickness = 4.0,
    double padding = 20.0,
  }) {
    return BorderStyle(
      type: BorderType.circle,
      color: color,
      thickness: thickness,
      padding: padding,
      cornerRadius: 9999.0, // Very large radius creates circle
    );
  }

  /// Factory: Create from preset border type with default styling
  factory BorderStyle.preset(BorderType type, {Color? color}) {
    final borderColor = color ?? Colors.black;
    
    switch (type) {
      case BorderType.none:
        return BorderStyle.none();
      
      case BorderType.solid:
        return BorderStyle.simple(color: borderColor);
      
      case BorderType.circle:
        return BorderStyle.circle(color: borderColor);
      
      case BorderType.mediumRounded:
        return BorderStyle.rounded(color: borderColor);
      
      case BorderType.lightRounded:
        return BorderStyle.rounded(
          color: borderColor,
          cornerRadius: 6.0,
        );
      
      case BorderType.heavyRounded:
        return BorderStyle.rounded(
          color: borderColor,
          cornerRadius: 24.0,
        );
      
      case BorderType.neon:
        return BorderStyle(
          type: BorderType.neon,
          color: borderColor,
          thickness: 3.0,
          padding: 20.0,
          cornerRadius: 8.0,
          hasShadow: true,
          shadowBlur: 12.0,
          shadowOpacity: 0.8,
        );
      
      case BorderType.shadow:
        return BorderStyle(
          type: BorderType.shadow,
          color: borderColor,
          thickness: 4.0,
          padding: 16.0,
          cornerRadius: 4.0,
          hasShadow: true,
          shadowBlur: 8.0,
          shadowOpacity: 0.4,
        );
      
      case BorderType.dashed:
      case BorderType.dashedPattern:
        return BorderStyle(
          type: type,
          color: borderColor,
          thickness: 4.0,
          padding: 16.0,
          patternSpacing: 8.0,
        );
      
      case BorderType.dotted:
      case BorderType.dottedPattern:
        return BorderStyle(
          type: type,
          color: borderColor,
          thickness: 4.0,
          padding: 16.0,
          patternSpacing: 6.0,
          patternSize: 3.0,
        );
      
      case BorderType.vintage:
        return BorderStyle(
          type: BorderType.vintage,
          color: borderColor,
          thickness: 6.0,
          padding: 20.0,
          cornerRadius: 4.0,
        );
      
      case BorderType.modern:
        return BorderStyle(
          type: BorderType.modern,
          color: borderColor,
          thickness: 2.0,
          padding: 12.0,
          cornerRadius: 0.0,
        );
      
      default:
        return BorderStyle(
          type: type,
          color: borderColor,
          thickness: 4.0,
          padding: 16.0,
        );
    }
  }

  /// Creates a copy of this BorderStyle with the given fields replaced
  BorderStyle copyWith({
    BorderType? type,
    Color? color,
    double? thickness,
    double? padding,
    double? cornerRadius,
    bool? hasShadow,
    double? shadowBlur,
    double? shadowOpacity,
    Color? secondaryColor,
    double? patternSpacing,
    double? patternSize,
  }) {
    return BorderStyle(
      type: type ?? this.type,
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      padding: padding ?? this.padding,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      hasShadow: hasShadow ?? this.hasShadow,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      patternSpacing: patternSpacing ?? this.patternSpacing,
      patternSize: patternSize ?? this.patternSize,
    );
  }

  /// Converts this BorderStyle to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'color': color.toARGB32(),
      'thickness': thickness,
      'padding': padding,
      'cornerRadius': cornerRadius,
      'hasShadow': hasShadow,
      'shadowBlur': shadowBlur,
      'shadowOpacity': shadowOpacity,
      'secondaryColor': secondaryColor?.toARGB32(),
      'patternSpacing': patternSpacing,
      'patternSize': patternSize,
    };
  }

  /// Creates a BorderStyle from a JSON map
  factory BorderStyle.fromJson(Map<String, dynamic> json) {
    return BorderStyle(
      type: BorderType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => BorderType.solid,
      ),
      color: Color(json['color'] as int),
      thickness: (json['thickness'] as num?)?.toDouble() ?? 4.0,
      padding: (json['padding'] as num?)?.toDouble() ?? 16.0,
      cornerRadius: (json['cornerRadius'] as num?)?.toDouble() ?? 0.0,
      hasShadow: json['hasShadow'] as bool? ?? false,
      shadowBlur: (json['shadowBlur'] as num?)?.toDouble() ?? 4.0,
      shadowOpacity: (json['shadowOpacity'] as num?)?.toDouble() ?? 0.3,
      secondaryColor: json['secondaryColor'] != null 
          ? Color(json['secondaryColor'] as int)
          : null,
      patternSpacing: (json['patternSpacing'] as num?)?.toDouble(),
      patternSize: (json['patternSize'] as num?)?.toDouble(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is BorderStyle &&
        other.type == type &&
        other.color == color &&
        other.thickness == thickness &&
        other.padding == padding &&
        other.cornerRadius == cornerRadius &&
        other.hasShadow == hasShadow &&
        other.shadowBlur == shadowBlur &&
        other.shadowOpacity == shadowOpacity &&
        other.secondaryColor == secondaryColor &&
        other.patternSpacing == patternSpacing &&
        other.patternSize == patternSize;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      color,
      thickness,
      padding,
      cornerRadius,
      hasShadow,
      shadowBlur,
      shadowOpacity,
      Object.hash(
        secondaryColor,
        patternSpacing,
        patternSize,
      ),
    );
  }

  @override
  String toString() {
    return 'BorderStyle(type: $type, color: $color, thickness: $thickness, '
        'padding: $padding, cornerRadius: $cornerRadius, hasShadow: $hasShadow, '
        'shadowBlur: $shadowBlur, shadowOpacity: $shadowOpacity, '
        'secondaryColor: $secondaryColor, patternSpacing: $patternSpacing, '
        'patternSize: $patternSize)';
  }
}
