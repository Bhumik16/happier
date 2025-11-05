import 'dart:async';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import '../../data/models/sleep_model.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/history_service.dart';
import '../../core/services/user_stats_service.dart';

/// ====================
/// SLEEP AUDIO PLAYER CONTROLLER
/// ====================
///
/// Manages sleep audio playback with dynamic duration

class SleepAudioPlayerController extends GetxController {
  final Logger _logger = Logger();
  late final AudioPlayer _audioPlayer;

  // Stream subscriptions for proper disposal
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<bool>? _playingSubscription;
  Timer? _elapsedTimer;

  static const List<String> _audioFiles = [
    'assets/audios/intro_audio.mp3',
    'assets/audios/session_1_intro_meditation.mp3',
    'assets/audios/session_2_breath_awareness.mp3',
    'assets/audios/session_3_body_scan.mp3',
    'assets/audios/session_4_loving_kindness.mp3',
  ];

  // ====================
  // REACTIVE STATE
  // ====================

  final Rx<SleepModel> _sleep = SleepModel(
    id: '',
    title: '',
    instructor: '',
    instructorImage: '',
    durationRange: '',
  ).obs;

  final RxInt _durationMinutes = 15.obs;
  final RxBool _isPlaying = false.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isFavorite = false.obs;
  final RxDouble _elapsedSeconds = 0.0.obs;
  final RxDouble _totalDuration = 0.0.obs;

  Duration? _actualAudioDuration;

  // ✅ Tracking flag to prevent duplicate session tracking
  bool _hasCompletedOnce = false;

  // ====================
  // GETTERS
  // ====================

  SleepModel get sleep => _sleep.value;
  int get durationMinutes => _durationMinutes.value;
  bool get isPlaying => _isPlaying.value;
  bool get isLoading => _isLoading.value;
  bool get isFavorite => _isFavorite.value;
  double get progress => _totalDuration.value > 0
      ? (_elapsedSeconds.value / _totalDuration.value).clamp(0.0, 1.0)
      : 0.0;

