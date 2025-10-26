import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/mock_course_sessions_service.dart';
import '../../core/services/mock_courses_service.dart';
import '../../core/services/mock_sleeps_service.dart';
import '../../core/services/mock_shorts_service.dart';
import '../../data/models/course_session_model.dart';
import '../../data/models/course_model.dart';
import '../../data/models/sleep_model.dart';
import '../../data/models/short_model.dart';
import '../../core/routes/app_routes.dart';

/// ====================
/// FAVORITES LIST CONTROLLER
/// ====================
/// Manages favorites and recently played lists

class FavoritesListController extends GetxController {
  final Logger _logger = Logger();
  
  // ====================
  // REACTIVE STATE
  // ====================
  
  final RxList<Map<String, dynamic>> _items = <Map<String, dynamic>>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isShowingFavorites = true.obs;
  
  // ====================
  // GETTERS
  // ====================
  
  List<Map<String, dynamic>> get items => _items;
  bool get isLoading => _isLoading.value;
  bool get isShowingFavorites => _isShowingFavorites.value;
  
  // ====================
  // LIFECYCLE
  // ====================
  
  @override
  void onInit() {
    super.onInit();
    
    // Get type from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      _isShowingFavorites.value = args['type'] == 'favorites';
    }
    
    loadItems();
  }
  
  // ====================
  // LOAD ITEMS
  // ====================
  
  Future<void> loadItems() async {
    try {
      _isLoading.value = true;
      
      if (_isShowingFavorites.value) {
        await _loadFavorites();
      } else {
        await _loadRecentlyPlayed();
      }
      
    } catch (e) {
      _logger.e('Error loading items: $e');
      Get.snackbar(
        'Error',
        'Failed to load items',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
  
  // ====================
  // LOAD FAVORITES
  // ====================
  
  Future<void> _loadFavorites() async {
    final favoriteIds = await FavoritesService.getFavorites();
    final List<Map<String, dynamic>> favoriteItems = [];
    
    _logger.i('📋 Loading ${favoriteIds.length} favorite IDs: $favoriteIds');
    
    for (final id in favoriteIds) {
      _logger.i('Processing ID: $id');
      
      // Parse the ID
      if (id.startsWith('session_')) {
        // ✅ It's a single session - show individual session
        final session = _getSessionFromId(id);
        if (session != null) {
          _logger.i('✅ Found session: ${session.title}');
          favoriteItems.add({
            'type': 'session',
            'sessionId': session.id,
            'courseId': session.courseId,
            'title': session.title,
            'instructor': session.instructor,
            'durationMinutes': session.durationMinutes,
            'videoUrl': session.videoUrl,
            'audioUrl': session.audioUrl,
          });
        } else {
          _logger.w('⚠️ Session not found for ID: $id');
        }
      } else if (id.startsWith('course_')) {
        // ✅ It's a full course - show just ONE course card
        final courseId = id.replaceFirst('course_', '');
        final course = _getCourseById(courseId);
        
        if (course != null) {
          _logger.i('✅ Found course: ${course.title}');
          favoriteItems.add({
            'type': 'course',
            'courseId': courseId,
            'title': course.title,
            'instructor': course.instructor,
            'durationMinutes': course.durationMinutes,
            'subtitle': '${course.totalSessions} sessions',
            'imageUrl': course.imageUrl,
          });
        } else {
          _logger.w('⚠️ Course not found for ID: $courseId');
        }
      } else if (id.startsWith('sleep_')) {
        // ✅ It's a sleep session
        final sleepId = id.replaceFirst('sleep_', '');
        final sleep = _getSleepById(sleepId);
        
        if (sleep != null) {
          _logger.i('✅ Found sleep: ${sleep.title}');
          favoriteItems.add({
            'type': 'sleep',
            'sleepId': sleep.id,
            'title': sleep.title,
            'instructor': sleep.instructor,
            'durationMinutes': _parseDuration(sleep.durationRange),
            'subtitle': sleep.durationRange,
          });
        } else {
          _logger.w('⚠️ Sleep not found for ID: $sleepId');
        }
      } else if (id.startsWith('short_')) {
        // ✅ It's a short video (Practice/Wisdom)
        final shortId = id.replaceFirst('short_', '');
        final short = _getShortById(shortId);
        
        if (short != null) {
          _logger.i('✅ Found short: ${short.title}');
          favoriteItems.add({
            'type': 'short',
            'shortId': short.id,
            'title': short.title,
            'instructor': short.instructor,
            'durationMinutes': 1,
            'subtitle': short.duration ?? '30 sec',
          });
        } else {
          _logger.w('⚠️ Short not found for ID: $shortId');
        }
      } else if (id.startsWith('podcast_')) {
        // ✅ It's a podcast episode
        final episodeId = id.replaceFirst('podcast_', '');
        _logger.i('✅ Found podcast episode: $episodeId');
        favoriteItems.add({
          'type': 'podcast',
          'podcastId': episodeId,
          'title': _getPodcastTitle(episodeId),
          'instructor': 'Happier Podcasts',
          'durationMinutes': 6,
          'subtitle': '6 min',
        });
      }
    }
    
    _items.value = favoriteItems;
    _logger.i('✅ Loaded ${favoriteItems.length} favorite items');
  }
  
  // ====================
  // LOAD RECENTLY PLAYED
  // ====================
  
  Future<void> _loadRecentlyPlayed() async {
    final recentlyPlayed = await FavoritesService.getRecentlyPlayed();
    final List<Map<String, dynamic>> items = [];
    
    for (final item in recentlyPlayed) {
      // Check if it's a sleep session (session ID starts with sleep_)
      final sessionId = item['sessionId'] ?? '';
      if (sessionId.startsWith('sleep_')) {
        items.add({
          ...item,
          'type': 'sleep',
          'sleepId': sessionId.replaceFirst('sleep_', ''),
        });
      } else if (sessionId.startsWith('short_')) {
        items.add({
          ...item,
          'type': 'short',
          'shortId': sessionId.replaceFirst('short_', ''),
        });
      } else if (sessionId.startsWith('podcast_')) {
        items.add({
          ...item,
          'type': 'podcast',
          'podcastId': sessionId.replaceFirst('podcast_', ''),
        });
      } else {
        items.add({
          ...item,
          'type': 'session',
        });
      }
    }
    
    _items.value = items;
    _logger.i('✅ Loaded ${_items.length} recently played');
  }
  
  // ====================
  // GET COURSE BY ID
  // ====================
  
  CourseModel? _getCourseById(String courseId) {
    final courses = MockCoursesService.getSampleCourses();
    return courses.firstWhereOrNull((c) => c.id == courseId);
  }
  
  // ====================
  // GET SESSION FROM ID
  // ====================
  
  CourseSessionModel? _getSessionFromId(String sessionId) {
    // Format: session_courseId_session_XXX
    // Example: session_getting_started_session_001
    
    if (!sessionId.startsWith('session_')) {
      _logger.e('❌ Invalid session ID format: $sessionId');
      return null;
    }
    
    // Remove "session_" prefix to get the actual session ID
    final actualSessionId = sessionId.replaceFirst('session_', '');
    
    _logger.i('Parsing session ID: $sessionId -> actualId: $actualSessionId');
    
    // Extract courseId by finding "_session_" pattern
    final sessionPattern = '_session_';
    final sessionPatternIndex = actualSessionId.indexOf(sessionPattern);
    
    if (sessionPatternIndex == -1) {
      _logger.e('❌ Invalid format: missing "_session_" pattern');
      return null;
    }
    
    final courseId = actualSessionId.substring(0, sessionPatternIndex);
    
    _logger.i('Extracted courseId: $courseId, full sessionId: $actualSessionId');
    
    final sessions = MockCourseSessionsService.getSessionsForCourse(courseId);
    
    // Find the session by matching the full actualSessionId
    final session = sessions.firstWhereOrNull((s) => s.id == actualSessionId);
    
    if (session != null) {
      _logger.i('✅ Found session: ${session.title}');
    } else {
      _logger.w('❌ Session not found. Available sessions: ${sessions.map((s) => s.id).toList()}');
    }
    
    return session;
  }
  
  // ====================
  // GET SLEEP BY ID
  // ====================
  
  SleepModel? _getSleepById(String sleepId) {
    final sleeps = MockSleepsService.getSampleSleeps();
    return sleeps.firstWhereOrNull((s) => s.id == sleepId);
  }
  
  // ====================
  // GET SHORT BY ID
  // ====================
  
  ShortModel? _getShortById(String shortId) {
    // Check if it's a practice short
    if (shortId.startsWith('practice_')) {
      return ShortModel(
        id: shortId,
        title: _getPracticeTitle(shortId),
        instructor: 'Practice In Action',
        duration: '2 min',
        type: 'practice',
      );
    }
    
    // Check if it's a wisdom session
    if (shortId.startsWith('wisdom_session_')) {
      return ShortModel(
        id: shortId,
        title: _getWisdomTitle(shortId),
        instructor: 'Happier Meditation',
        duration: '30 sec',
        type: 'wisdom',
      );
    }
    
    // Otherwise, it's a regular wisdom clip
    return ShortModel(
      id: shortId,
      title: 'Wisdom Clip',
      instructor: 'Happier Meditation',
      duration: '30 sec',
      type: 'wisdom',
    );
  }
  
  // ====================
  // GET PRACTICE TITLE BY ID
  // ====================
  
  String _getPracticeTitle(String shortId) {
    switch (shortId) {
      case 'practice_001':
        return 'Face Difficulties with Clear Intentions';
      case 'practice_002':
        return 'From Comparing to Celebrating';
      case 'practice_003':
        return 'Welcoming Boredom and Interest';
      case 'practice_004':
        return 'When It Gets Late';
      default:
        return 'Practice Session';
    }
  }
  
  // ====================
  // GET WISDOM TITLE BY ID
  // ====================
  
  String _getWisdomTitle(String shortId) {
    // Extract session number
    final sessionNum = int.tryParse(shortId.replaceAll('wisdom_session_', '')) ?? 0;
    
    final titles = [
      'The Self: How It Can Be Helpful',
      'Emotions: Learning to Laugh at Them',
      'Meeting Challenges with Openness',
      'The Ups and Downs of Progress',
      'Nature of the Mind',
      'Dealing with Stress Mindfully',
      'Understanding Anxiety',
      'Finding Peace in Chaos',
      'Compassion for Yourself',
      'Working with Difficult Emotions',
      'The Power of Presence',
      'Letting Go of Control',
      'Breathing Through Stress',
      'The Art of Not Knowing',
      'Mindfulness in Daily Life',
    ];
    
    if (sessionNum > 0 && sessionNum <= titles.length) {
      return titles[sessionNum - 1];
    }
    
    return 'Wisdom Clip';
  }
  
  // ====================
  // GET PODCAST TITLE BY ID
  // ====================
  
  String _getPodcastTitle(String podcastId) {
    final titles = {
      'episode_001': 'Quieting the Mind... Politely',
      'episode_002': 'Defining Mindfulness',
      'episode_003': 'Are you a Zoë or a Zelda?',
      'episode_004': 'What to Do When Your Mind Wanders',
      'episode_005': 'Chilling Out Is Not The Point',
    };
    return titles[podcastId] ?? 'Podcast Episode';
  }
  
  // ====================
  // GET PODCAST EPISODE BY ID (✅ NEW!)
  // ====================
  
  dynamic _getPodcastEpisodeById(String podcastId) {
    final allPodcasts = MockShortsService.getPodcastShorts();
    
    for (final podcast in allPodcasts) {
      final episodes = MockShortsService.getEpisodesForPodcast(podcast.id);
      for (final episode in episodes) {
        if (episode.id == podcastId || podcastId.contains(episode.id)) {
          return episode;
        }
      }
    }
    
    return null;
  }
  
  // ====================
  // PARSE DURATION
  // ====================
  
  int _parseDuration(String durationRange) {
    // Parse "5 - 20 min" or "30 min" to get first number
    try {
      final numbers = RegExp(r'\d+').allMatches(durationRange);
      if (numbers.isNotEmpty) {
        return int.parse(numbers.first.group(0)!);
      }
    } catch (e) {
      _logger.w('Failed to parse duration: $durationRange');
    }
    return 15; // default
  }
  
  // ====================
  // HANDLE ITEM TAP
  // ====================
  
  void playSession(Map<String, dynamic> item) {
    final type = item['type'] ?? 'session';
    
    if (type == 'course') {
      // ✅ Navigate to course detail page
      _navigateToCourse(item);
    } else if (type == 'sleep') {
      // ✅ Navigate to sleep detail page
      _navigateToSleep(item);
    } else if (type == 'short') {
      // ✅ Navigate to shorts video player
      _navigateToShort(item);
    } else if (type == 'podcast') {
      // ✅ Navigate to podcast audio player
      _navigateToPodcast(item);
    } else {
      // ✅ Navigate to player for session
      _playSession(item);
    }
  }
  
  // ====================
  // NAVIGATE TO COURSE DETAIL
  // ====================
  
  void _navigateToCourse(Map<String, dynamic> item) {
    final courseId = item['courseId'] ?? '';
    
    _logger.i('📚 Navigating to course detail: $courseId');
    
    Get.toNamed(
      AppRoutes.courseDetail,
      arguments: courseId,
    );
  }
  
  // ====================
  // NAVIGATE TO SLEEP DETAIL
  // ====================
  
  void _navigateToSleep(Map<String, dynamic> item) {
    final sleepId = item['sleepId'] ?? '';
    final sleep = _getSleepById(sleepId);
    
    if (sleep == null) {
      _logger.e('❌ Sleep not found: $sleepId');
      Get.snackbar(
        'Error',
        'Sleep session not found',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    _logger.i('💤 Navigating to sleep detail: ${sleep.title}');
    
    Get.toNamed(
      AppRoutes.sleepDetail,
      arguments: {'sleep': sleep},
    );
  }
  
  // ====================
  // NAVIGATE TO SHORT VIDEO
  // ====================
  
  void _navigateToShort(Map<String, dynamic> item) {
    final shortId = item['shortId'] ?? '';
    final short = _getShortById(shortId);
    
    if (short == null) {
      _logger.e('❌ Short not found: $shortId');
      Get.snackbar(
        'Error',
        'Short not found',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    _logger.i('🎬 Navigating to short player: ${short.title}');
    
    Get.toNamed(
      AppRoutes.shortsVideoPlayer,
      arguments: {'short': short},
    );
  }
  
  // ====================
  // NAVIGATE TO PODCAST (✅ FIXED - Opens audio player!)
  // ====================
  
  void _navigateToPodcast(Map<String, dynamic> item) {
    final podcastId = item['podcastId'] ?? '';
    
    _logger.i('🎧 Navigating to podcast audio player: $podcastId');
    
    // ✅ Try to get episode data
    final episode = _getPodcastEpisodeById(podcastId);
    
    if (episode != null) {
      _logger.i('✅ Opening audio player with episode: ${episode.title}');
      Get.toNamed(
        AppRoutes.podcastAudioPlayer,
        arguments: {'episode': episode},
      );
    } else {
      _logger.e('❌ Episode not found for ID: $podcastId');
      Get.snackbar(
        'Error',
        'Podcast episode not found',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // ====================
  // PLAY SESSION
  // ====================
  
  void _playSession(Map<String, dynamic> item) {
    final sessionId = item['sessionId'] ?? '';
    final courseId = item['courseId'] ?? '';
    final title = item['title'] ?? 'Unknown';
    
    _logger.i('▶️ Playing session: $title (courseId: $courseId, sessionId: $sessionId)');
    
    // Get full session data
    final sessions = MockCourseSessionsService.getSessionsForCourse(courseId);
    final session = sessions.firstWhereOrNull((s) => s.id == sessionId);
    
    if (session == null) {
      _logger.e('❌ Session not found');
      Get.snackbar(
        'Error',
        'Session not found',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // Navigate to unified player
    Get.toNamed(
      AppRoutes.unifiedPlayer,
      arguments: {
        'session': session,
        'course': null,
      },
    );
  }
  
  // ====================
  // REMOVE ITEM
  // ====================
  
  Future<void> removeItem(int index) async {
    if (index < 0 || index >= _items.length) return;
    
    final item = _items[index];
    final type = item['type'] ?? 'session';
    
    _items.removeAt(index);
    
    // Remove from storage
    if (_isShowingFavorites.value) {
      if (type == 'course') {
        final courseId = item['courseId'];
        await FavoritesService.removeFavorite('course_$courseId');
      } else if (type == 'sleep') {
        final sleepId = item['sleepId'];
        await FavoritesService.removeFavorite('sleep_$sleepId');
      } else if (type == 'short') {
        final shortId = item['shortId'];
        await FavoritesService.removeFavorite('short_$shortId');
      } else if (type == 'podcast') {
        // ✅ Handle podcast removal
        final podcastId = item['podcastId'];
        await FavoritesService.removeFavorite('podcast_$podcastId');
      } else {
        final sessionId = 'session_${item['sessionId']}';
        await FavoritesService.removeFavorite(sessionId);
      }
    }
    
    Get.snackbar(
      'Removed',
      'Item removed',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  // ====================
  // CLEAR ALL
  // ====================
  
  Future<void> clearAll() async {
    if (_isShowingFavorites.value) {
      await FavoritesService.clearFavorites();
    } else {
      await FavoritesService.clearRecentlyPlayed();
    }
    
    _items.clear();
    
    Get.snackbar(
      'Cleared',
      _isShowingFavorites.value ? 'All favorites removed' : 'History cleared',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // ====================
  // REFRESH
  // ====================
  
  Future<void> refresh() async {
    await loadItems();
  }
}