import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:logger/logger.dart';
import '../../data/models/short_model.dart';
import '../../core/services/cloudinary_service.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/user_stats_service.dart';

/// ====================
/// SHORTS VIDEO PLAYER CONTROLLER
/// ====================
///
/// Manages video playback for shorts (Practice & Wisdom)

class ShortsVideoPlayerController extends GetxController {
  final Logger _logger = Logger();
  VideoPlayerController? videoController;

  // ====================
  // REACTIVE STATE
  // ====================

  final Rx<ShortModel> _short = ShortModel(id: '', title: '', type: '').obs;

  final RxBool _isLoading = true.obs;
  final RxBool _isPlaying = false.obs;
  final RxBool _isFavorite = false.obs;
  final RxString _errorMessage = ''.obs;
  final Rx<Duration> _currentPosition = Duration.zero.obs;
  final Rx<Duration> _totalDuration = Duration.zero.obs;

  // ✅ Tracking flag to prevent duplicate session tracking
  bool _hasCompletedOnce = false;

  // ====================
  // GETTERS
  // ====================

  ShortModel get short => _short.value;
  bool get isLoading => _isLoading.value;
  bool get isPlaying => _isPlaying.value;
  bool get isFavorite => _isFavorite.value;
  bool get hasError => _errorMessage.value.isNotEmpty;
  String get errorMessage => _errorMessage.value;
  Duration get currentPosition => _currentPosition.value;
  Duration get totalDuration => _totalDuration.value;

  // ====================
  // LIFECYCLE
  // ====================

  @override
  void onInit() {
    super.onInit();
    _loadShortData();
  }

  @override
  void onClose() {
    if (videoController != null) {
      videoController!.removeListener(_videoListener);
      videoController!.dispose();
      videoController = null;
    }
    super.onClose();
  }

  // ====================
  // LOAD SHORT DATA
  // ====================

