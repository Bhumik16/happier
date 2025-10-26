import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import '../../data/models/course_model.dart';
import '../../data/models/course_session_model.dart';
import '../../core/services/mock_courses_service.dart';
import '../../core/services/mock_course_sessions_service.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/downloads_service.dart';
import '../downloads_controller/downloads_controller.dart';

/// ====================
/// COURSE DETAIL CONTROLLER
/// ====================
/// 
/// Manages state and business logic for Course Detail screen

class CourseDetailController extends GetxController {
  final Logger _logger = Logger();
  final DownloadsService _downloadsService = Get.find<DownloadsService>();
  
  // ====================
  // REACTIVE STATE
  // ====================
  
  final Rx<CourseModel?> _course = Rx<CourseModel?>(null);
  final RxList<CourseSessionModel> _sessions = <CourseSessionModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingSessions = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isCourseFavorite = false.obs;
  final RxMap<String, bool> _sessionFavorites = <String, bool>{}.obs;
  
  // ✅ Download state
  final RxBool _isDownloading = false.obs;
  final RxBool _isCourseDownloaded = false.obs;
  final RxDouble _downloadProgress = 0.0.obs;
  final RxInt _currentDownloadIndex = 0.obs;
  final RxInt _totalSessionsToDownload = 0.obs;
  
  // ====================
  // GETTERS
  // ====================
  
  CourseModel? get course => _course.value;
  List<CourseSessionModel> get sessions => _sessions;
  bool get isLoading => _isLoading.value;
  bool get isLoadingSessions => _isLoadingSessions.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;
  bool get isCourseFavorite => _isCourseFavorite.value;
  
  bool get isDownloading => _isDownloading.value;
  bool get isCourseDownloaded => _isCourseDownloaded.value;
  double get downloadProgress => _downloadProgress.value;
  int get currentDownloadIndex => _currentDownloadIndex.value;
  int get totalSessionsToDownload => _totalSessionsToDownload.value;
  
  bool isSessionFavorite(String sessionId) {
    return _sessionFavorites[sessionId] ?? false;
  }
  
  // ====================
  // LIFECYCLE
  // ====================
  
  @override
  void onInit() {
    super.onInit();
    
    final courseId = Get.arguments as String?;
    if (courseId != null) {
      loadCourseDetails(courseId);
    } else {
      _errorMessage.value = 'No course ID provided';
      _logger.e('No course ID in arguments');
    }
  }
  
  @override
  void onReady() {
    super.onReady();
  }
  
  @override
  void onClose() {
    super.onClose();
  }
  
  // ====================
  // LOAD COURSE DETAILS
  // ====================
  
