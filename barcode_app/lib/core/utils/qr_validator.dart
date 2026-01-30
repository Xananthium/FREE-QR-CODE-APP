/// QR Code scannability validation utilities
///
/// Provides methods to verify QR codes meet scannability standards,
/// particularly around quiet zone requirements based on ISO/IEC 18004.
class QRValidator {
  /// Private constructor to prevent instantiation
  QRValidator._();

  /// Minimum quiet zone as percentage of QR size (ISO/IEC 18004 standard)
  /// The standard requires at least 4 modules of quiet zone.
  static const double minQuietZonePercent = 10.0;

  /// Recommended quiet zone as percentage of QR size for optimal scannability
  static const double recommendedQuietZonePercent = 15.0;

  /// Validates that a QR code has adequate quiet zone
  ///
  /// The quiet zone (also called "quiet space" or "clear area") is the white
  /// border around a QR code that is required for reliable scanning. Without
  /// adequate quiet zone, scanners may fail to detect the QR code edges.
  ///
  /// Parameters:
  /// - [qrSize]: The size of the QR code content in pixels
  /// - [padding]: The padding (quiet zone) around the QR in pixels
  ///
  /// Returns: [QuietZoneValidation] with pass/fail status and recommendations
  ///
  /// Example:
  /// ```dart
  /// final validation = QRValidator.validateQuietZone(
  ///   qrSize: 200,
  ///   padding: 20,
  /// );
  /// print(validation.recommendation); // "Adequate quiet zone"
  /// ```
  static QuietZoneValidation validateQuietZone({
    required double qrSize,
    required double padding,
  }) {
    if (qrSize <= 0) {
      throw ArgumentError('QR size must be greater than 0');
    }
    if (padding < 0) {
      throw ArgumentError('Padding cannot be negative');
    }

    final quietZonePercent = (padding / qrSize) * 100;
    
    if (quietZonePercent >= recommendedQuietZonePercent) {
      return QuietZoneValidation(
        isValid: true,
        quietZonePercent: quietZonePercent,
        recommendation: 'Excellent quiet zone - optimal for all scanning conditions',
        status: QuietZoneStatus.excellent,
      );
    } else if (quietZonePercent >= minQuietZonePercent) {
      return QuietZoneValidation(
        isValid: true,
        quietZonePercent: quietZonePercent,
        recommendation: 'Adequate quiet zone - meets ISO/IEC 18004 minimum',
        status: QuietZoneStatus.adequate,
      );
    } else {
      final recommendedPadding = calculateMinimumPadding(qrSize);
      return QuietZoneValidation(
        isValid: false,
        quietZonePercent: quietZonePercent,
        recommendation: 'Quiet zone too small. Increase padding to at least ${recommendedPadding.toStringAsFixed(1)}px (${minQuietZonePercent.toStringAsFixed(0)}% of QR size)',
        status: QuietZoneStatus.insufficient,
      );
    }
  }

  /// Calculates recommended padding for a given QR size
  ///
  /// Returns the padding value that provides optimal scannability (15% of QR size).
  ///
  /// Example:
  /// ```dart
  /// final padding = QRValidator.calculateRecommendedPadding(1024);
  /// print(padding); // 153.6
  /// ```
  static double calculateRecommendedPadding(double qrSize) {
    return qrSize * (recommendedQuietZonePercent / 100);
  }

  /// Calculates minimum required padding for a given QR size
  ///
  /// Returns the padding value that meets ISO/IEC 18004 minimum (10% of QR size).
  ///
  /// Example:
  /// ```dart
  /// final padding = QRValidator.calculateMinimumPadding(512);
  /// print(padding); // 51.2
  /// ```
  static double calculateMinimumPadding(double qrSize) {
    return qrSize * (minQuietZonePercent / 100);
  }

  /// Validates multiple QR size/padding combinations at once
  ///
  /// Useful for validating all export resolution configurations.
  ///
  /// Example:
  /// ```dart
  /// final results = QRValidator.validateMultiple({
  ///   512: 51.2,
  ///   1024: 102.4,
  ///   2048: 204.8,
  /// });
  /// ```
  static Map<double, QuietZoneValidation> validateMultiple(
    Map<double, double> sizeAndPaddingPairs,
  ) {
    return sizeAndPaddingPairs.map(
      (size, padding) => MapEntry(
        size,
        validateQuietZone(qrSize: size, padding: padding),
      ),
    );
  }
}

/// Status of quiet zone validation
enum QuietZoneStatus {
  /// Quiet zone exceeds recommendations (15%+) - best scannability
  excellent,
  
  /// Quiet zone meets minimum standard (10-15%) - adequate for most use
  adequate,
  
  /// Quiet zone below minimum (<10%) - may fail to scan
  insufficient,
}

/// Result of quiet zone validation
class QuietZoneValidation {
  /// Whether the quiet zone passes validation (adequate or excellent)
  final bool isValid;
  
  /// The actual quiet zone as a percentage of QR size
  final double quietZonePercent;
  
  /// Human-readable recommendation or feedback
  final String recommendation;
  
  /// Status level of the validation
  final QuietZoneStatus status;

  const QuietZoneValidation({
    required this.isValid,
    required this.quietZonePercent,
    required this.recommendation,
    required this.status,
  });

  /// Color code for UI display
  /// - Green: excellent
  /// - Yellow: adequate
  /// - Red: insufficient
  String get statusColor {
    switch (status) {
      case QuietZoneStatus.excellent:
        return 'green';
      case QuietZoneStatus.adequate:
        return 'yellow';
      case QuietZoneStatus.insufficient:
        return 'red';
    }
  }

  @override
  String toString() {
    return 'QuietZoneValidation('
        'valid: $isValid, '
        'percent: ${quietZonePercent.toStringAsFixed(1)}%, '
        'status: $status, '
        'recommendation: "$recommendation"'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is QuietZoneValidation &&
        other.isValid == isValid &&
        other.quietZonePercent == quietZonePercent &&
        other.recommendation == recommendation &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(isValid, quietZonePercent, recommendation, status);
  }
}
