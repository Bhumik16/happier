import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../core/services/user_stats_service.dart';

class ProfileController extends GetxController {
  final Logger _logger = Logger();
  final UserStatsService _statsService = UserStatsService();

  final RxInt _mindfulDays = 0.obs;
  final RxInt _totalSessions = 0.obs;
  final RxInt _totalMinutes = 0.obs;
  final RxInt _weeklyStreak = 0.obs;

  int get mindfulDays => _mindfulDays.value;
  int get totalSessions => _totalSessions.value;
  int get totalMinutes => _totalMinutes.value;
  int get weeklyStreak => _weeklyStreak.value;

  @override
  void onInit() {
    super.onInit();
    _logger.i('👤 ProfileController initialized');
    _loadUserStats();
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh stats when view is ready
    _logger.i('👤 ProfileController ready - refreshing stats');
    refreshStats();
  }

  Future<void> _loadUserStats() async {
    try {
      final stats = await _statsService.getStats();

      _mindfulDays.value = stats.mindfulDays;
      _totalSessions.value = stats.totalSessions;
      _totalMinutes.value = stats.totalMinutes;
      _weeklyStreak.value = stats.weeklyStreak;

      _logger.i('📊 User stats loaded:');
      _logger.i('   - Sessions: $totalSessions');
      _logger.i('   - Minutes: $totalMinutes');
      _logger.i('   - Mindful Days: $mindfulDays');
      _logger.i('   - Weekly Streak: $weeklyStreak');
    } catch (e) {
      _logger.e('❌ Error loading stats: $e');
    }
  }

  /// Refresh stats from service (call this after session completion)
  Future<void> refreshStats() async {
    await _loadUserStats();
    update(); // Notify GetBuilder listeners
  }

  /// Reset all statistics (for testing or settings)
  Future<void> resetAllStats() async {
    try {
      await _statsService.resetStats();
      await _loadUserStats();
      _logger.i('🔄 Stats reset successfully');

      Get.snackbar(
        'Stats Reset',
        'All statistics have been reset',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _logger.e('❌ Error resetting stats: $e');
    }
  }
}
