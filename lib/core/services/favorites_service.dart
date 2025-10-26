import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import '../../controllers/auth_controller/auth_controller.dart';

/// ====================
/// FAVORITES SERVICE
/// ====================
/// Manages user-specific favorites and recently played using SharedPreferences

class FavoritesService {
  static final Logger _logger = Logger();
  
  // ====================
  // HELPER: GET USER-SPECIFIC KEY
  // ====================
  
  /// Get the current user's ID from AuthController
  static String? _getCurrentUserId() {
    try {
      final authController = Get.find<AuthController>();
      return authController.user?.uid;
    } catch (e) {
      _logger.w('⚠️ AuthController not found, returning null userId');
      return null;
    }
  }
  
  /// Get user-specific favorites key
  static String _getFavoritesKey() {
    final userId = _getCurrentUserId();
    if (userId == null) {
      _logger.w('⚠️ No user ID, using default favorites key');
      return 'favorites';
    }
    return 'favorites_$userId';
  }
  
  /// Get user-specific recently played key
  static String _getRecentlyPlayedKey() {
    final userId = _getCurrentUserId();
    if (userId == null) {
      _logger.w('⚠️ No user ID, using default recently_played key');
      return 'recently_played';
    }
    return 'recently_played_$userId';
  }
  
  // ====================
  // FAVORITES METHODS
  // ====================
  
  /// Get all favorite session IDs for current user
  static Future<List<String>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getFavoritesKey();
      final List<String>? favorites = prefs.getStringList(key);
      _logger.i('📋 Loading favorites for key: $key (${favorites?.length ?? 0} items)');
      return favorites ?? [];
    } catch (e) {
      _logger.e('Error getting favorites: $e');
      return [];
    }
  }
  
  /// Check if a session is favorited
  static Future<bool> isFavorite(String sessionId) async {
    final favorites = await getFavorites();
    return favorites.contains(sessionId);
  }
  
  /// Toggle favorite status
  static Future<bool> toggleFavorite(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getFavoritesKey();
      List<String> favorites = await getFavorites();
      
      if (favorites.contains(sessionId)) {
        favorites.remove(sessionId);
        _logger.i('❌ Removed from favorites: $sessionId (key: $key)');
      } else {
        favorites.insert(0, sessionId); // Add to beginning
        _logger.i('❤️ Added to favorites: $sessionId (key: $key)');
      }
      
      await prefs.setStringList(key, favorites);
      return favorites.contains(sessionId);
    } catch (e) {
      _logger.e('Error toggling favorite: $e');
      return false;
    }
  }
  
  /// Add to favorites
  static Future<void> addFavorite(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getFavoritesKey();
      List<String> favorites = await getFavorites();
      
      if (!favorites.contains(sessionId)) {
        favorites.insert(0, sessionId);
        await prefs.setStringList(key, favorites);
        _logger.i('❤️ Added to favorites: $sessionId (key: $key)');
      }
    } catch (e) {
      _logger.e('Error adding favorite: $e');
    }
  }
  
  /// Remove from favorites
  static Future<void> removeFavorite(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getFavoritesKey();
      List<String> favorites = await getFavorites();
      
      favorites.remove(sessionId);
      await prefs.setStringList(key, favorites);
      _logger.i('❌ Removed from favorites: $sessionId (key: $key)');
    } catch (e) {
      _logger.e('Error removing favorite: $e');
    }
  }
  
  // ====================
  // RECENTLY PLAYED METHODS
  // ====================
  
  /// Get recently played sessions for current user
  static Future<List<Map<String, dynamic>>> getRecentlyPlayed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getRecentlyPlayedKey();
      final List<String>? recentlyPlayedJson = prefs.getStringList(key);
      
      if (recentlyPlayedJson == null) return [];
      
      return recentlyPlayedJson.map((json) {
        return jsonDecode(json) as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      _logger.e('Error getting recently played: $e');
      return [];
    }
  }
  
  /// Add session to recently played
  static Future<void> addRecentlyPlayed({
    required String sessionId,
    required String courseId,
    required String title,
    String? instructor,
    int? durationMinutes,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getRecentlyPlayedKey();
      List<Map<String, dynamic>> recentlyPlayed = await getRecentlyPlayed();
      
      // Remove if already exists
      recentlyPlayed.removeWhere((item) => item['sessionId'] == sessionId);
      
      // Add to beginning
      recentlyPlayed.insert(0, {
        'sessionId': sessionId,
        'courseId': courseId,
        'title': title,
        'instructor': instructor,
        'durationMinutes': durationMinutes,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      // Keep only last 10
      if (recentlyPlayed.length > 10) {
        recentlyPlayed = recentlyPlayed.sublist(0, 10);
      }
      
      // Save
      final List<String> jsonList = recentlyPlayed.map((item) {
        return jsonEncode(item);
      }).toList();
      
      await prefs.setStringList(key, jsonList);
      _logger.i('📝 Added to recently played: $title (key: $key)');
    } catch (e) {
      _logger.e('Error adding recently played: $e');
    }
  }
  
  /// Clear all favorites for current user
  static Future<void> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getFavoritesKey();
      await prefs.remove(key);
      _logger.i('🗑️ Cleared all favorites (key: $key)');
    } catch (e) {
      _logger.e('Error clearing favorites: $e');
    }
  }
  
  /// Clear recently played for current user
  static Future<void> clearRecentlyPlayed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getRecentlyPlayedKey();
      await prefs.remove(key);
      _logger.i('🗑️ Cleared recently played (key: $key)');
    } catch (e) {
      _logger.e('Error clearing recently played: $e');
    }
  }
}