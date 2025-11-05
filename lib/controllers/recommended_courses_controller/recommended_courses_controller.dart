import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../data/models/course_model.dart';
import '../../data/models/sleep_model.dart';
import '../../core/services/mock_courses_service.dart';
import '../../core/services/mock_sleeps_service.dart';

class RecommendedCoursesController extends GetxController {
  final Logger _logger = Logger();

  late String topicName;
  final RxList<CourseModel> recommendedCourses = <CourseModel>[].obs;
  final RxList<SleepModel> recommendedSleeps = <SleepModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Get topic name from arguments
    topicName = Get.arguments ?? 'Recommended';
    _logger.i('📚 Loading recommendations for: $topicName');

    loadRecommendations();
  }

  /// Topic → Keywords mapping
  Map<String, List<String>> get topicKeywords => {
    'Self-Compassion': [
      'compassion',
      'self-love',
      'kindness',
      'loving',
      'self',
    ],
    'Anxiety': ['anxiety', 'worry', 'calm', 'stress', 'relief', 'soothe'],
    'Loving-Kindness': ['loving', 'kindness', 'love', 'compassion', 'metta'],
    'Lightly Guided': ['guided', 'gentle', 'easy', 'simple'],
    'Pain': ['pain', 'relief', 'healing', 'body', 'physical'],
    'Body Scan': ['body', 'scan', 'physical', 'awareness', 'relaxation'],
    'Parenting': ['parent', 'child', 'family', 'pregnancy', 'new parents'],
    'Focus': ['focus', 'concentration', 'attention', 'work', 'productivity'],
    'Sleep': ['sleep', 'rest', 'bedtime', 'deep', 'night', 'nap'],
    'Stress': ['stress', 'relief', 'anxiety', 'calm', 'relax', 'tension'],
    'Gratitude': ['gratitude', 'grateful', 'thankful', 'appreciation'],
    'Relationships': ['relationship', 'connection', 'love', 'family', 'friend'],
  };

  /// Load recommendations based on topic
  void loadRecommendations() {
    try {
      isLoading.value = true;

      final keywords = topicKeywords[topicName] ?? [];
      _logger.i('🔍 Searching with keywords: $keywords');

      // Get all courses and sleeps
      final allCourses = MockCoursesService.getSampleCourses();
      final allSleeps = MockSleepsService.getSampleSleeps();

      // Filter courses by keywords
      recommendedCourses.value = allCourses.where((course) {
        return _matchesKeywords(course.title, keywords) ||
            _matchesKeywords(course.description ?? '', keywords) ||
            _matchesKeywords(course.category, keywords) ||
            _matchesKeywords(course.instructor, keywords);
      }).toList();

      // Filter sleeps by keywords (especially for Sleep, Stress, Anxiety topics)
      if ([
        'Sleep',
        'Stress',
        'Anxiety',
        'Gratitude',
        'Body Scan',
      ].contains(topicName)) {
        recommendedSleeps.value = allSleeps.where((sleep) {
          return _matchesKeywords(sleep.title, keywords) ||
              _matchesKeywords(sleep.instructor, keywords);
        }).toList();
      }

      _logger.i(
        '✅ Found ${recommendedCourses.length} courses and ${recommendedSleeps.length} sleeps',
      );
    } catch (e) {
      _logger.e('❌ Error loading recommendations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if text matches any of the keywords
  bool _matchesKeywords(String text, List<String> keywords) {
    final lowerText = text.toLowerCase();
    return keywords.any((keyword) => lowerText.contains(keyword.toLowerCase()));
  }

  /// Get total recommendations count
  int get totalRecommendations =>
      recommendedCourses.length + recommendedSleeps.length;
}
