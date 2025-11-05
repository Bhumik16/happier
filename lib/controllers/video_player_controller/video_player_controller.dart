// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as video_player;
import 'package:logger/logger.dart';
import '../../data/models/course_session_model.dart';
import '../../data/models/course_model.dart';
import '../../core/services/user_stats_service.dart';

/// ====================
/// VIDEO PLAYER CONTROLLER
/// ====================

class VideoPlayerController extends GetxController {
  final Logger _logger = Logger();
  video_player.VideoPlayerController? _videoPlayerController;

  // ====================
  // REACTIVE STATE
  // ====================

  final Rx<CourseSessionModel?> _session = Rx<CourseSessionModel?>(null);
  final Rx<CourseModel?> _course = Rx<CourseModel?>(null);
  final RxBool _isInitialized = false.obs;
  final RxBool _isPlaying = false.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _showControls = true.obs;
  final Rx<Duration> _duration = Duration.zero.obs;
  final Rx<Duration> _position = Duration.zero.obs;
  final RxDouble _volume = 1.0.obs;
  final RxDouble _speed = 1.0.obs;
  bool _hasCompletedOnce = false; // ✅ Flag to prevent multiple completions

  // ====================
  // GETTERS
  // ====================

  video_player.VideoPlayerController? get videoController =>
      _videoPlayerController;
  CourseSessionModel? get session => _session.value;
  CourseModel? get course => _course.value;
  bool get isInitialized => _isInitialized.value;
  bool get isPlaying => _isPlaying.value;
  bool get isLoading => _isLoading.value;
  bool get showControls => _showControls.value;
  Duration get duration => _duration.value;
  Duration get position => _position.value;
  double get volume => _volume.value;
  double get speed => _speed.value;

  double get progress {
    if (duration.inMilliseconds == 0) return 0.0;
    return position.inMilliseconds / duration.inMilliseconds;
  }

  String get positionText => _formatDuration(position);
  String get durationText => _formatDuration(duration);

  // ====================
  // LIFECYCLE
  // ====================

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      // ✅ HANDLE TWO TYPES OF NAVIGATION:

