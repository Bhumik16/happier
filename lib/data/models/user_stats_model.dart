import 'package:hive/hive.dart';

part 'user_stats_model.g.dart';

/// ====================
/// USER STATS MODEL
/// ====================
/// Tracks user meditation statistics
/// - Total sessions completed
/// - Total minutes spent meditating
/// - Weekly streak count
/// - Mindful days count
/// - Session history with timestamps

@HiveType(typeId: 1) // typeId 0 is used by MeditationModel
class UserStatsModel extends HiveObject {
  @HiveField(0)
  int totalSessions;

  @HiveField(1)
  int totalMinutes;

  @HiveField(2)
  int weeklyStreak;

  @HiveField(3)
  int mindfulDays;

  @HiveField(4)
  DateTime lastSessionDate;

  @HiveField(5)
  List<SessionHistoryEntry> sessionHistory;

  UserStatsModel({
    this.totalSessions = 0,
    this.totalMinutes = 0,
    this.weeklyStreak = 0,
    this.mindfulDays = 0,
    DateTime? lastSessionDate,
    List<SessionHistoryEntry>? sessionHistory,
  }) : lastSessionDate = lastSessionDate ?? DateTime.now(),
       sessionHistory = sessionHistory ?? [];

  /// Add a new session to stats
  void addSession(int durationMinutes) {
    totalSessions++;
    totalMinutes += durationMinutes;
    lastSessionDate = DateTime.now();

    // Add to history
    sessionHistory.add(
      SessionHistoryEntry(
        date: DateTime.now(),
        durationMinutes: durationMinutes,
      ),
    );

    // Calculate mindful days (unique dates)
    _updateMindfulDays();

    // Calculate weekly streak
    _updateWeeklyStreak();
  }

  /// Calculate unique mindful days from session history
  void _updateMindfulDays() {
    final uniqueDates = <String>{};
    for (var entry in sessionHistory) {
      final dateKey =
          '${entry.date.year}-${entry.date.month}-${entry.date.day}';
      uniqueDates.add(dateKey);
    }
    mindfulDays = uniqueDates.length;
  }

  /// Calculate weekly streak (consecutive weeks with at least 1 session)
  void _updateWeeklyStreak() {
    if (sessionHistory.isEmpty) {
      weeklyStreak = 0;
      return;
    }

    final sortedHistory = List<SessionHistoryEntry>.from(sessionHistory)
      ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first

    int streak = 0;
    DateTime? lastWeekStart;

    for (var entry in sortedHistory) {
      final weekStart = _getWeekStart(entry.date);

      // First session or same week
      if (lastWeekStart == null || weekStart == lastWeekStart) {
        lastWeekStart = weekStart;
        if (streak == 0) streak = 1;
      }
      // Previous consecutive week
      else if (_isConsecutiveWeek(lastWeekStart, weekStart)) {
        streak++;
        lastWeekStart = weekStart;
      }
      // Gap found, break streak
      else {
        break;
      }
    }

    weeklyStreak = streak;
  }

  /// Get the start of the week (Monday) for a given date
  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday; // Monday = 1, Sunday = 7
    return DateTime(date.year, date.month, date.day - (weekday - 1));
  }

  /// Check if two week starts are consecutive
  bool _isConsecutiveWeek(DateTime currentWeek, DateTime previousWeek) {
    final diff = currentWeek.difference(previousWeek).inDays;
    return diff == 7;
  }

  /// Reset all stats
  void resetStats() {
    totalSessions = 0;
    totalMinutes = 0;
    weeklyStreak = 0;
    mindfulDays = 0;
    sessionHistory.clear();
    lastSessionDate = DateTime.now();
  }

  /// Copy with method
  UserStatsModel copyWith({
    int? totalSessions,
    int? totalMinutes,
    int? weeklyStreak,
    int? mindfulDays,
    DateTime? lastSessionDate,
    List<SessionHistoryEntry>? sessionHistory,
  }) {
    return UserStatsModel(
      totalSessions: totalSessions ?? this.totalSessions,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      weeklyStreak: weeklyStreak ?? this.weeklyStreak,
      mindfulDays: mindfulDays ?? this.mindfulDays,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      sessionHistory: sessionHistory ?? this.sessionHistory,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'totalSessions': totalSessions,
      'totalMinutes': totalMinutes,
      'weeklyStreak': weeklyStreak,
      'mindfulDays': mindfulDays,
      'lastSessionDate': lastSessionDate.toIso8601String(),
      'sessionHistory': sessionHistory.map((e) => e.toJson()).toList(),
    };
  }

  /// From JSON
  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalSessions: json['totalSessions'] ?? 0,
      totalMinutes: json['totalMinutes'] ?? 0,
      weeklyStreak: json['weeklyStreak'] ?? 0,
      mindfulDays: json['mindfulDays'] ?? 0,
      lastSessionDate: json['lastSessionDate'] != null
          ? DateTime.parse(json['lastSessionDate'])
          : DateTime.now(),
      sessionHistory: json['sessionHistory'] != null
          ? (json['sessionHistory'] as List)
                .map((e) => SessionHistoryEntry.fromJson(e))
                .toList()
          : [],
    );
  }
}

/// ====================
/// SESSION HISTORY ENTRY
/// ====================
/// Individual session record with timestamp

@HiveType(typeId: 2)
class SessionHistoryEntry {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int durationMinutes;

  SessionHistoryEntry({required this.date, required this.durationMinutes});

  Map<String, dynamic> toJson() {
    return {'date': date.toIso8601String(), 'durationMinutes': durationMinutes};
  }

  factory SessionHistoryEntry.fromJson(Map<String, dynamic> json) {
    return SessionHistoryEntry(
      date: DateTime.parse(json['date']),
      durationMinutes: json['durationMinutes'] ?? 0,
    );
  }
}
