import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/qr_history_item.dart';
import '../../models/qr_type.dart';

/// Service for managing QR code history
/// Stores the last 5 generated QR codes using SharedPreferences
class QRHistoryService {
  static const String _historyKey = 'qr_code_history';
  static const int _maxHistoryItems = 5;

  /// Get all history items (up to 5, newest first)
  Future<List<QRHistoryItem>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_historyKey);

      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => QRHistoryItem.fromJson(json)).toList();
    } catch (e) {
      // If there's an error reading history, return empty list
      return [];
    }
  }

  /// Add a new QR code to history
  /// Keeps only the last 5 items
  Future<void> addToHistory({
    required String content,
    required QRType type,
    String? label,
  }) async {
    try {
      final history = await getHistory();

      // Create new history item
      final newItem = QRHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: type,
        timestamp: DateTime.now(),
        label: label,
      );

      // Add to front of list
      history.insert(0, newItem);

      // Keep only last 5 items
      if (history.length > _maxHistoryItems) {
        history.removeRange(_maxHistoryItems, history.length);
      }

      // Save back to storage
      await _saveHistory(history);
    } catch (e) {
      // Silently fail - history is not critical
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      // Silently fail
    }
  }

  /// Save history to storage
  Future<void> _saveHistory(List<QRHistoryItem> history) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = history.map((item) => item.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await prefs.setString(_historyKey, jsonString);
  }
}