      // 1. From Course Detail → has 'session' object
      if (args.containsKey('session')) {
        _session.value = args['session'] as CourseSessionModel?;
        _course.value = args['course'] as CourseModel?;

        if (_session.value?.videoUrl != null) {
          loadVideo(_session.value!.videoUrl!);
        }
      }
      // 2. From Home "Start Course" button → has direct 'videoUrl'
      else if (args.containsKey('videoUrl')) {
        final videoUrl = args['videoUrl'] as String;
        final title = args['title'] as String? ?? 'The Basics';
        final courseId = args['courseId'] as String? ?? 'getting_started';

        // Create a temporary session for display
        _session.value = CourseSessionModel(
          id: 'intro',
          courseId: courseId,
          sessionNumber: 0,
          title: title,
          description: 'Introduction to meditation',
          instructor: 'Happier Meditation',
          durationMinutes: 5,
          videoUrl: videoUrl,
          audioUrl: null,
          thumbnailUrl: null,
          isCompleted: false,
          isLocked: false,
        );

        loadVideo(videoUrl);
      }
    }

    _logger.i('VideoPlayerController initialized');
  }

  @override
  void onClose() {
    _videoPlayerController?.dispose();
    _hasCompletedOnce = false; // Reset flag when closing
    _logger.i('VideoPlayerController disposed');
    super.onClose();
  }

  // ====================
  // LOAD VIDEO
  // ====================

  Future<void> loadVideo(String videoUrl) async {
    try {
      _isLoading.value = true;
      _hasCompletedOnce = false; // ✅ Reset completion flag
      _logger.i('Loading video: $videoUrl');

      // Dispose previous controller
      await _videoPlayerController?.dispose();

      // Create new controller for network URL (Cloudinary)
      _videoPlayerController = video_player.VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );

      // Initialize video player
      await _videoPlayerController!.initialize();
      _isInitialized.value = true;

      // Setup video listener
      _setupVideoListener();

      // Get video duration
      _duration.value = _videoPlayerController!.value.duration;

      _logger.i('Video loaded successfully');

      // Auto-play
      play();
    } catch (e) {
      _logger.e('Error loading video: $e');
      // ❌ REMOVED SNACKBAR - just log the error
    } finally {
      _isLoading.value = false;
    }
  }

  void _setupVideoListener() {
    _videoPlayerController?.addListener(() {
      if (_videoPlayerController != null) {
        final controller = _videoPlayerController!;
        _isPlaying.value = controller.value.isPlaying;
        _position.value = controller.value.position;

        // Check for completion EVERY frame
        final currentSec = controller.value.position.inSeconds;
        final totalSec = controller.value.duration.inSeconds;
        final remaining = totalSec - currentSec;

        // Log progress
        _logger.d(
          '📹 ${currentSec}s/${totalSec}s | Remaining: ${remaining}s | Completed: $_hasCompletedOnce',
        );

        // TRIGGER COMPLETION when within 3 seconds OR at the very end
        if (!_hasCompletedOnce && totalSec > 0) {
          final progress = currentSec / totalSec;

          // Complete if: 95% watched OR less than 3 seconds remaining
          if (progress >= 0.95 || remaining <= 3) {
            _logger.w(
              '🎬 COMPLETION TRIGGERED! Progress: ${(progress * 100).toStringAsFixed(1)}%, Remaining: ${remaining}s',
            );
            _onVideoCompleted();
          }
        }
      }
    });
  }

  // ====================
  // PLAYBACK CONTROLS
  // ====================

  Future<void> play() async {
    try {
      await _videoPlayerController?.play();
      _isPlaying.value = true;
      _logger.i('Video playing');

      // Hide controls after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (_isPlaying.value) {
          _showControls.value = false;
        }
      });
    } catch (e) {
      _logger.e('Error playing video: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _videoPlayerController?.pause();
      _isPlaying.value = false;
      _showControls.value = true;
      _logger.i('Video paused');
    } catch (e) {
      _logger.e('Error pausing video: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying.value) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _videoPlayerController?.seekTo(position);
      _logger.i('Seeked to: ${_formatDuration(position)}');
    } catch (e) {
      _logger.e('Error seeking: $e');
    }
  }

  Future<void> seekForward(int seconds) async {
    final newPosition = position + Duration(seconds: seconds);
    if (newPosition < duration) {
      await seek(newPosition);
    } else {
      await seek(duration);
    }
  }

  Future<void> seekBackward(int seconds) async {
    final newPosition = position - Duration(seconds: seconds);
    if (newPosition > Duration.zero) {
      await seek(newPosition);
    } else {
      await seek(Duration.zero);
    }
  }

  // ====================
  // CONTROLS VISIBILITY
  // ====================

  void toggleControls() {
    _showControls.value = !_showControls.value;
  }

  void showControlsTemporarily() {
    _showControls.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      if (_isPlaying.value) {
        _showControls.value = false;
      }
    });
  }

  // ====================
  // SWITCH TO MEDITATE (AUDIO PLAYER)
  // ====================

  void switchToMeditate() {
    _logger.i('Switching to Meditate (Audio Player)');

    Get.offNamed(
      '/audio-player',
      arguments: {'session': session, 'course': course},
    );
  }

  // ====================
  // VIDEO COMPLETED
  // ====================

  void _onVideoCompleted() {
    _hasCompletedOnce = true; // ✅ Set flag to prevent multiple calls
    _logger.i('✅ Video completed');
    _showControls.value = true;

    // ✅ Track session completion
    _trackSessionCompletion();
  }

  // ====================
  // MANUAL COMPLETE (FOR TESTING)
  // ====================

  void manualComplete() {
    _logger.w('🧪 MANUAL COMPLETE TRIGGERED');
    if (!_hasCompletedOnce) {
      _onVideoCompleted();
    } else {
      _logger.w('⚠️ Already completed once');
    }
  }

  // ====================
  // TRACK SESSION COMPLETION
  // ====================

  Future<void> _trackSessionCompletion() async {
    try {
      final durationMinutes = session?.durationMinutes ?? (duration.inMinutes);

      _logger.i('🎯 Attempting to track session completion...');
      _logger.i('   Duration from session: ${session?.durationMinutes}');
      _logger.i('   Duration from video: ${duration.inMinutes}');
      _logger.i('   Final duration to track: $durationMinutes minutes');

      if (durationMinutes > 0) {
        await UserStatsService().recordSession(durationMinutes);
        _logger.i('✅ Session tracked successfully: $durationMinutes minutes');

        // Show confirmation to user
        Get.snackbar(
          '✅ Session Tracked!',
          '$durationMinutes minutes added to your stats',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        _logger.w('⚠️ Duration is 0, not tracking session');
      }
    } catch (e) {
      _logger.e('❌ Error tracking session: $e');
      Get.snackbar(
        'Tracking Error',
        'Failed to save session: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ====================
  // FORMAT DURATION
  // ====================

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}
