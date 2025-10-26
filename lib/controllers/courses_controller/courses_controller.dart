import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../data/models/course_model.dart';
import '../../core/services/mock_courses_service.dart';

/// ====================
/// COURSES CONTROLLER
/// ====================
/// 
/// Manages the Courses tab state and business logic

class CoursesController extends GetxController {
  final Logger _logger = Logger();
  
  // ====================
  // REACTIVE STATE
  // ====================
  
  final RxList<CourseModel> _courses = <CourseModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  
  // ====================
  // GETTERS
  // ====================
  
  List<CourseModel> get courses => _courses;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;
  bool get hasCourses => _courses.isNotEmpty;
  
  // ====================
  // LIFECYCLE
  // ====================
  
  @override
  void onInit() {
    super.onInit();
    _logger.i('CoursesController initialized');
    loadCourses();
  }
  
  @override
  void onClose() {
    _logger.i('CoursesController disposed');
    super.onClose();
  }
  
  // ====================
  // LOAD COURSES
  // ====================
  
  Future<void> loadCourses() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      _logger.i('Loading courses...');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Load courses from mock service
      final courses = MockCoursesService.getSampleCourses();
      
      _courses.value = courses;
      
      _logger.i('Loaded ${courses.length} courses');
      
    } catch (e) {
      _logger.e('Error loading courses: $e');
      _errorMessage.value = 'Failed to load courses';
      Get.snackbar(
        'Error',
        'Failed to load courses',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
  
  // ====================
  // REFRESH COURSES
  // ====================
  
  Future<void> refreshCourses() async {
    _logger.i('Refreshing courses...');
    await loadCourses();
  }
  
  // ====================
  // HANDLE TAP ON COURSE CARD
  // ====================
  
  void onCourseTap(CourseModel course) {
    if (course.isFree) {
      // Navigate to Course Detail page
      Get.toNamed('/course-detail', arguments: course.id);
      
    } else {
      // Show subscription/trial prompt
      showSubscriptionDialog(course);
    }
  }
  
  // ====================
  // SHOW SUBSCRIPTION DIALOG
  // ====================
  
  void showSubscriptionDialog(CourseModel course) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Premium Content',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This course is part of Happier Premium.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '• Unlimited access to all courses\n'
              '• Download sessions for offline use\n'
              '• New content added weekly\n'
              '• 7-day free trial',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Maybe Later',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Coming Soon',
                'Subscription feature will be available soon!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text(
              'Try Free',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}