  String get formattedTime {
    final remaining = (_totalDuration.value - _elapsedSeconds.value).clamp(
      0.0,
      _totalDuration.value,
    );
    final minutes = (remaining / 60).floor();
    final seconds = (remaining % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedCurrentTime {
    final minutes = (_elapsedSeconds.value / 60).floor();
    final seconds = (_elapsedSeconds.value % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedTotalTime {
    final minutes = (_totalDuration.value / 60).floor();
    final seconds = (_totalDuration.value % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // ====================
  // LIFECYCLE
  // ====================

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer();
    _loadSleepData();
  }

  @override
  void onClose() {
    _disposeAudio();
    super.onClose();
  }

  void _disposeAudio() {
    _positionSubscription?.cancel();
    _playingSubscription?.cancel();
    _elapsedTimer?.cancel();
    _audioPlayer.dispose();
    _logger.i('🧹 Audio resources disposed');
  }

  // ====================
  // LOAD SLEEP DATA
  // ====================

  Future<void> _loadSleepData() async {
    try {
      _isLoading.value = true;

      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null) {
        if (args['sleep'] != null) {
          _sleep.value = args['sleep'] as SleepModel;
        }
        if (args['duration'] != null) {
          _durationMinutes.value = args['duration'] as int;
        }
      }

      _logger.i(
        '💤 Loading sleep audio: ${_sleep.value.title} for ${_durationMinutes.value} min',
      );

      await _checkFavoriteStatus();
      await _loadAudio();
      await _addToRecentlyPlayed();
      await _addToHistory();
    } catch (e) {
      _logger.e('Error loading sleep audio: $e');
      Get.snackbar(
        'Error',
        'Failed to load audio: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  String _getAudioFileForSession() {
    final sleepIdHash = sleep.id.hashCode.abs();
    final audioIndex = sleepIdHash % _audioFiles.length;

    _logger.i('🎵 Selected audio index $audioIndex for sleep ID: ${sleep.id}');
    return _audioFiles[audioIndex];
  }

  Future<void> _loadAudio() async {
    try {
      _logger.i('🎵 Loading audio from assets...');

      final audioFile = _getAudioFileForSession();
      _logger.i('🎧 Using audio file: $audioFile');

      await _audioPlayer.setAsset(audioFile);

      _actualAudioDuration = _audioPlayer.duration;
      _logger.i(
        '📏 Actual audio duration: ${_actualAudioDuration?.inSeconds}s',
      );

      await _audioPlayer.setLoopMode(LoopMode.one);

      _totalDuration.value = _durationMinutes.value * 60.0;

      _setupAudioListeners();
      _startElapsedTimer();

      _logger.i(
        '✅ Audio loaded successfully, will play for: ${_totalDuration.value}s',
      );

      await _audioPlayer.play();
      _isPlaying.value = true;
    } catch (e) {
      _logger.e('❌ Error loading audio: $e');
      Get.snackbar(
        'Error',
        'Failed to load audio file. Please check if all audio files exist in assets/audios/',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _startElapsedTimer() {
    _elapsedTimer?.cancel();

    _elapsedTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isPlaying.value && _elapsedSeconds.value < _totalDuration.value) {
        _elapsedSeconds.value += 0.1;

        // ✅ Check if near completion (95% or within 3 seconds)
        final progress = _elapsedSeconds.value / _totalDuration.value;
        final remaining = _totalDuration.value - _elapsedSeconds.value;

        if (!_hasCompletedOnce && (progress >= 0.95 || remaining <= 3)) {
          _logger.w(
            '💤 Sleep session near completion! Progress: ${(progress * 100).toStringAsFixed(1)}%',
          );
          _trackSleepCompletion();
        }

        if (_elapsedSeconds.value >= _totalDuration.value) {
          _audioPlayer.pause();
          _audioPlayer.setLoopMode(LoopMode.off);
          _isPlaying.value = false;
          _elapsedTimer?.cancel();
          _logger.i(
            '⏸️ Stopped at selected duration: ${_totalDuration.value}s',
          );

          // ✅ Track completion if not already tracked
          if (!_hasCompletedOnce) {
            _trackSleepCompletion();
          }
        }
      }
    });
  }

  // ✅ Track sleep session completion
  Future<void> _trackSleepCompletion() async {
    if (_hasCompletedOnce) return;

    _hasCompletedOnce = true;
    _logger.i('✅ Sleep session completed');

    try {
      // Use the selected duration (not audio duration, as sleep loops)
      final actualDurationMinutes = _durationMinutes.value;

      _logger.i('🎯 Tracking sleep session completion...');
      _logger.i('   Selected duration: $actualDurationMinutes minutes');

      await UserStatsService().recordSession(actualDurationMinutes);
      _logger.i('✅ Sleep session tracked: $actualDurationMinutes minutes');

      Get.snackbar(
        '✅ Sleep Session Completed!',
        '$actualDurationMinutes minutes added to your stats',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _logger.e('❌ Error tracking sleep session: $e');
    }
  }

  void _setupAudioListeners() {
    _positionSubscription?.cancel();
    _playingSubscription?.cancel();

    _playingSubscription = _audioPlayer.playingStream.listen(
      (playing) {
        _isPlaying.value = playing;
        _logger.i('🎵 Audio playing state: $playing');
      },
      onError: (error) {
        _logger.e('Playing stream error: $error');
      },
    );
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final sleepId = 'sleep_${sleep.id}';
      _isFavorite.value = await FavoritesService.isFavorite(sleepId);
      _logger.i('💖 Favorite status checked: ${_isFavorite.value}');
    } catch (e) {
      _logger.e('Error checking favorite status: $e');
    }
  }

  Future<void> _addToRecentlyPlayed() async {
    try {
      final sleepId = 'sleep_${sleep.id}';
      await FavoritesService.addRecentlyPlayed(
        sessionId: sleepId,
        courseId: sleep.id,
        title: sleep.title,
        instructor: sleep.instructor,
        durationMinutes: _durationMinutes.value,
      );
      _logger.i('✅ Added to recently played: $sleepId');
    } catch (e) {
      _logger.e('Error adding to recently played: $e');
    }
  }

  // ====================
  // ADD TO HISTORY
  // ====================

  Future<void> _addToHistory() async {
    try {
      final historyService = Get.find<HistoryService>();
      await historyService.addToHistory(
        itemId: 'sleep_${sleep.id}',
        title: sleep.title,
        type: 'sleep',
        duration: '${_durationMinutes.value} min',
        additionalData: {
          'sleepId': sleep.id,
          'instructor': sleep.instructor,
          'subtitle': 'Sleep Meditation',
        },
      );
      _logger.i('✅ Added to history: ${sleep.title}');
    } catch (e) {
      _logger.e('Error adding to history: $e');
    }
  }

  Future<void> toggleFavorite() async {
    try {
      final sleepId = 'sleep_${sleep.id}';
      final newStatus = await FavoritesService.toggleFavorite(sleepId);
      _isFavorite.value = newStatus;

      _logger.i('❤️ Sleep favorite toggled: $newStatus');

      Get.snackbar(
        newStatus ? 'Added to Favorites' : 'Removed from Favorites',
        sleep.title,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      _logger.e('Error toggling favorite: $e');
    }
  }

  void togglePlayPause() {
    try {
      if (_isPlaying.value) {
        _audioPlayer.pause();
        _logger.i('⏸️ Paused');
      } else {
        if (_elapsedSeconds.value >= _totalDuration.value) {
          _elapsedSeconds.value = 0.0;
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.setLoopMode(LoopMode.one);
        }
        _audioPlayer.play();
        _logger.i('▶️ Playing');
      }
    } catch (e) {
      _logger.e('Error toggling play/pause: $e');
    }
  }

  void skipBackward() {
    try {
      final newElapsed = (_elapsedSeconds.value - 15).clamp(
        0.0,
        _totalDuration.value,
      );
      _elapsedSeconds.value = newElapsed;

      if (_actualAudioDuration != null) {
        final audioDurationSeconds = _actualAudioDuration!.inSeconds.toDouble();
        final audioPosition = newElapsed % audioDurationSeconds;
        _audioPlayer.seek(Duration(seconds: audioPosition.toInt()));
        _logger.i(
          '⏪ Skipped backward - Elapsed: ${newElapsed}s, Audio pos: ${audioPosition}s',
        );
      }
    } catch (e) {
      _logger.e('Error skipping backward: $e');
    }
  }

  void skipForward() {
    try {
      final newElapsed = (_elapsedSeconds.value + 15).clamp(
        0.0,
        _totalDuration.value,
      );
      _elapsedSeconds.value = newElapsed;

      if (_actualAudioDuration != null) {
        final audioDurationSeconds = _actualAudioDuration!.inSeconds.toDouble();
        final audioPosition = newElapsed % audioDurationSeconds;
        _audioPlayer.seek(Duration(seconds: audioPosition.toInt()));
        _logger.i(
          '⏩ Skipped forward - Elapsed: ${newElapsed}s, Audio pos: ${audioPosition}s',
        );
      }
    } catch (e) {
      _logger.e('Error skipping forward: $e');
    }
  }

  void seekTo(double value) {
    try {
      final newElapsed = (value * _totalDuration.value);
      _elapsedSeconds.value = newElapsed;

      if (_actualAudioDuration != null) {
        final audioDurationSeconds = _actualAudioDuration!.inSeconds.toDouble();
        final audioPosition = newElapsed % audioDurationSeconds;
        _audioPlayer.seek(Duration(seconds: audioPosition.toInt()));
        _logger.i(
          '🎯 Seeked - Elapsed: ${newElapsed}s, Audio pos: ${audioPosition}s',
        );
      }
    } catch (e) {
      _logger.e('Error seeking: $e');
    }
  }

  void stopPlayback() {
    try {
      _audioPlayer.pause();
      _audioPlayer.setLoopMode(LoopMode.off);
      _elapsedTimer?.cancel();
      _isPlaying.value = false;
      _logger.i('⏹️ Playback stopped');
    } catch (e) {
      _logger.e('Error stopping playback: $e');
    }
  }
}
