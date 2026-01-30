import 'package:flutter/foundation.dart';
import 'qr_type.dart';

/// Immutable data model representing QR code content
@immutable
class QRData {
  /// The type of QR code (URL, WiFi, etc.)
  final QRType type;
  
  /// The actual content/data of the QR code
  final String content;
  
  /// Optional label or name for this QR code
  final String? label;
  
  /// Timestamp when this QR code was created or scanned
  final DateTime timestamp;
  
  /// Additional metadata for specific QR types (e.g., WiFi SSID, password)
  final Map<String, dynamic>? metadata;

  const QRData({
    required this.type,
    required this.content,
    this.label,
    required this.timestamp,
    this.metadata,
  });

  /// Creates a copy of this QRData with the given fields replaced
  QRData copyWith({
    QRType? type,
    String? content,
    String? label,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return QRData(
      type: type ?? this.type,
      content: content ?? this.content,
      label: label ?? this.label,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts this QRData to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      'content': content,
      'label': label,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Creates a QRData from a JSON map
  factory QRData.fromJson(Map<String, dynamic> json) {
    return QRData(
      type: QRType.fromJson(json['type'] as String),
      content: json['content'] as String,
      label: json['label'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is QRData &&
        other.type == type &&
        other.content == content &&
        other.label == label &&
        other.timestamp == timestamp &&
        mapEquals(other.metadata, metadata);
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      content,
      label,
      timestamp,
      metadata,
    );
  }

  @override
  String toString() {
    return 'QRData(type: $type, content: $content, label: $label, timestamp: $timestamp, metadata: $metadata)';
  }
}
