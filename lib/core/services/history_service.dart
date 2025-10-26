import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'dart:convert';

class HistoryService extends GetxService {
  static const String _historyKeyPrefix = 'history_';
  
  /// Get user-specific history key (with safe fallback)
  String _getHistoryKey() {
    try {
      // Try to get AuthController if it exists
      if (Get.isRegistered<dynamic>(tag: 'AuthController')) {
        final authController = Get.find(tag: 'AuthController');
        final userId = authController.currentUser?.value?.uid ?? 'guest';
        return '$_historyKeyPrefix$userId';
      }
    } catch (e) {
      // If AuthController not found, use guest
      print('AuthController not available, using guest history');
    }
    return '${_historyKeyPrefix}guest';
  }
  
  /// Add item to history
  Future<void> addToHistory({
    required String itemId,
    required String title,
    required String type, // 'course', 'single', 'sleep', 'podcast'
    String? thumbnailUrl,
    String? duration,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getHistory();
      
      // Remove if already exists (to update timestamp)
      history.removeWhere((item) => item['id'] == itemId);
      
      // Add to beginning of list
      history.insert(0, {
        'id': itemId,
        'title': title,
        'type': type,
        'thumbnailUrl': thumbnailUrl,
        'duration': duration,
        'completedAt': DateTime.now().toIso8601String(),
        ...?additionalData,
      });
      
      // Keep only last 100 items
      if (history.length > 100) {
        history.removeRange(100, history.length);
      }
      
      await prefs.setString(_getHistoryKey(), json.encode(history));
    } catch (e) {
      print('Error adding to history: $e');
    }
  }
  
  /// Get all history items
  Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_getHistoryKey());
      
      if (data == null) return [];
      
      final List<dynamic> decoded = json.decode(data);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      print('Error getting history: $e');
      return [];
    }
  }
  
  /// Clear all history
  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_getHistoryKey());
    } catch (e) {
      print('Error clearing history: $e');
    }
  }
  
  /// Remove specific item from history
  Future<void> removeFromHistory(String itemId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getHistory();
      
      history.removeWhere((item) => item['id'] == itemId);
      
      await prefs.setString(_getHistoryKey(), json.encode(history));
    } catch (e) {
      print('Error removing from history: $e');
    }
  }
}