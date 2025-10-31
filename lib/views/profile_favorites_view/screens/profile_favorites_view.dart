import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../data/models/course_session_model.dart';
import '../../../data/models/course_model.dart';
import '../../../data/models/short_model.dart';
import '../../../data/models/sleep_model.dart';
import '../../../core/services/mock_course_sessions_service.dart';
import '../../../core/services/mock_courses_service.dart';
import '../../../core/services/mock_sleeps_service.dart';
import '../../../core/services/mock_shorts_service.dart';
import '../../../core/services/favorites_service.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/navigation_helper.dart';

class ProfileFavoritesView extends StatefulWidget {
  const ProfileFavoritesView({super.key});

  @override
  State<ProfileFavoritesView> createState() => _ProfileFavoritesViewState();
}

class _ProfileFavoritesViewState extends State<ProfileFavoritesView> {
  final Logger _logger = Logger();
  List<Map<String, dynamic>> favoriteItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favoriteIds = await FavoritesService.getFavorites();
    final List<Map<String, dynamic>> items = [];

    _logger.i('📋 Loading ${favoriteIds.length} favorite IDs: $favoriteIds');

    for (final id in favoriteIds) {
      _logger.i('Processing ID: $id');

      if (id.startsWith('session_')) {
        final session = _getSessionFromId(id);
        if (session != null) {
          _logger.i('✅ Found session: ${session.title}');
          items.add({
            'type': 'session',
            'sessionId': session.id,
            'courseId': session.courseId,
            'title': session.title,
            'instructor': session.instructor,
            'durationMinutes': session.durationMinutes,
          });
        } else {
          _logger.w('⚠️ Session not found for ID: $id');
        }
      } else if (id.startsWith('course_')) {
        final courseId = id.replaceFirst('course_', '');
        final course = _getCourseById(courseId);

        if (course != null) {
          _logger.i('✅ Found course: ${course.title}');
          items.add({
            'type': 'course',
            'courseId': courseId,
            'title': course.title,
            'instructor': course.instructor,
            'durationMinutes': course.durationMinutes,
            'subtitle': '${course.totalSessions} sessions',
          });
        } else {
          _logger.w('⚠️ Course not found for ID: $courseId');
        }
      } else if (id.startsWith('sleep_')) {
        // ✅ SLEEP TAB - Keep as 'sleep' type
        final sleepId = id.replaceFirst('sleep_', '');
        final sleep = _getSleepById(sleepId);

        if (sleep != null) {
          _logger.i('✅ Found sleep: ${sleep.title}');
          items.add({
            'type': 'sleep', // ✅ Proper type for Sleep tab
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
        // ✅ SINGLES TAB - Keep as 'short' type
        final shortId = id.replaceFirst('short_', '');
        final short = _getShortById(shortId);

        if (short != null) {
          _logger.i('✅ Found short: ${short.title}');
          items.add({
            'type': 'short', // ✅ Proper type for Singles tab
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
        // ✅ SHORTS TAB (Podcast section) - Handle both podcast cards and individual episodes
        final podcastId = id.replaceFirst('podcast_', '');

        // Check if it's a podcast card (e.g., podcast_001) or episode (e.g., podcast_episode_001)
        dynamic episode;

        if (id.startsWith('podcast_episode_') ||
            podcastId.startsWith('episode_')) {
          // It's an individual episode
          episode = _getPodcastEpisodeById(id);
        } else {
          // It's a podcast card - get the first episode of that podcast
          final allPodcasts = MockShortsService.getPodcastShorts();
          final podcast = allPodcasts.firstWhereOrNull((p) => p.id == id);

          if (podcast != null) {
            final episodes = MockShortsService.getEpisodesForPodcast(
              podcast.id,
            );
            if (episodes.isNotEmpty) {
              episode = episodes.first; // ✅ Get first episode to play
              _logger.i('✅ Using first episode of podcast: ${episode.title}');
            }
          }
        }

        if (episode != null) {
          _logger.i('✅ Found podcast episode: ${episode.title}');
          items.add({
            'type': 'podcast', // ✅ Proper type for Shorts tab (Podcast)
            'podcastId': id,
            'title': episode.title,
            'instructor': episode.podcastName,
            'durationMinutes': 6,
            'subtitle': episode.duration,
            'episode': episode, // ✅ Store full episode for playback
          });
        } else {
          // Fallback
          _logger.w('⚠️ Podcast not found for ID: $id, using fallback');
          items.add({
            'type': 'podcast',
            'podcastId': id,
            'title': _getPodcastTitle(podcastId),
            'instructor': 'Happier Podcasts',
            'durationMinutes': 6,
            'subtitle': '6 min',
          });
        }
      }
    }

    setState(() {
      favoriteItems = items;
      isLoading = false;
    });

    _logger.i('✅ Loaded ${items.length} favorite items');
  }

  CourseSessionModel? _getSessionFromId(String sessionId) {
    if (!sessionId.startsWith('session_')) return null;

    final actualSessionId = sessionId.replaceFirst('session_', '');
    final sessionPatternIndex = actualSessionId.indexOf('_session_');

    if (sessionPatternIndex == -1) {
      _logger.e('❌ Invalid format: missing "_session_" pattern');
      return null;
    }

    final courseId = actualSessionId.substring(0, sessionPatternIndex);
    _logger.i(
      'Extracted courseId: $courseId, full sessionId: $actualSessionId',
    );

    final sessions = MockCourseSessionsService.getSessionsForCourse(courseId);
    final session = sessions.firstWhereOrNull((s) => s.id == actualSessionId);

    if (session != null) {
      _logger.i('✅ Found session: ${session.title}');
    } else {
      _logger.w(
        '❌ Session not found. Available sessions: ${sessions.map((s) => s.id).toList()}',
      );
    }

    return session;
  }

  CourseModel? _getCourseById(String courseId) {
    final courses = MockCoursesService.getSampleCourses();
    return courses.firstWhereOrNull((c) => c.id == courseId);
  }

  SleepModel? _getSleepById(String sleepId) {
    final sleeps = MockSleepsService.getSampleSleeps();
    return sleeps.firstWhereOrNull((s) => s.id == sleepId);
  }

  ShortModel? _getShortById(String shortId) {
    if (shortId.startsWith('practice_')) {
      return ShortModel(
        id: shortId,
        title: _getPracticeTitle(shortId),
        instructor: 'Practice In Action',
        duration: '2 min',
        type: 'practice',
      );
    }

    if (shortId.startsWith('wisdom_session_')) {
      return ShortModel(
        id: shortId,
        title: _getWisdomTitle(shortId),
        instructor: 'Happier Meditation',
        duration: '30 sec',
        type: 'wisdom',
      );
    }

    return ShortModel(
      id: shortId,
      title: 'Wisdom Clip',
      instructor: 'Happier Meditation',
      duration: '30 sec',
      type: 'wisdom',
    );
  }

  // ✅ UPDATED: Better episode search with logging
  dynamic _getPodcastEpisodeById(String episodeId) {
    _logger.i('🔍 Searching for episode: $episodeId');

    final allPodcasts = MockShortsService.getPodcastShorts();

    for (final podcast in allPodcasts) {
      final episodes = MockShortsService.getEpisodesForPodcast(podcast.id);
      for (final episode in episodes) {
        // Check both exact match and contains
        if (episode.id == episodeId ||
            episodeId.contains(episode.id) ||
            episode.id.contains(episodeId.replaceAll('podcast_', ''))) {
          _logger.i(
            '✅ Found episode: ${episode.title} with audioFile: ${episode.audioFile}',
          );
          return episode;
        }
      }
    }

    _logger.w('⚠️ No episode found for ID: $episodeId');
    return null;
  }

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

  String _getWisdomTitle(String shortId) {
    final sessionNum =
        int.tryParse(shortId.replaceAll('wisdom_session_', '')) ?? 0;

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

  String _getPodcastTitle(String podcastId) {
    final titles = {
      '001': 'Teacher Talks',
      '002': 'MORE THAN A FEELING',
      '003': 'Childproof',
      '004': 'Twenty Percent Happier',
      'episode_001': 'Quieting the Mind... Politely',
      'episode_002': 'Defining Mindfulness',
      'episode_003': 'Are you a Zoë or a Zelda?',
      'episode_004': 'What to Do When Your Mind Wanders',
      'episode_005': 'Chilling Out Is Not The Point',
    };
    return titles[podcastId] ?? 'Podcast Episode';
  }

  int _parseDuration(String durationRange) {
    try {
      final numbers = RegExp(r'\d+').allMatches(durationRange);
      if (numbers.isNotEmpty) {
        return int.parse(numbers.first.group(0)!);
      }
    } catch (e) {
      _logger.w('Failed to parse duration: $durationRange');
    }
    return 15;
  }

  void _handleItemTap(Map<String, dynamic> item) {
    final type = item['type'] ?? 'session';

    if (type == 'course') {
      _navigateToCourse(item);
    } else if (type == 'sleep') {
      _navigateToSleep(item);
    } else if (type == 'short') {
      _navigateToShort(item);
    } else if (type == 'podcast') {
      _navigateToPodcast(item);
    } else {
      _playSession(item);
    }
  }

  void _navigateToCourse(Map<String, dynamic> item) {
    final courseId = item['courseId'] ?? '';
    _logger.i('📚 Navigating to course detail: $courseId');
    Get.toNamed(AppRoutes.courseDetail, arguments: courseId);
  }

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
    Get.toNamed(AppRoutes.sleepDetail, arguments: {'sleep': sleep});
  }

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
    Get.toNamed(AppRoutes.shortsVideoPlayer, arguments: {'short': short});
  }

  void _navigateToPodcast(Map<String, dynamic> item) {
    final episode = item['episode'];

    if (episode != null) {
      // ✅ Navigate to podcast audio player with episode data
      _logger.i('🎧 Opening podcast audio player: ${episode.title}');
      Get.toNamed(
        AppRoutes.podcastAudioPlayer,
        arguments: {'episode': episode},
      );
    } else {
      // Fallback: Try to load episode
      final podcastId = item['podcastId'] ?? '';
      final episodeData = _getPodcastEpisodeById(podcastId);

      if (episodeData != null) {
        _logger.i(
          '🎧 Opening podcast audio player (fallback): ${episodeData.title}',
        );
        Get.toNamed(
          AppRoutes.podcastAudioPlayer,
          arguments: {'episode': episodeData},
        );
      } else {
        _logger.e('❌ Episode not found for podcast ID: $podcastId');
        Get.snackbar(
          'Error',
          'Podcast episode not found',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void _playSession(Map<String, dynamic> item) {
    final sessionId = item['sessionId'] ?? '';
    final courseId = item['courseId'] ?? '';
    final title = item['title'] ?? 'Unknown';

    _logger.i(
      '▶️ Playing session: $title (courseId: $courseId, sessionId: $sessionId)',
    );

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

    Get.toNamed(
      AppRoutes.unifiedPlayer,
      arguments: {'session': session, 'course': null},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => NavigationHelper.goBackSimple(),
        ),
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cast, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFD700)),
            )
          : favoriteItems.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ COURSE SESSIONS SECTION (from Courses tab)
                  if (_getItemsByType('session').isNotEmpty ||
                      _getItemsByType('course').isNotEmpty) ...[
                    _buildSectionHeader('Course Sessions'),
                    ..._getItemsByType(
                      'session',
                    ).map((item) => _buildFavoriteItem(item)),
                    ..._getItemsByType(
                      'course',
                    ).map((item) => _buildFavoriteItem(item)),
                  ],

                  // ✅ SLEEP SESSIONS SECTION (from Sleep tab)
                  if (_getItemsByType('sleep').isNotEmpty) ...[
                    _buildSectionHeader('Sleep Sessions'),
                    ..._getItemsByType(
                      'sleep',
                    ).map((item) => _buildFavoriteItem(item)),
                  ],

                  // ✅ SINGLES SECTION (from Singles tab)
                  if (_getItemsByType('short').isNotEmpty) ...[
                    _buildSectionHeader('Singles'),
                    ..._getItemsByType(
                      'short',
                    ).map((item) => _buildFavoriteItem(item)),
                  ],

                  // ✅ PODCAST EPISODES SECTION (from Shorts tab - Podcast)
                  if (_getItemsByType('podcast').isNotEmpty) ...[
                    _buildSectionHeader('Podcast Episodes'),
                    ..._getItemsByType(
                      'podcast',
                    ).map((item) => _buildFavoriteItem(item)),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  List<Map<String, dynamic>> _getItemsByType(String type) {
    return favoriteItems.where((item) => item['type'] == type).toList();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(Map<String, dynamic> item) {
    return InkWell(
      onTap: () => _handleItemTap(item),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconForType(item['type']),
                color: const Color(0xFFFFD700),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (item['instructor'] != null &&
                          item['instructor'].toString().isNotEmpty) ...[
                        Flexible(
                          child: Text(
                            item['instructor'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFB0B0B0),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '•',
                          style: TextStyle(color: Color(0xFFB0B0B0)),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        item['subtitle'] ??
                            '${item['durationMinutes'] ?? 0} min',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFB0B0B0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.favorite, color: Colors.red, size: 24),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'session':
      case 'course':
        return Icons.self_improvement;
      case 'sleep':
        return Icons.bedtime;
      case 'short':
        return Icons.play_circle_outline;
      case 'podcast':
        return Icons.mic;
      default:
        return Icons.favorite;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 20),
            Text(
              'No Favorites Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tap the heart icon in the player to save your favorite sessions',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