  Future<void> loadCourseDetails(String courseId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      _logger.i('Loading course details for: $courseId');
      
      await Future.wait([
        _loadCourse(courseId),
        _loadSessions(courseId),
      ]);
      
      if (_course.value != null) {
        _logger.i('Course loaded: ${_course.value!.title}');
        _logger.i('Sessions loaded: ${_sessions.length}');
        
        await checkCourseFavoriteStatus();
        await checkSessionsFavoriteStatus();
        await checkCourseDownloadStatus();
      }
      
    } catch (e) {
      _errorMessage.value = 'Failed to load course details';
      _logger.e('Error loading course details: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> loadCourse() async {
    final courseId = Get.arguments as String?;
    if (courseId != null) {
      await loadCourseDetails(courseId);
    }
  }
  
  Future<void> _loadCourse(String courseId) async {
    try {
      final courses = MockCoursesService.getSampleCourses();
      _course.value = courses.firstWhereOrNull(
        (course) => course.id == courseId,
      );
      
      if (_course.value == null) {
        throw Exception('Course not found: $courseId');
      }
    } catch (e) {
      _logger.e('Error loading course: $e');
      rethrow;
    }
  }
  
  Future<void> _loadSessions(String courseId) async {
    try {
      _isLoadingSessions.value = true;
      _sessions.value = MockCourseSessionsService.getSessionsForCourse(courseId);
    } catch (e) {
      _logger.e('Error loading sessions: $e');
      rethrow;
    } finally {
      _isLoadingSessions.value = false;
    }
  }
  
  // ====================
  // COURSE FAVORITE METHODS
  // ====================
  
  Future<void> checkCourseFavoriteStatus() async {
    if (_course.value == null) return;
    
    final courseId = 'course_${_course.value!.id}';
    _isCourseFavorite.value = await FavoritesService.isFavorite(courseId);
  }
  
  Future<void> toggleCourseFavorite() async {
    if (_course.value == null) return;
    
    final courseId = 'course_${_course.value!.id}';
    final newStatus = await FavoritesService.toggleFavorite(courseId);
    _isCourseFavorite.value = newStatus;
    
    _logger.i('❤️ Course favorite toggled: $newStatus');
    
    Get.snackbar(
      newStatus ? 'Added to Favorites' : 'Removed from Favorites',
      _course.value!.title,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  // ====================
  // SESSION FAVORITE METHODS
  // ====================
  
  Future<void> checkSessionsFavoriteStatus() async {
    for (final session in _sessions) {
      final sessionId = 'session_${session.id}';
      final isFavorite = await FavoritesService.isFavorite(sessionId);
      _sessionFavorites[session.id] = isFavorite;
    }
    _sessionFavorites.refresh();
    _logger.i('✅ Checked favorite status for ${_sessions.length} sessions');
  }
  
  Future<void> toggleSessionFavorite(CourseSessionModel session) async {
    final sessionId = 'session_${session.id}';
    final newStatus = await FavoritesService.toggleFavorite(sessionId);
    _sessionFavorites[session.id] = newStatus;
    _sessionFavorites.refresh();
    
    _logger.i('❤️ Session favorite toggled: $newStatus for ${session.title}');
    
    Get.snackbar(
      newStatus ? 'Added to Favorites' : 'Removed from Favorites',
      session.title,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  // ====================
  // HANDLE SESSION TAP
  // ====================
  
  void onSessionTap(CourseSessionModel session) {
    if (session.isLocked) {
      Get.snackbar(
        'Locked',
        'This session is locked',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    _logger.i('Session tapped: ${session.title}');
    
    Get.toNamed(
      '/unified-player',
      arguments: {
        'session': session,
        'course': _course.value,
      },
    );
  }
  
  // ====================
  // ✅ DOWNLOAD COURSE LOGIC
  // ====================
  
  /// Check if entire course is downloaded
  Future<void> checkCourseDownloadStatus() async {
    if (_course.value == null || _sessions.isEmpty) return;
    
    try {
      int downloadedCount = 0;
      for (final session in _sessions) {
        final isDownloaded = await _downloadsService.isDownloaded('course_session_${session.id}');
        if (isDownloaded) downloadedCount++;
      }
      
      _isCourseDownloaded.value = (downloadedCount == _sessions.length);
      
      _logger.i('✅ Course download status: $downloadedCount/${_sessions.length} sessions');
    } catch (e) {
      _logger.e('Error checking download status: $e');
    }
  }
  
  /// Download entire course (all sessions)
  Future<void> downloadCourse() async {
    if (_course.value == null || _sessions.isEmpty) return;
    
    if (_isCourseDownloaded.value) {
      Get.snackbar(
        'Already Downloaded',
        'This course is already in your downloads',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    if (_isDownloading.value) {
      Get.snackbar(
        'Download in Progress',
        'Please wait for current download to finish',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      _isDownloading.value = true;
      _downloadProgress.value = 0.0;
      _currentDownloadIndex.value = 0;
      _totalSessionsToDownload.value = _sessions.length;
      
      _logger.i('📥 Starting course download: ${_course.value!.title}');
      
      Get.snackbar(
        'Download Started',
        'Downloading ${_sessions.length} sessions to app storage...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      
      int successCount = 0;
      
      // Download each session sequentially
      for (int i = 0; i < _sessions.length; i++) {
        final session = _sessions[i];
        _currentDownloadIndex.value = i + 1;
        
        final success = await _downloadSession(session, i);
        if (success) successCount++;
        
        _downloadProgress.value = (i + 1) / _sessions.length;
      }
      
      _isCourseDownloaded.value = (successCount == _sessions.length);
      
      // ✅ Refresh downloads page
      if (Get.isRegistered<DownloadsController>()) {
        await Get.find<DownloadsController>().loadDownloads();
      }
      
      // ✅ Show result
      if (successCount == _sessions.length) {
        Get.snackbar(
          'Download Complete! 🎉',
          '${_course.value!.title} is now available offline',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else if (successCount > 0) {
        Get.snackbar(
          'Partial Download',
          'Downloaded $successCount of ${_sessions.length} sessions',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Download Failed',
          'Could not download course. Please check your internet connection.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
      
      _logger.i('✅ Course download finished: $successCount/${_sessions.length} sessions');
      
    } catch (e) {
      _logger.e('❌ Error downloading course: $e');
      Get.snackbar(
        'Download Failed',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isDownloading.value = false;
      _downloadProgress.value = 0.0;
      _currentDownloadIndex.value = 0;
    }
  }
  
  /// Download a single session
  Future<bool> _downloadSession(CourseSessionModel session, int index) async {
    try {
      _logger.i('📥 Downloading session ${index + 1}: ${session.title}');
      
      // ✅ FIXED: session.videoUrl is already a complete URL, don't process it again!
      final videoUrl = session.videoUrl ?? '';
      
      if (videoUrl.isEmpty) {
        _logger.w('⚠️ No video URL for session: ${session.title}');
        return false;
      }
      
      _logger.i('📥 Downloading from: $videoUrl');
      
      // Generate safe filename
      final fileName = 'course_${_course.value!.id}_session_${session.id}.mp4';
      
      // Download file
      final result = await _downloadsService.downloadFile(
        url: videoUrl,
        fileName: fileName,
        itemId: 'course_session_${session.id}',
        metadata: {
          'type': 'course_session',
          'courseId': _course.value!.id,
          'courseTitle': _course.value!.title,
          'sessionId': session.id,
          'sessionTitle': session.title,
          'sessionNumber': session.sessionNumber,
          'instructor': session.instructor,
          'duration': session.durationMinutes,
          'thumbnailUrl': session.thumbnailUrl,
          'videoUrl': session.videoUrl,  // ✅ ADD THIS
          'audioUrl': session.audioUrl,  // ✅ ADD THIS
        },
      );
      
      if (result != null) {
        _logger.i('✅ Session downloaded: ${session.title}');
        return true;
      } else {
        _logger.e('❌ Failed to download session: ${session.title}');
        return false;
      }
      
    } catch (e) {
      _logger.e('❌ Error downloading session ${session.title}: $e');
      return false;
    }
  }
  
  /// Delete course download
  Future<void> deleteCourseDownload() async {
    if (_course.value == null) return;
    
    try {
      _logger.i('🗑️ Deleting course download: ${_course.value!.title}');
      
      for (final session in _sessions) {
        await _downloadsService.deleteDownload('course_session_${session.id}');
      }
      
      _isCourseDownloaded.value = false;
      
      // Refresh downloads page
      if (Get.isRegistered<DownloadsController>()) {
        await Get.find<DownloadsController>().loadDownloads();
      }
      
      Get.snackbar(
        'Deleted',
        'Course removed from downloads',
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      _logger.e('Error deleting course: $e');
      Get.snackbar(
        'Error',
        'Failed to delete course',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // ====================
  // REFRESH
  // ====================
  
  Future<void> refreshCourse() async {
    if (_course.value != null) {
      await loadCourseDetails(_course.value!.id);
    }
  }
}