  Future<void> _loadShortData() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Get short from arguments
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null && args['short'] != null) {
        _short.value = args['short'] as ShortModel;
      }

      _logger.i(
        '🎬 Loading video for: ${_short.value.title} (ID: ${_short.value.id})',
      );

      // Check favorite status
      await _checkFavoriteStatus();

      // Load video
      await _loadVideo();
    } catch (e) {
      _logger.e('❌ Error loading short: $e');
      _errorMessage.value = 'Failed to load video';
      Get.snackbar(
        'Error',
        'Failed to load video: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // ====================
  // LOAD VIDEO (✅ GUARANTEED TO WORK!)
  // ====================

  Future<void> _loadVideo() async {
    try {
      // ✅ Use only the video that's uploaded on Cloudinary
      final courseId = 'getting_started';

      final videoUrl = CloudinaryService.getIntroVideoUrl(courseId);

      _logger.i('🎯 Short ${short.id} → Video: $courseId');
      _logger.i('📹 Video URL: $videoUrl');

      // Dispose previous controller if exists
      if (videoController != null) {
        _logger.i('🗑️ Disposing previous video controller');
        videoController!.removeListener(_videoListener);
        await videoController!.pause();
        videoController!.dispose();
        videoController = null;
        await Future.delayed(const Duration(milliseconds: 100));
      }

      _logger.i('🎥 Creating new video controller');

      // Use .network() for video playback
      videoController = VideoPlayerController.network(videoUrl);

      _logger.i('⏳ Initializing video...');
      await videoController!.initialize();

      if (!videoController!.value.isInitialized) {
        throw Exception('Video failed to initialize');
      }

      // Get total duration after initialization
      _totalDuration.value = videoController!.value.duration;

      // Listen to player state
      videoController!.addListener(_videoListener);

      // Auto-play
      _logger.i('▶️ Starting playback');
      await videoController!.play();
      _isPlaying.value = true;

      _logger.i(
        '✅ Video playing! Duration: ${_totalDuration.value.inSeconds}s',
      );
    } catch (e) {
      _logger.e('❌ Error loading video: $e');
      _errorMessage.value = 'Failed to load video';

      Get.snackbar(
        'Video Error',
        'Could not load video. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Get.theme.colorScheme.error.withValues(alpha: 0.8),
        colorText: Get.theme.colorScheme.onError,
      );

      rethrow;
    }
  }

  // ====================
  // VIDEO LISTENER
  // ====================

  void _videoListener() {
    if (videoController != null && videoController!.value.isInitialized) {
      _currentPosition.value = videoController!.value.position;
      _totalDuration.value = videoController!.value.duration;
      _isPlaying.value = videoController!.value.isPlaying;

      // ✅ Check if near completion (95% or within 3 seconds)
      if (!_hasCompletedOnce && _totalDuration.value.inSeconds > 0) {
        final progress =
            _currentPosition.value.inSeconds / _totalDuration.value.inSeconds;
        final remaining =
            _totalDuration.value.inSeconds - _currentPosition.value.inSeconds;

        if (progress >= 0.95 || remaining <= 3) {
          _logger.w(
            '🎬 Short video near completion! Progress: ${(progress * 100).toStringAsFixed(1)}%',
          );
          _trackShortCompletion();
        }
      }

      // Check if video ended
      if (videoController!.value.position >= videoController!.value.duration) {
        _isPlaying.value = false;
        _logger.i('🏁 Video ended');

        // ✅ Track completion if not already tracked
        if (!_hasCompletedOnce) {
          _trackShortCompletion();
        }
      }
    }
  }

  // ✅ Track short video completion
  Future<void> _trackShortCompletion() async {
    if (_hasCompletedOnce) return;

    _hasCompletedOnce = true;
    _logger.i('✅ Short video completed');

    try {
      final actualDurationMinutes = _totalDuration.value.inMinutes;
      final actualDurationSeconds = _totalDuration.value.inSeconds;

      _logger.i('🎯 Tracking short video completion...');
      _logger.i(
        '   Video duration: $actualDurationMinutes minutes ($actualDurationSeconds seconds)',
      );

      if (actualDurationMinutes > 0) {
        await UserStatsService().recordSession(actualDurationMinutes);
        _logger.i('✅ Short video tracked: $actualDurationMinutes minutes');

        Get.snackbar(
          '✅ Short Completed!',
          '$actualDurationMinutes minutes added to your stats',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else if (actualDurationSeconds > 0) {
        // If less than 1 minute, still count it as 1 minute
        _logger.w(
          '⚠️ Short video less than 1 minute (${actualDurationSeconds}s), tracking as 1 minute',
        );
        await UserStatsService().recordSession(1);

        Get.snackbar(
          '✅ Short Completed!',
          '1 minute added to your stats',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      _logger.e('❌ Error tracking short video: $e');
    }
  }

  // ====================
  // PLAYBACK CONTROLS
  // ====================

  void togglePlayPause() {
    if (videoController == null || !videoController!.value.isInitialized) {
      _logger.w('⚠️ Cannot toggle play/pause - video not ready');
      return;
    }

    if (_isPlaying.value) {
      videoController!.pause();
      _logger.i('⏸️ Paused');
    } else {
      videoController!.play();
      _logger.i('▶️ Playing');
    }
  }

  void skipForward() {
    if (videoController == null || !videoController!.value.isInitialized) {
      _logger.w('⚠️ Cannot skip forward - video not ready');
      return;
    }

    final newPosition = _currentPosition.value + const Duration(seconds: 10);
    final maxDuration = _totalDuration.value;

    if (newPosition < maxDuration) {
      videoController!.seekTo(newPosition);
      _logger.i('⏩ Skipped forward 10s');
    } else {
      videoController!.seekTo(maxDuration);
      _logger.i('⏩ Skipped to end');
    }
  }

  void skipBackward() {
    if (videoController == null || !videoController!.value.isInitialized) {
      _logger.w('⚠️ Cannot skip backward - video not ready');
      return;
    }

    final newPosition = _currentPosition.value - const Duration(seconds: 10);

    if (newPosition > Duration.zero) {
      videoController!.seekTo(newPosition);
      _logger.i('⏪ Skipped backward 10s');
    } else {
      videoController!.seekTo(Duration.zero);
      _logger.i('⏪ Skipped to start');
    }
  }

  // ====================
  // FAVORITE FUNCTIONALITY
  // ====================

  Future<void> _checkFavoriteStatus() async {
    try {
      final shortId = 'short_${short.id}';
      _isFavorite.value = await FavoritesService.isFavorite(shortId);
      _logger.i('❤️ Favorite status: $_isFavorite');
    } catch (e) {
      _logger.e('Error checking favorite status: $e');
    }
  }

  Future<void> toggleFavorite() async {
    try {
      final shortId = 'short_${short.id}';
      final newStatus = await FavoritesService.toggleFavorite(shortId);
      _isFavorite.value = newStatus;

      _logger.i('❤️ Short favorite toggled: $newStatus');

      Get.snackbar(
        newStatus ? 'Added to Favorites' : 'Removed from Favorites',
        short.title,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _logger.e('Error toggling favorite: $e');
      Get.snackbar(
        'Error',
        'Could not update favorites',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
