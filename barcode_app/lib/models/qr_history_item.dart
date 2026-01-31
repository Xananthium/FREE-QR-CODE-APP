import 'dart:convert';
import 'qr_type.dart';

/// A single QR code history entry
class QRHistoryItem {
  final String id;
  final String content;
  final QRType type;
  final DateTime timestamp;
  final String? label;

  QRHistoryItem({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.label,
  });

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'label': label,
    };
  }

  /// Create from JSON
  factory QRHistoryItem.fromJson(Map<String, dynamic> json) {
    return QRHistoryItem(
      id: json['id'],
      content: json['content'],
      type: QRType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => QRType.url,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      label: json['label'],
    );
  }

  /// Get a short preview of the content
  String get preview {
    if (content.length <= 50) return content;
    return '${content.substring(0, 50)}...';
  }

  /// Get a display label
  String get displayLabel {
    if (label != null && label!.isNotEmpty) return label!;
    return type.displayName;
  }
}
