import 'package:flutter/material.dart';
import '../models/qr_type.dart';
import '../models/qr_data.dart';
import '../models/border_style.dart' as qr_models;
import '../models/border_frame.dart';

/// Provider for managing QR code generation state with structured models
/// 
/// This provider handles:
/// - QR type selection (URL, WiFi)
/// - Structured QR data with metadata
/// - Border style customization
/// - Visual customization (colors, size)
/// - Async generation with loading states
/// - Export operations with loading feedback
class QRProvider extends ChangeNotifier {
  // Core QR State
  QRType _currentType = QRType.url;
  QRData? _currentQRData;
  qr_models.BorderStyle _borderStyle = qr_models.BorderStyle.none();
  BorderFrame? _borderFrame; // PNG border frame

  // Visual Customization
  Color _qrColor = Colors.black;
  Color _backgroundColor = Colors.white;
  double _qrSize = 280.0;

  // Loading States
  bool _isGenerating = false;
  bool _isExporting = false;
  bool _isProcessing = false;

  // Getters - Core QR State
  
  /// Current QR type (URL, WiFi)
  QRType get currentType => _currentType;
  
  /// Current structured QR data
  QRData? get currentQRData => _currentQRData;
  
  /// Current border style configuration
  qr_models.BorderStyle get borderStyle => _borderStyle;

  /// Current border frame (PNG image overlay)
  BorderFrame? get borderFrame => _borderFrame;

  // Getters - Visual Properties
  
  /// QR code foreground color
  Color get qrColor => _qrColor;
  
  /// QR code background color
  Color get backgroundColor => _backgroundColor;
  
  /// QR code display size
  double get qrSize => _qrSize;

  // Getters - Loading States
  
  /// Whether QR generation is in progress
  bool get isGenerating => _isGenerating;
  
  /// Whether export operation is in progress
  bool get isExporting => _isExporting;
  
  /// Whether any processing operation is in progress
  bool get isProcessing => _isProcessing;
  
  /// Whether any loading operation is active
  bool get isAnyLoading => _isGenerating || _isExporting || _isProcessing;

  // Getters - Convenience Properties
  
  /// Get the current QR content string (convenience accessor)
  String get currentContent => _currentQRData?.content ?? '';
  
  /// Check if there's valid QR data to display
  bool get hasQRData => _currentQRData != null && currentContent.isNotEmpty;
  
  /// Check if a border is currently applied
  bool get hasBorder => _borderStyle.type != qr_models.BorderType.none;

  // QR Type Management

  /// Update the current QR type
  /// 
  /// Clears existing QR data when type changes to prevent
  /// displaying incompatible data formats.
  void updateQRType(QRType type) {
    if (_currentType != type) {
      _currentType = type;
      // Clear current data when type changes
      _currentQRData = null;
      notifyListeners();
    }
  }

  // QR Data Management

