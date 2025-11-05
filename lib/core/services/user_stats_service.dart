import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/user_stats_model.dart';

/// ====================
/// USER STATS SERVICE
/// ====================
/// Singleton service to manage user statistics
/// - Track completed sessions
/// - Calculate total minutes
/// - Manage weekly streaks and mindful days
/// - Persist data using Hive

class UserStatsService {
  static final UserStatsService _instance = UserStatsService._internal();
  factory UserStatsService() => _instance;
  UserStatsService._internal();

  final Logger _logger = Logger();
  static const String _boxName = 'user_stats';
  Box<UserStatsModel>? _box;

  /// Get the current user's unique key for stats
  String _getUserStatsKey() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _logger.w('⚠️ No user logged in, using default key');
      return 'default_user_stats';
    }
    return 'user_stats_${user.uid}';
  }

  /// Initialize the service and open Hive box
  Future<void> init() async {
    try {
      // Register Hive adapters if not already registered
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(UserStatsModelAdapter());
        _logger.i('✅ Registered UserStatsModelAdapter (typeId: 1)');
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(SessionHistoryEntryAdapter());
        _logger.i('✅ Registered SessionHistoryEntryAdapter (typeId: 2)');
      }

      // Open box (don't initialize user data here - wait for auth)
      _box = await Hive.openBox<UserStatsModel>(_boxName);
      _logger.i('✅ Opened Hive box: $_boxName');

      // Debug: Show all keys in box
      _logger.i('📦 Total keys in box: ${_box!.length}');
      for (var key in _box!.keys) {
        final stats = _box!.get(key);
        _logger.i('   Key: $key - Sessions: ${stats?.totalSessions ?? 0}');
      }
    } catch (e) {
      _logger.e('❌ UserStatsService init error: $e');
    }
  }

  /// Ensure user stats exist for current user (called lazily)
  Future<void> _ensureUserStatsExist() async {
    if (_box == null) {
      _logger.e('❌ Box not initialized!');
      return;
    }

    final userKey = _getUserStatsKey();
    _logger.i('🔍 Checking if stats exist for key: $userKey');

    final existingStats = _box!.get(userKey);

    if (existingStats == null) {
      _logger.w(
        '⚠️ No existing stats found - Creating new stats for user: $userKey',
      );
      final newStats = UserStatsModel();
      await _box!.put(userKey, newStats);
      await _box!.flush();
      await _box!.compact();
      _logger.i('✅ New stats created and saved to disk');
    } else {
      _logger.i('✅ User stats EXIST for key: $userKey');
      _logger.i('   📊 Sessions: ${existingStats.totalSessions}');
      _logger.i('   ⏱️ Minutes: ${existingStats.totalMinutes}');
      _logger.i('   🌟 Mindful Days: ${existingStats.mindfulDays}');
      _logger.i('   🔥 Weekly Streak: ${existingStats.weeklyStreak}');
    }
  }

  /// Get current user stats
  Future<UserStatsModel> getStats() async {
    if (_box == null) {
      _logger.w(
        '⚠️ UserStatsService: Box not initialized, returning default stats',
      );
      return UserStatsModel();
    }

    await _ensureUserStatsExist();

    final userKey = _getUserStatsKey();
    _logger.i('📖 Reading stats from key: $userKey');

    final stats = _box!.get(userKey);
    if (stats == null) {
      _logger.w('⚠️ No stats found for user, returning default');
      return UserStatsModel();
    }

    _logger.i(
      '📊 Loaded stats: Sessions=${stats.totalSessions}, Minutes=${stats.totalMinutes}',
    );
    return stats;
  }

  /// Record a completed session
  /// [durationMinutes] - How many minutes the user spent in the session
  Future<void> recordSession(int durationMinutes) async {
    try {
      if (_box == null) {
        _logger.e('❌ UserStatsService: Box not initialized');
        return;
      }

      await _ensureUserStatsExist();

      _logger.i('📝 Recording session...');
      _logger.i('   Duration: $durationMinutes minutes');

      final userKey = _getUserStatsKey();

      // ✅ Get stats directly from box to ensure it's a HiveObject
      UserStatsModel? stats = _box!.get(userKey);

      if (stats == null) {
        _logger.w('⚠️ No stats found, creating new one');
        stats = UserStatsModel();
      }

      _logger.i(
        '   Before: Sessions=${stats.totalSessions}, Minutes=${stats.totalMinutes}',
      );

      // Add the session
      stats.addSession(durationMinutes);

      _logger.i(
        '   After: Sessions=${stats.totalSessions}, Minutes=${stats.totalMinutes}',
      );

      // ✅ Save to Hive with put() - this returns Future<void>
      _logger.i('🔑 Saving to key: $userKey');
      await _box!.put(userKey, stats);
      _logger.i('💾 Data written to box');

      // ✅ CRITICAL: Force flush to disk immediately
      await _box!.flush();
      _logger.i('💾 FLUSHED box to disk');

      // ✅ Compact the box to ensure data integrity
      await _box!.compact();
      _logger.i('�️ Compacted box');

      _logger.i('✅ Session recorded successfully!');
      _logger.i(
        '📈 Total Sessions: ${stats.totalSessions}, Total Minutes: ${stats.totalMinutes}',
      );
      _logger.i(
        '🌟 Mindful Days: ${stats.mindfulDays}, Weekly Streak: ${stats.weeklyStreak}',
      );

      // ✅ Verify it was saved by reading it back
      final verifyStats = _box!.get(userKey);
      if (verifyStats != null) {
        _logger.i(
          '✅ VERIFIED: Data persisted - Sessions: ${verifyStats.totalSessions}, Minutes: ${verifyStats.totalMinutes}',
        );
      } else {
        _logger.e('❌ VERIFICATION FAILED: Data not found after save!');
      }
    } catch (e) {
      _logger.e('❌ Error recording session: $e');
      rethrow;
    }
  }

  /// Get total sessions completed
  Future<int> getTotalSessions() async {
    final stats = await getStats();
    return stats.totalSessions;
  }

  /// Get total minutes spent
  Future<int> getTotalMinutes() async {
    final stats = await getStats();
    return stats.totalMinutes;
  }

  /// Get weekly streak
  Future<int> getWeeklyStreak() async {
    final stats = await getStats();
    return stats.weeklyStreak;
  }

  /// Get mindful days count
  Future<int> getMindfulDays() async {
    final stats = await getStats();
    return stats.mindfulDays;
  }

  /// Get session history
  Future<List<SessionHistoryEntry>> getSessionHistory() async {
    final stats = await getStats();
    return stats.sessionHistory;
  }

  /// Reset all statistics
  Future<void> resetStats() async {
    try {
      if (_box == null) {
        _logger.e('❌ UserStatsService: Box not initialized');
        return;
      }

      final userKey = _getUserStatsKey();
      final stats = UserStatsModel();
      await _box!.put(userKey, stats);

      _logger.i('🔄 User stats reset');
    } catch (e) {
      _logger.e('❌ Error resetting stats: $e');
    }
  }

  /// Close the service
  Future<void> close() async {
    await _box?.close();
    _logger.i('📊 UserStatsService closed');
  }
}
