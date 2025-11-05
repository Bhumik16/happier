import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart' as video_player;
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import '../../data/models/course_session_model.dart';
import '../../data/models/course_model.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/downloads_service.dart';
import '../../core/services/history_service.dart';
import '../../core/services/user_stats_service.dart';

/// ====================
/// UNIFIED PLAYER CONTROLLER
/// ====================
/// Handles both video (Learn) and audio (Meditate) in one screen

class UnifiedPlayerController extends GetxController {
  final Logger _logger = Logger();

  // Video Player
  video_player.VideoPlayerController? _videoController;

  // Audio Player
  late AudioPlayer _audioPlayer;

  // ====================
  // REACTIVE STATE
  // ====================

  final RxInt _selectedTabIndex =
      0.obs; // 0 = Learn (Video), 1 = Meditate (Audio)
  final Rx<CourseSessionModel?> _session = Rx<CourseSessionModel?>(null);
  final Rx<CourseModel?> _course = Rx<CourseModel?>(null);

  // Video State
  final RxBool _videoInitialized = false.obs;
  final RxBool _videoPlaying = false.obs;
  final RxBool _videoLoading = false.obs;
  final RxBool _showVideoControls = true.obs;
  final Rx<Duration> _videoDuration = Duration.zero.obs;
  final Rx<Duration> _videoPosition = Duration.zero.obs;
  bool _hasVideoCompletedOnce = false;

  // Audio State
  final RxBool _audioInitialized = false.obs;
  final RxBool _audioPlaying = false.obs;
  final RxBool _audioLoading = false.obs;
  final Rx<Duration> _audioDuration = Duration.zero.obs;
  final Rx<Duration> _audioPosition = Duration.zero.obs;
  final RxDouble _audioSpeed = 1.0.obs;
  bool _hasAudioCompletedOnce = false; // ✅ Track audio completion

  // Favorites State
  final RxBool _isFavorite = false.obs;

  // ====================
  // GETTERS
  // ====================

  int get selectedTabIndex => _selectedTabIndex.value;
  bool get isLearnTab => _selectedTabIndex.value == 0;
  bool get isMeditateTab => _selectedTabIndex.value == 1;

  CourseSessionModel? get session => _session.value;
  CourseModel? get course => _course.value;

  // Video Getters
  video_player.VideoPlayerController? get videoController => _videoController;
  bool get videoInitialized => _videoInitialized.value;
  bool get videoPlaying => _videoPlaying.value;
  bool get videoLoading => _videoLoading.value;
  bool get showVideoControls => _showVideoControls.value;
  Duration get videoDuration => _videoDuration.value;
  Duration get videoPosition => _videoPosition.value;

  double get videoProgress {
    if (videoDuration.inMilliseconds == 0) return 0.0;
    return videoPosition.inMilliseconds / videoDuration.inMilliseconds;
  }

  String get videoPositionText => _formatDuration(videoPosition);
  String get videoDurationText => _formatDuration(videoDuration);

  // Audio Getters
  bool get audioInitialized => _audioInitialized.value;
  bool get audioPlaying => _audioPlaying.value;
  bool get audioLoading => _audioLoading.value;
  Duration get audioDuration => _audioDuration.value;
  Duration get audioPosition => _audioPosition.value;
  double get audioSpeed => _audioSpeed.value;

  double get audioProgress {
    if (audioDuration.inMilliseconds == 0) return 0.0;
    return audioPosition.inMilliseconds / audioDuration.inMilliseconds;
  }

  String get audioPositionText => _formatDuration(audioPosition);
  String get audioDurationText => _formatDuration(audioDuration);
  String get audioRemainingText =>
      _formatDuration(audioDuration - audioPosition);

  // Favorites Getter
  bool get isFavorite => _isFavorite.value;

  // ====================
  // LIFECYCLE
  // ====================

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer();
    _setupAudioListeners();

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      final isDownloaded = args['isDownloaded'] as bool? ?? false;

