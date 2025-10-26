import 'package:get/get.dart';
import 'package:logger/logger.dart';

/// ====================
/// MILESTONES CONTROLLER
/// ====================

class MilestonesController extends GetxController {
  final Logger _logger = Logger();
  
  // User progress (TODO: Connect to Firebase)
  final RxInt userCompletedSessions = 1.obs; // Example: 1 session completed
  final RxInt userDailyStreak = 0.obs;
  final RxInt userWeeklyStreak = 0.obs;
  final RxBool hasCompletedFirstCourseSession = true.obs;
  final RxBool hasSharedGuestPass = true.obs;
  final RxBool hasAddedFavorite = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    _logger.i('🏆 MilestonesController initialized');
    // TODO: Load user progress from Firebase
  }
  
  // Daily streak milestones
  List<int> get dailyStreakMilestones => [3, 5, 10, 15, 20, 25, 30, 40, 50];
  
  // Weekly streak milestones
  List<int> get weeklyStreakMilestones => [2, 3, 4, 5, 10, 15, 20, 25, 30, 40, 50];
  
  // Journey milestones (session counts)
  List<dynamic> get journeyMilestones => [
    'First',
    3, 5, 10, 25, 50, 75, 100, 150, 200, 250, 300, 350, 400, 450, 500,
    600, 700, 800, 900, 1000
  ];
  
  // Check if daily streak milestone is achieved
  bool isDailyStreakAchieved(int days) {
    return userDailyStreak.value >= days;
  }
  
  // Check if weekly streak milestone is achieved
  bool isWeeklyStreakAchieved(int weeks) {
    return userWeeklyStreak.value >= weeks;
  }
  
  // Check if journey milestone is achieved
  bool isJourneyAchieved(dynamic milestone) {
    if (milestone == 'First') {
      return userCompletedSessions.value >= 1;
    }
    return userCompletedSessions.value >= milestone;
  }
}