import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import '../../data/models/course_session_model.dart';
import '../../data/models/course_model.dart';
import '../../core/services/user_stats_service.dart';

/// ====================
/// AUDIO PLAYER CONTROLLER
/// ====================

class AudioPlayerController extends GetxController {
  final Logger _logger = Logger();
  late AudioPlayer _audioPlayer;
  bool _hasCompletedOnce = false; // ✅ Flag to prevent multiple completions

  // ====================
  // REACTIVE STATE
  // ====================

  final Rx<CourseSessionModel?> _session = Rx<CourseSessionModel?>(null);
  final Rx<CourseModel?> _course = Rx<CourseModel?>(null);
  final RxBool _isPlaying = false.obs;
  final RxBool _isLoading = false.obs;
  final Rx<Duration> _duration = Duration.zero.obs;
  final Rx<Duration> _position = Duration.zero.obs;
  final RxDouble _speed = 1.0.obs;

  // ====================
  // GETTERS
  // ====================

  CourseSessionModel? get session => _session.value;
  CourseModel? get course => _course.value;
  bool get isPlaying => _isPlaying.value;
  bool get isLoading => _isLoading.value;
  Duration get duration => _duration.value;
  Duration get position => _position.value;
  double get speed => _speed.value;

  double get progress {
    if (duration.inMilliseconds == 0) return 0.0;
    return position.inMilliseconds / duration.inMilliseconds;
  }

  String get positionText => _formatDuration(position);
  String get durationText => _formatDuration(duration);
  String get remainingText => _formatDuration(duration - position);

  // ====================
  // LIFECYCLE
  // ====================

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer();
    _setupListeners();

    // Get session from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      _session.value = args['session'] as CourseSessionModel?;
      _course.value = args['course'] as CourseModel?;

      if (_session.value?.audioUrl != null) {
        loadAudio(_session.value!.audioUrl!);
      }
    }

    _logger.i('AudioPlayerController initialized');
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    _hasCompletedOnce = false; // Reset flag
    _logger.i('AudioPlayerController disposed');
    super.onClose();
  }

  // ====================
  // SETUP LISTENERS
  // ====================

  void _setupListeners() {
    // Listen to player state
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying.value = state.playing;
      _isLoading.value =
          state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering;

      // Check completion
      if (!_hasCompletedOnce &&
          state.processingState == ProcessingState.completed) {
        _logger.w('🎵 Audio completed via state');
        _onAudioCompleted();
      }
    });

    // Listen to duration
    _audioPlayer.durationStream.listen((d) {
      if (d != null) {
        _duration.value = d;
      }
    });

    // Listen to position and check for near-completion
    _audioPlayer.positionStream.listen((p) {
      _position.value = p;

      // Also check if near end (95% or within 3 seconds)
      if (!_hasCompletedOnce && _duration.value.inSeconds > 0) {
        final progress = p.inSeconds / _duration.value.inSeconds;
        final remaining = _duration.value.inSeconds - p.inSeconds;

        if (progress >= 0.95 || remaining <= 3) {
          _logger.w(
            '🎵 Audio near completion! Progress: ${(progress * 100).toStringAsFixed(1)}%',
          );
          _onAudioCompleted();
        }
      }
    });
  }

  // ====================
  // LOAD AUDIO
  // ====================

  Future<void> loadAudio(String audioUrl) async {
    try {
      _isLoading.value = true;
      _hasCompletedOnce = false; // ✅ Reset flag for new audio
      _logger.i('Loading audio: $audioUrl');

      // Load from network URL (Cloudinary)
      await _audioPlayer.setUrl(audioUrl);

      _logger.i('Audio loaded successfully');
    } catch (e) {
      _logger.e('Error loading audio: $e');
      Get.snackbar(
        'Error',
        'Failed to load audio',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // ====================
  // PLAYBACK CONTROLS
  // ====================

  Future<void> play() async {
    try {
      await _audioPlayer.play();
      _logger.i('Audio playing');
    } catch (e) {
      _logger.e('Error playing audio: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      _logger.i('Audio paused');
    } catch (e) {
      _logger.e('Error pausing audio: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying.value) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _logger.i('Audio stopped');
    } catch (e) {
      _logger.e('Error stopping audio: $e');
    }
  }

  // ====================
  // SEEK
  // ====================

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
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
  // SPEED CONTROL
  // ====================

  Future<void> setSpeed(double speed) async {
    try {
      await _audioPlayer.setSpeed(speed);
      _speed.value = speed;
      _logger.i('Speed set to: $speed');
    } catch (e) {
      _logger.e('Error setting speed: $e');
    }
  }

  // ====================
  // SWITCH TO LEARN (Video Player)
  // ====================

  void switchToLearn() {
    _logger.i('Switching to Learn (Video Player)');

    // Navigate to video player with same session
    Get.offNamed(
      '/video-player',
      arguments: {'session': session, 'course': course},
    );
  }

  // ====================
  // COMPLETION HANDLER
  // ====================

  void _onAudioCompleted() {
    if (_hasCompletedOnce) {
      _logger.w('⚠️ Already completed, skipping');
      return;
    }

    _hasCompletedOnce = true; // ✅ Set flag
    _logger.i('✅ Audio completed');
    _position.value = Duration.zero;

    // ✅ Track session completion
    _trackSessionCompletion();

    Get.snackbar(
      'Session Complete',
      'Great job! You completed this meditation.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ====================
  // TRACK SESSION COMPLETION
  // ====================

  Future<void> _trackSessionCompletion() async {
    try {
      final durationMinutes = session?.durationMinutes ?? (duration.inMinutes);

      _logger.i('🎯 Attempting to track audio session completion...');
      _logger.i('   Duration from session: ${session?.durationMinutes}');
      _logger.i('   Duration from audio: ${duration.inMinutes}');
      _logger.i('   Final duration to track: $durationMinutes minutes');

      if (durationMinutes > 0) {
        await UserStatsService().recordSession(durationMinutes);
        _logger.i(
          '✅ Audio session tracked successfully: $durationMinutes minutes',
        );

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
      _logger.e('❌ Error tracking audio session: $e');
      Get.snackbar(
        'Tracking Error',
        'Failed to save session: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ====================
  // HELPER: FORMAT DURATION
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