  /// Generate QR code from structured QRData object
  /// 
  /// Shows loading indicator during generation. Includes minimum
  /// duration to prevent UI flicker on fast operations.
  Future<void> generateQRFromData(QRData data) async {
    if (_isGenerating) return; // Prevent duplicate calls
    
    _isGenerating = true;
    notifyListeners();

    try {
      // Simulate processing time for consistent UX
      final startTime = DateTime.now();
      
      // Update QR data and sync type
      _currentQRData = data;
      _currentType = data.type;
      
      // Ensure minimum loading duration (prevents flicker)
      final elapsed = DateTime.now().difference(startTime);
      final remaining = const Duration(milliseconds: 200) - elapsed;
      if (remaining.inMilliseconds > 0) {
        await Future.delayed(remaining);
      }
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  /// Generate QR code from simple string (convenience method)
  /// 
  /// Creates a QRData object with current type and provided content.
  /// Optionally accepts a label for display purposes.
  Future<void> generateQRCode(String content, {String? label}) async {
    final data = QRData(
      type: _currentType,
      content: content,
      label: label,
      timestamp: DateTime.now(),
    );
    await generateQRFromData(data);
  }

  /// Update QR data content while preserving other properties
  /// 
  /// Useful for live editing scenarios where type, label, and
  /// metadata should remain unchanged.
  void updateQRContent(String content) {
    if (_currentQRData != null) {
      _currentQRData = _currentQRData!.copyWith(content: content);
      notifyListeners();
    }
  }

  /// Update QR data label
  /// 
  /// Labels are used for display purposes and saving QR codes.
  void updateQRLabel(String? label) {
    if (_currentQRData != null) {
      _currentQRData = _currentQRData!.copyWith(label: label);
      notifyListeners();
    }
  }

  /// Update QR data metadata
  /// 
  /// Metadata stores type-specific information (e.g., WiFi SSID, password).
  void updateQRMetadata(Map<String, dynamic>? metadata) {
    if (_currentQRData != null) {
      _currentQRData = _currentQRData!.copyWith(metadata: metadata);
      notifyListeners();
    }
  }

  /// Clear current QR data
  /// 
  /// Removes QR data but preserves type selection and visual settings.
  void clearQRData() {
    _currentQRData = null;
    notifyListeners();
  }

  // Border Style Management

  /// Update border style with full BorderStyle object
  /// 
  /// Shows processing feedback during style application.
  Future<void> updateBorderStyle(qr_models.BorderStyle style) async {
    _isProcessing = true;
    notifyListeners();

    try {
      // Simulate border rendering time
      await Future.delayed(const Duration(milliseconds: 150));
      _borderStyle = style;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Select border by type with default preset styling
  /// 
  /// Uses BorderStyle.preset() to apply appropriate defaults
  /// for each border type. Optionally override color.
  Future<void> selectBorderType(qr_models.BorderType type, {Color? color}) async {
    final style = qr_models.BorderStyle.preset(type, color: color);
    await updateBorderStyle(style);
  }

  /// Remove border (set to none)
  Future<void> removeBorder() async {
    await updateBorderStyle(qr_models.BorderStyle.none());
  }

  // Border Frame Management (PNG overlays)

  /// Update border frame (PNG image overlay)
  Future<void> updateBorderFrame(BorderFrame? frame) async {
    _isProcessing = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 150));
      _borderFrame = frame;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Remove border frame
  Future<void> removeBorderFrame() async {
    await updateBorderFrame(null);
  }

  /// Update border color while preserving other style properties
  Future<void> updateBorderColor(Color color) async {
    _isProcessing = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 100));
      _borderStyle = _borderStyle.copyWith(color: color);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Update border thickness
  void updateBorderThickness(double thickness) {
    _borderStyle = _borderStyle.copyWith(thickness: thickness);
    notifyListeners();
  }

  /// Update border padding
  void updateBorderPadding(double padding) {
    _borderStyle = _borderStyle.copyWith(padding: padding);
    notifyListeners();
  }

  // Visual Customization

  /// Update QR foreground color with processing state
  /// 
  /// Shows processing feedback when applying color changes.
  Future<void> updateQRColor(Color color) async {
    _isProcessing = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 100));
      _qrColor = color;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Update background color with processing state
  Future<void> updateBackgroundColor(Color color) async {
    _isProcessing = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 100));
      _backgroundColor = color;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Update QR size (synchronous, no loading needed)
  void updateQRSize(double size) {
    _qrSize = size;
    notifyListeners();
  }

  // Export Operations

  /// Export QR code with loading state
  /// 
  /// Simulates export operation with loading feedback.
  /// In production, this would save/share the actual QR image.
  Future<bool> exportQRCode() async {
    if (_isExporting) return false; // Prevent duplicate calls
    
    _isExporting = true;
    notifyListeners();

    try {
      // Simulate export operation
      await Future.delayed(const Duration(milliseconds: 400));
      
      // In production: actual export logic here
      // - Generate image from QR data
      // - Apply border styling
      // - Save to device storage
      // - Share via platform share sheet
      
      return true; // Success
    } catch (e) {
      // Error handling
      return false;
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }

  // State Management

  /// Reset all settings to defaults
  /// 
  /// Clears QR data, type, border, and visual customizations.
  void resetToDefaults() {
    _currentType = QRType.url;
    _currentQRData = null;
    _borderStyle = qr_models.BorderStyle.none();
    _qrColor = Colors.black;
    _backgroundColor = Colors.white;
    _qrSize = 280.0;
    notifyListeners();
  }

  /// Create a snapshot of current state for comparison or undo
  Map<String, dynamic> createSnapshot() {
    return {
      'type': _currentType.name,
      'data': _currentQRData?.toJson(),
      'border': _borderStyle.toJson(),
      'qrColor': _qrColor.toARGB32(),
      'backgroundColor': _backgroundColor.toARGB32(),
      'qrSize': _qrSize,
    };
  }

  /// Restore state from snapshot
  void restoreFromSnapshot(Map<String, dynamic> snapshot) {
    _currentType = QRType.fromJson(snapshot['type'] as String);
    _currentQRData = snapshot['data'] != null 
        ? QRData.fromJson(snapshot['data'] as Map<String, dynamic>)
        : null;
    _borderStyle = qr_models.BorderStyle.fromJson(snapshot['border'] as Map<String, dynamic>);
    _qrColor = Color(snapshot['qrColor'] as int);
    _backgroundColor = Color(snapshot['backgroundColor'] as int);
    _qrSize = (snapshot['qrSize'] as num).toDouble();
    notifyListeners();
  }
}
