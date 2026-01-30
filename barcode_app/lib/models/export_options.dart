/// Export resolution options for barcode/QR code images
enum ExportResolution {
  /// Small resolution - 512x512 pixels
  small,

  /// Medium resolution - 1024x1024 pixels
  medium,

  /// Large resolution - 2048x2048 pixels
  large,

  /// Extra large resolution - 4096x4096 pixels
  extraLarge;

  /// Returns a human-readable display name for the resolution
  String get displayName {
    switch (this) {
      case ExportResolution.small:
        return 'Small (512×512)';
      case ExportResolution.medium:
        return 'Medium (1024×1024)';
      case ExportResolution.large:
        return 'Large (2048×2048)';
      case ExportResolution.extraLarge:
        return 'Extra Large (4096×4096)';
    }
  }

  /// Returns the pixel size for this resolution
  int get pixelSize {
    switch (this) {
      case ExportResolution.small:
        return 512;
      case ExportResolution.medium:
        return 1024;
      case ExportResolution.large:
        return 2048;
      case ExportResolution.extraLarge:
        return 4096;
    }
  }

  /// Converts the enum to a string for JSON serialization
  String toJson() => name;

  /// Creates an ExportResolution from a JSON string
  static ExportResolution fromJson(String json) {
    return ExportResolution.values.firstWhere(
      (resolution) => resolution.name == json,
      orElse: () => ExportResolution.medium,
    );
  }
}

/// Export format options for barcode/QR code images
enum ExportFormat {
  /// PNG format - lossless compression
  png,

  /// JPEG format - lossy compression
  jpeg;

  /// Returns a human-readable display name for the format
  String get displayName {
    switch (this) {
      case ExportFormat.png:
        return 'PNG';
      case ExportFormat.jpeg:
        return 'JPEG';
    }
  }

  /// Returns the file extension for this format
  String get fileExtension {
    switch (this) {
      case ExportFormat.png:
        return 'png';
      case ExportFormat.jpeg:
        return 'jpg';
    }
  }

  /// Returns the MIME type for this format
  String get mimeType {
    switch (this) {
      case ExportFormat.png:
        return 'image/png';
      case ExportFormat.jpeg:
        return 'image/jpeg';
    }
  }

  /// Converts the enum to a string for JSON serialization
  String toJson() => name;

  /// Creates an ExportFormat from a JSON string
  static ExportFormat fromJson(String json) {
    return ExportFormat.values.firstWhere(
      (format) => format.name == json,
      orElse: () => ExportFormat.png,
    );
  }
}

/// Model class representing export options for barcode/QR code images
class ExportOptions {
  /// The resolution to export the image at
  final ExportResolution resolution;

  /// The format to export the image in
  final ExportFormat format;

  /// Quality setting for JPEG compression (0-100, only used for JPEG format)
  /// Higher values mean better quality but larger file size
  final int quality;

  /// Creates export options with the specified settings
  /// 
  /// Defaults to medium resolution, PNG format, and 85% quality for JPEG
  const ExportOptions({
    this.resolution = ExportResolution.medium,
    this.format = ExportFormat.png,
    this.quality = 85,
  }) : assert(quality >= 0 && quality <= 100, 'Quality must be between 0 and 100');

  /// Creates a copy of this ExportOptions with the specified fields replaced
  ExportOptions copyWith({
    ExportResolution? resolution,
    ExportFormat? format,
    int? quality,
  }) {
    return ExportOptions(
      resolution: resolution ?? this.resolution,
      format: format ?? this.format,
      quality: quality ?? this.quality,
    );
  }

  /// Converts this ExportOptions to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'resolution': resolution.toJson(),
      'format': format.toJson(),
      'quality': quality,
    };
  }

  /// Creates an ExportOptions from a JSON map
  factory ExportOptions.fromJson(Map<String, dynamic> json) {
    return ExportOptions(
      resolution: ExportResolution.fromJson(json['resolution'] as String),
      format: ExportFormat.fromJson(json['format'] as String),
      quality: json['quality'] as int? ?? 85,
    );
  }

  @override
  String toString() {
    return 'ExportOptions(resolution: ${resolution.displayName}, '
        'format: ${format.displayName}, quality: $quality)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExportOptions &&
        other.resolution == resolution &&
        other.format == format &&
        other.quality == quality;
  }

  @override
  int get hashCode {
    return Object.hash(resolution, format, quality);
  }
}
