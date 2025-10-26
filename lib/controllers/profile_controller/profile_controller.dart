import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ProfileController extends GetxController {
  final Logger _logger = Logger();

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

  Future<void> _loadUserStats() async {
    try {
      // TODO: Load from SharedPreferences or Firestore
      _mindfulDays.value = 0;
      _totalSessions.value = 0;
      _totalMinutes.value = 0;
      _weeklyStreak.value = 0;
      
      _logger.i('📊 User stats loaded');
    } catch (e) {
      _logger.e('❌ Error loading stats: $e');
    }
  }
}