      if (args.containsKey('session')) {
        _session.value = args['session'] as CourseSessionModel?;
        _course.value = args['course'] as CourseModel?;

        _logger.i('Session videoUrl: ${_session.value?.videoUrl}');
        _logger.i('Session audioUrl: ${_session.value?.audioUrl}');
        _logger.i('Is downloaded: $isDownloaded');

        if (_session.value?.videoUrl != null) {
          loadVideo(
            _session.value!.videoUrl!,
            isDownloaded: isDownloaded,
            itemId: isDownloaded
                ? 'course_session_${_session.value!.id}'
                : null,
          );
        }

        if (_session.value?.audioUrl != null) {
          loadAudio(_session.value!.audioUrl!);
        } else {
          _logger.w('⚠️ No audio URL found for session');
        }

        checkFavoriteStatus();
        addToRecentlyPlayed();
        addToHistory();
      } else if (args.containsKey('videoUrl')) {
        final videoUrl = args['videoUrl'] as String;
        final audioUrl = args['audioUrl'] as String?;
        final title = args['title'] as String? ?? 'The Basics';
        final courseId = args['courseId'] as String? ?? 'getting_started';
        final sessionId = args['sessionId'] as String?;

        _logger.i('Direct videoUrl: $videoUrl');
        _logger.i('Direct audioUrl: $audioUrl');
        _logger.i('Is downloaded: $isDownloaded');

        _session.value = CourseSessionModel(
          id: sessionId ?? 'intro',
          courseId: courseId,
          sessionNumber: 0,
          title: title,
          description: 'Introduction to meditation',
          instructor: 'Happier Meditation',
          durationMinutes: 5,
          videoUrl: videoUrl,
          audioUrl: audioUrl,
          thumbnailUrl: null,
          isCompleted: false,
          isLocked: false,
        );

        loadVideo(
          videoUrl,
          isDownloaded: isDownloaded,
          itemId: isDownloaded ? 'course_session_$sessionId' : null,
        );

        if (audioUrl != null && audioUrl.isNotEmpty) {
          loadAudio(audioUrl);
        } else {
          _logger.w('⚠️ No audio URL provided');
        }

        checkFavoriteStatus();
        addToRecentlyPlayed();
        addToHistory();
      }
    }

    _logger.i('UnifiedPlayerController initialized');
  }

  @override
  void onClose() {
    _videoController?.dispose();
    _audioPlayer.dispose();
    _logger.i('UnifiedPlayerController disposed');
    super.onClose();
  }

  // ====================
  // TAB SWITCHING
  // ====================

  void switchToLearnTab() {
    _selectedTabIndex.value = 0;
    _logger.i('✅ Switched to Learn tab (Video)');

    if (_audioPlaying.value) {
      pauseAudio();
    }

    if (_videoInitialized.value && !_videoPlaying.value) {
      playVideo();
    }
  }

  void switchToMeditateTab() {
    _selectedTabIndex.value = 1;
    _logger.i('✅ Switched to Meditate tab (Audio)');

    if (_videoPlaying.value) {
      pauseVideo();
    }

    if (_audioInitialized.value && !_audioPlaying.value) {
      playAudio();
    }
  }

  // ====================
  // STOP PLAYBACK (FOR BACK BUTTON)
  // ====================

  void stopPlayback() {
    _logger.i('🛑 Stopping all playback');

    if (_videoPlaying.value) {
      pauseVideo();
    }

    if (_audioPlaying.value) {
      pauseAudio();
    }
  }

  // ====================
  // FAVORITES
  // ====================

  Future<void> toggleFavorite() async {
    if (_session.value == null) return;

    final sessionId = 'session_${_session.value!.id}';
    final newStatus = await FavoritesService.toggleFavorite(sessionId);
    _isFavorite.value = newStatus;

    _logger.i('❤️ Favorite toggled: $newStatus for $sessionId');

    Get.snackbar(
      newStatus ? 'Added to Favorites' : 'Removed from Favorites',
      _session.value!.title,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> checkFavoriteStatus() async {
    if (_session.value == null) return;

    final sessionId = 'session_${_session.value!.id}';
    _isFavorite.value = await FavoritesService.isFavorite(sessionId);
  }

  Future<void> addToRecentlyPlayed() async {
    if (_session.value == null) return;

    await FavoritesService.addRecentlyPlayed(
      sessionId: 'session_${_session.value!.id}',
      courseId: _session.value!.courseId,
      title: _session.value!.title,
      instructor: _session.value!.instructor,
      durationMinutes: _session.value!.durationMinutes,
    );
  }

  // ====================
  // ADD TO HISTORY
  // ====================

  Future<void> addToHistory() async {
    if (_session.value == null) return;

    try {
      final historyService = Get.find<HistoryService>();
      await historyService.addToHistory(
        itemId: 'session_${_session.value!.id}',
        title: _session.value!.title,
        type: 'session',
        thumbnailUrl: _session.value!.thumbnailUrl,
        duration: '${_session.value!.durationMinutes} min',
        additionalData: {
          'courseId': _session.value!.courseId,
          'courseTitle': _course.value?.title ?? '',
          'instructor': _session.value!.instructor,
          'sessionId': _session.value!.id,
        },
      );
      _logger.i('✅ Added to history: ${_session.value!.title}');
    } catch (e) {
      _logger.e('Error adding to history: $e');
    }
  }

  // ====================
  // VIDEO PLAYER METHODS
  // ====================

  Future<void> loadVideo(
    String videoUrl, {
    bool isDownloaded = false,
    String? itemId,
  }) async {
    try {
      _videoLoading.value = true;
      _hasVideoCompletedOnce = false;

      await _videoController?.dispose();

      if (isDownloaded && itemId != null) {
        // Load from local downloaded file
        _logger.i('📥 Loading downloaded video for: $itemId');
        final downloadsService = Get.find<DownloadsService>();
        final localPath = await downloadsService.getDownloadedFilePath(itemId);

        if (localPath != null && await File(localPath).exists()) {
          _logger.i('✅ Loading video from local file: $localPath');
          _videoController = video_player.VideoPlayerController.file(
            File(localPath),
          );
        } else {
          throw Exception('Downloaded file not found at: $localPath');
        }
      } else {
        // Stream from URL
        _logger.i('🌐 Loading video from URL: $videoUrl');
        _videoController = video_player.VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
        );
      }

      await _videoController!.initialize();
      _videoInitialized.value = true;

      _setupVideoListener();
      _videoDuration.value = _videoController!.value.duration;

      _logger.i('✅ Video loaded successfully');
      playVideo();
    } catch (e) {
      _logger.e('❌ Error loading video: $e');
      _videoInitialized.value = false;
      Get.snackbar(
        'Error',
        'Failed to load video: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _videoLoading.value = false;
    }
  }

  void _setupVideoListener() {
    _videoController?.addListener(() {
      if (_videoController != null) {
        _videoPlaying.value = _videoController!.value.isPlaying;
        _videoPosition.value = _videoController!.value.position;

        if (!_hasVideoCompletedOnce &&
            _videoController!.value.position >=
                _videoController!.value.duration &&
            _videoController!.value.duration.inMilliseconds > 0) {
          _onVideoCompleted();
        }
      }
    });
  }

  Future<void> playVideo() async {
    try {
      await _videoController?.play();
      _videoPlaying.value = true;

      Future.delayed(const Duration(seconds: 3), () {
        if (_videoPlaying.value) {
          _showVideoControls.value = false;
        }
      });
    } catch (e) {
      _logger.e('Error playing video: $e');
    }
  }

  Future<void> pauseVideo() async {
    try {
      await _videoController?.pause();
      _videoPlaying.value = false;
      _showVideoControls.value = true;
    } catch (e) {
      _logger.e('Error pausing video: $e');
    }
  }

  Future<void> toggleVideoPlayPause() async {
    if (_videoPlaying.value) {
      await pauseVideo();
    } else {
      await playVideo();
    }
  }

  Future<void> seekVideo(Duration position) async {
    try {
      await _videoController?.seekTo(position);
    } catch (e) {
      _logger.e('Error seeking video: $e');
    }
  }

  Future<void> seekVideoForward(int seconds) async {
    final newPosition = videoPosition + Duration(seconds: seconds);
    if (newPosition < videoDuration) {
      await seekVideo(newPosition);
    } else {
      await seekVideo(videoDuration);
    }
  }

  Future<void> seekVideoBackward(int seconds) async {
    final newPosition = videoPosition - Duration(seconds: seconds);
    if (newPosition > Duration.zero) {
      await seekVideo(newPosition);
    } else {
      await seekVideo(Duration.zero);
    }
  }

  void toggleVideoControls() {
    _showVideoControls.value = !_showVideoControls.value;
  }

  void _onVideoCompleted() {
    _hasVideoCompletedOnce = true;
    _logger.i('✅ Video completed');
    _showVideoControls.value = true;

    // ✅ TRACK SESSION COMPLETION
    _trackSessionCompletion();
  }

  // ====================
  // TRACK SESSION COMPLETION
  // ====================

  Future<void> _trackSessionCompletion() async {
    try {
      // ✅ USE AUDIO DURATION since videos are short (<1 min)
      // Audio has the actual meditation/session duration
      final actualDurationMinutes = audioDuration.inMinutes;
      final actualDurationSeconds = audioDuration.inSeconds;

      _logger.i('🎯 Tracking session completion...');
      _logger.i('   Video duration: ${videoDuration.inSeconds} seconds');
      _logger.i(
        '   Audio duration: $actualDurationSeconds seconds ($actualDurationMinutes minutes)',
      );
      _logger.i('   Using AUDIO duration for tracking');

      if (actualDurationMinutes > 0) {
        await UserStatsService().recordSession(actualDurationMinutes);
        _logger.i('✅ Session tracked: $actualDurationMinutes minutes');

        Get.snackbar(
          '✅ Session Tracked!',
          '$actualDurationMinutes minutes added to your stats',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else if (actualDurationSeconds > 0) {
        // If audio is less than 1 minute, still count it as 1 minute
        _logger.w(
          '⚠️ Audio less than 1 minute (${actualDurationSeconds}s), tracking as 1 minute',
        );
        await UserStatsService().recordSession(1);

        Get.snackbar(
          '✅ Session Tracked!',
          '1 minute added to your stats',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        _logger.w('⚠️ No audio duration available, cannot track session');
      }
    } catch (e) {
      _logger.e('❌ Error tracking session: $e');
    }
  }

  // ====================
  // AUDIO PLAYER METHODS
  // ====================

  Future<void> loadAudio(String audioUrl) async {
    try {
      _audioLoading.value = true;
      _audioInitialized.value = false;
      _hasAudioCompletedOnce = false; // ✅ Reset tracking flag for new audio
      _logger.i('🎵 Loading audio from URL: $audioUrl');

      final filename = audioUrl.split('/').last.replaceAll('.mp3', '');
      final assetPath = 'assets/audios/$filename.mp3';

      _logger.i('📂 Loading from assets: $assetPath');

      final duration = await _audioPlayer.setAsset(assetPath);

      if (duration != null) {
        _audioDuration.value = duration;
        _audioInitialized.value = true;
        _logger.i(
          '✅ Audio loaded successfully - Duration: ${_formatDuration(duration)}',
        );
      } else {
        _logger.w('⚠️ Audio loaded but duration is null');
        _audioInitialized.value = true;
      }
    } catch (e) {
      _logger.e('❌ Error loading audio: $e');
      _audioInitialized.value = false;
    } finally {
      _audioLoading.value = false;
    }
  }

  void _setupAudioListeners() {
    _audioPlayer.playerStateStream.listen((state) {
      _audioPlaying.value = state.playing;
      _logger.i('Audio playing state: ${state.playing}');

      // ✅ Check if audio completed
      if (!_hasAudioCompletedOnce &&
          state.processingState == ProcessingState.completed) {
        _onAudioCompleted();
      }
    });

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        _audioDuration.value = duration;
        _logger.i('Audio duration updated: ${_formatDuration(duration)}');
      }
    });

    _audioPlayer.positionStream.listen((position) {
      _audioPosition.value = position;

      // ✅ Also check if near end (95% or within 3 seconds)
      if (!_hasAudioCompletedOnce && _audioDuration.value.inSeconds > 0) {
        final progress = position.inSeconds / _audioDuration.value.inSeconds;
        final remaining = _audioDuration.value.inSeconds - position.inSeconds;

        if (progress >= 0.95 || remaining <= 3) {
          _logger.w(
            '🎵 Audio near completion! Progress: ${(progress * 100).toStringAsFixed(1)}%',
          );
          _onAudioCompleted();
        }
      }
    });
  }

  void _onAudioCompleted() {
    if (_hasAudioCompletedOnce) return;

    _hasAudioCompletedOnce = true;
    _logger.i('✅ Audio completed');

    // ✅ Track audio completion with ACTUAL duration
    _trackAudioCompletion();
  }

  Future<void> _trackAudioCompletion() async {
    try {
      // ✅ USE ACTUAL AUDIO DURATION
      final actualDurationMinutes = audioDuration.inMinutes;

      _logger.i('🎯 Tracking audio session completion...');
      _logger.i(
        '   ACTUAL audio duration: $actualDurationMinutes minutes (${audioDuration.inSeconds} seconds)',
      );

      if (actualDurationMinutes > 0) {
        await UserStatsService().recordSession(actualDurationMinutes);
        _logger.i('✅ Audio session tracked: $actualDurationMinutes minutes');

        Get.snackbar(
          '✅ Audio Session Tracked!',
          '$actualDurationMinutes minutes added to your stats',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        // If audio is less than 1 minute, still count it as 1 minute
        _logger.w(
          '⚠️ Audio less than 1 minute (${audioDuration.inSeconds}s), tracking as 1 minute',
        );
        await UserStatsService().recordSession(1);

        Get.snackbar(
          '✅ Audio Session Tracked!',
          '1 minute added to your stats',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      _logger.e('❌ Error tracking audio session: $e');
    }
  }

  Future<void> playAudio() async {
    try {
      _logger.i('▶️ Playing audio...');
      await _audioPlayer.play();
      _logger.i('✅ Audio playing');
    } catch (e) {
      _logger.e('❌ Error playing audio: $e');
    }
  }

  Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
      _logger.i('⏸️ Audio paused');
    } catch (e) {
      _logger.e('Error pausing audio: $e');
    }
  }

  Future<void> toggleAudioPlayPause() async {
    if (_audioPlaying.value) {
      await pauseAudio();
    } else {
      await playAudio();
    }
  }

  Future<void> seekAudio(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      _logger.e('Error seeking audio: $e');
    }
  }

  Future<void> seekAudioForward(int seconds) async {
    final newPosition = audioPosition + Duration(seconds: seconds);
    if (newPosition < audioDuration) {
      await seekAudio(newPosition);
    } else {
      await seekAudio(audioDuration);
    }
  }

  Future<void> seekAudioBackward(int seconds) async {
    final newPosition = audioPosition - Duration(seconds: seconds);
    if (newPosition > Duration.zero) {
      await seekAudio(newPosition);
    } else {
      await seekAudio(Duration.zero);
    }
  }

  void setAudioSpeed(double speed) {
    _audioSpeed.value = speed;
    _audioPlayer.setSpeed(speed);
    _logger.i('Audio speed set to: $speed');
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
