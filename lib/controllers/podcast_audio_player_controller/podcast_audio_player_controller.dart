import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/podcast_episode_model.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/history_service.dart';
import '../../core/services/user_stats_service.dart';

/// ====================
/// PODCAST AUDIO PLAYER CONTROLLER
/// ====================
///
/// Manages podcast audio playback with position saving/resuming

class PodcastAudioPlayerController extends GetxController {
  final Logger _logger = Logger();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // ====================
  // REACTIVE STATE
  // ====================

  final Rx<PodcastEpisodeModel?> _currentEpisode = Rx<PodcastEpisodeModel?>(
    null,
  );
  final RxList<PodcastEpisodeModel> _relatedEpisodes =
      <PodcastEpisodeModel>[].obs;
  final RxBool _isPlaying = false.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _isFavorite = false.obs;
  final Rx<Duration> _duration = Duration.zero.obs;
  final Rx<Duration> _position = Duration.zero.obs;

  // ✅ Tracking flag to prevent duplicate session tracking
  bool _hasCompletedOnce = false;

  // ====================
  // GETTERS
  // ====================

  PodcastEpisodeModel? get currentEpisode => _currentEpisode.value;
  List<PodcastEpisodeModel> get relatedEpisodes => _relatedEpisodes;
  bool get isPlaying => _isPlaying.value;
  bool get isLoading => _isLoading.value;
  bool get isFavorite => _isFavorite.value;
  Duration get duration => _duration.value;
  Duration get position => _position.value;
  AudioPlayer get audioPlayer => _audioPlayer;

  String get formattedPosition => _formatDuration(_position.value);
  String get formattedDuration => _formatDuration(_duration.value);

  // ====================
  // LIFECYCLE
  // ====================

  @override
  void onInit() {
    super.onInit();
    _setupAudioListeners();
    _loadEpisodeData();
  }

  @override
  void onClose() {
    // ✅ Save position before closing
    _saveCurrentPosition();
    _audioPlayer.dispose();
    super.onClose();
  }

  // ====================
  // LOAD EPISODE DATA
  // ====================

  Future<void> _loadEpisodeData() async {
    try {
      _isLoading.value = true;

      final args = Get.arguments as Map<String, dynamic>?;
      if (args == null || args['episode'] == null) {
        _logger.e('❌ No episode data in arguments');
        _isLoading.value = false;
        Get.back();
        return;
      }

      _currentEpisode.value = args['episode'] as PodcastEpisodeModel;
      _relatedEpisodes.value =
          (args['allEpisodes'] as List<PodcastEpisodeModel>?) ?? [];

      _logger.i('🎧 Loaded episode: ${_currentEpisode.value?.title}');

      // ✅ Set loading to false IMMEDIATELY after episode is set
      _isLoading.value = false;

      // Load these in the background
      await _checkFavoriteStatus();
      _loadAudio(); // Don't await - let it load in background
      _addToRecentlyPlayed();
      _addToHistory();
    } catch (e) {
      _logger.e('❌ Error loading episode: $e');
      _isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load episode',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ====================
  // LOAD AUDIO (✅ WITH RESUME POSITION!)
  // ====================

  Future<void> _loadAudio() async {
    try {
      if (_currentEpisode.value == null) return;

      _logger.i('🎵 Loading audio: ${_currentEpisode.value!.audioFile}');

      await _audioPlayer.setAsset(_currentEpisode.value!.audioFile);
      _duration.value = _audioPlayer.duration ?? Duration.zero;

      // ✅ Load saved position BEFORE playing
      final savedPosition = await _loadSavedPosition();
      if (savedPosition > Duration.zero) {
        _logger.i('⏩ Resuming from: ${_formatDuration(savedPosition)}');
        await _audioPlayer.seek(savedPosition);
      }

      // Auto-play
      await _audioPlayer.play();
      _isPlaying.value = true;

      _logger.i('✅ Audio loaded successfully');
    } catch (e) {
      _logger.e('❌ Error loading audio: $e');
      Get.snackbar(
        'Error',
        'Failed to load audio',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ====================
  // SETUP AUDIO LISTENERS (✅ IMPROVED!)
  // ====================

  void _setupAudioListeners() {
    // ✅ Listen to player state changes
    _audioPlayer.playerStateStream.listen((state) {
      // Update play/pause state
      _isPlaying.value = state.playing;

      _logger.i(
        '🎵 Player state: playing=${state.playing}, processing=${state.processingState}',
      );

      // ✅ Handle completion and track session
      if (!_hasCompletedOnce &&
          state.processingState == ProcessingState.completed) {
        _isPlaying.value = false;
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
        _clearSavedPosition(); // Clear saved position when completed

        // ✅ Track session completion
        _trackPodcastCompletion();
      }
    });

    // ✅ Listen to position changes and auto-save
    _audioPlayer.positionStream.listen((position) {
      _position.value = position;

      // ✅ Also check if near end (95% or within 3 seconds)
      if (!_hasCompletedOnce && _duration.value.inSeconds > 0) {
        final progress = position.inSeconds / _duration.value.inSeconds;
        final remaining = _duration.value.inSeconds - position.inSeconds;

        if (progress >= 0.95 || remaining <= 3) {
          _logger.w(
            '🎧 Podcast near completion! Progress: ${(progress * 100).toStringAsFixed(1)}%',
          );
          _trackPodcastCompletion();
        }
      }

      // Auto-save every 5 seconds while playing
      if (position.inSeconds % 5 == 0 && position.inSeconds > 0) {
        _saveCurrentPosition();
      }
    });

    // Listen to duration changes
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        _duration.value = duration;
      }
    });
  }

  // ✅ Track podcast completion
  Future<void> _trackPodcastCompletion() async {
    if (_hasCompletedOnce) return;

    _hasCompletedOnce = true;
    _logger.i('✅ Podcast completed');

    try {
      final actualDurationMinutes = _duration.value.inMinutes;
      final actualDurationSeconds = _duration.value.inSeconds;

      _logger.i('🎯 Tracking podcast completion...');
      _logger.i(
        '   Podcast duration: $actualDurationMinutes minutes ($actualDurationSeconds seconds)',
      );

      if (actualDurationMinutes > 0) {
        await UserStatsService().recordSession(actualDurationMinutes);
        _logger.i('✅ Podcast session tracked: $actualDurationMinutes minutes');

        Get.snackbar(
          '✅ Podcast Completed!',
          '$actualDurationMinutes minutes added to your stats',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else if (actualDurationSeconds > 0) {
        // If less than 1 minute, still count it as 1 minute
        _logger.w(
          '⚠️ Podcast less than 1 minute (${actualDurationSeconds}s), tracking as 1 minute',
        );
        await UserStatsService().recordSession(1);

        Get.snackbar(
          '✅ Podcast Completed!',
          '1 minute added to your stats',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      _logger.e('❌ Error tracking podcast session: $e');
    }
  }

  // ====================
  // PLAYBACK CONTROLS (✅ FIXED INSTANT UI UPDATE!)
  // ====================

  Future<void> togglePlayPause() async {
    try {
      if (_isPlaying.value) {
        // ✅ Update UI IMMEDIATELY
        _isPlaying.value = false;
        await _audioPlayer.pause();
        // ✅ Save position when pausing
        await _saveCurrentPosition();
        _logger.i('⏸️ Paused at: ${_formatDuration(_position.value)}');
      } else {
        // ✅ Update UI IMMEDIATELY
        _isPlaying.value = true;
        await _audioPlayer.play();
        _logger.i('▶️ Playing from: ${_formatDuration(_position.value)}');
      }
    } catch (e) {
      _logger.e('❌ Error toggling play/pause: $e');
      // ✅ Revert state on error
      _isPlaying.value = !_isPlaying.value;
    }
  }

  Future<void> skipBackward() async {
    try {
      final newPosition = _position.value - const Duration(seconds: 15);
      await _audioPlayer.seek(
        newPosition < Duration.zero ? Duration.zero : newPosition,
      );
      await _saveCurrentPosition(); // ✅ Save after seeking
    } catch (e) {
      _logger.e('❌ Error skipping backward: $e');
    }
  }

  Future<void> skipForward() async {
    try {
      final newPosition = _position.value + const Duration(seconds: 15);
      await _audioPlayer.seek(
        newPosition > _duration.value ? _duration.value : newPosition,
      );
      await _saveCurrentPosition(); // ✅ Save after seeking
    } catch (e) {
      _logger.e('❌ Error skipping forward: $e');
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      await _saveCurrentPosition(); // ✅ Save after seeking
    } catch (e) {
      _logger.e('❌ Error seeking: $e');
    }
  }

  // ====================
  // POSITION SAVE/LOAD (✅ NEW!)
  // ====================

  Future<Duration> _loadSavedPosition() async {
    try {
      if (_currentEpisode.value == null) return Duration.zero;

      final prefs = await SharedPreferences.getInstance();
      final key = 'podcast_position_${_currentEpisode.value!.id}';
      final savedSeconds = prefs.getInt(key) ?? 0;

      if (savedSeconds > 5) {
        return Duration(seconds: savedSeconds);
      }
    } catch (e) {
      _logger.e('❌ Error loading saved position: $e');
    }
    return Duration.zero;
  }

  Future<void> _saveCurrentPosition() async {
    try {
      if (_currentEpisode.value == null) return;
      if (_position.value.inSeconds < 5) return; // Don't save if less than 5s

      final prefs = await SharedPreferences.getInstance();
      final key = 'podcast_position_${_currentEpisode.value!.id}';
      await prefs.setInt(key, _position.value.inSeconds);

      _logger.i('💾 Saved position: ${_formatDuration(_position.value)}');
    } catch (e) {
      _logger.e('❌ Error saving position: $e');
    }
  }

  Future<void> _clearSavedPosition() async {
    try {
      if (_currentEpisode.value == null) return;

      final prefs = await SharedPreferences.getInstance();
      final key = 'podcast_position_${_currentEpisode.value!.id}';
      await prefs.remove(key);

      _logger.i('🗑️ Cleared saved position');
    } catch (e) {
      _logger.e('❌ Error clearing position: $e');
    }
  }

  // ====================
  // FAVORITES
  // ====================

  Future<void> _checkFavoriteStatus() async {
    if (_currentEpisode.value == null) return;

    final episodeId = 'podcast_${_currentEpisode.value!.id}';
    _isFavorite.value = await FavoritesService.isFavorite(episodeId);
    _logger.i('❤️ Favorite status: ${_isFavorite.value}');
  }

  Future<void> toggleFavorite() async {
    if (_currentEpisode.value == null) return;

    final episodeId = 'podcast_${_currentEpisode.value!.id}';
    final newStatus = await FavoritesService.toggleFavorite(episodeId);
    _isFavorite.value = newStatus;

    _logger.i('❤️ Favorite toggled: $newStatus for $episodeId');

    Get.snackbar(
      newStatus ? 'Added to Favorites' : 'Removed from Favorites',
      _currentEpisode.value!.title,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // ====================
  // RECENTLY PLAYED
  // ====================

  Future<void> _addToRecentlyPlayed() async {
    if (_currentEpisode.value == null) return;

    await FavoritesService.addRecentlyPlayed(
      sessionId: 'podcast_${_currentEpisode.value!.id}',
      courseId: 'podcast',
      title: _currentEpisode.value!.title,
      instructor: _currentEpisode.value!.host,
      durationMinutes: _parseDuration(_currentEpisode.value!.duration),
    );
  }

  // ====================
  // ADD TO HISTORY
  // ====================

  Future<void> _addToHistory() async {
    if (_currentEpisode.value == null) return;

    try {
      final historyService = Get.find<HistoryService>();
      await historyService.addToHistory(
        itemId: 'podcast_${_currentEpisode.value!.id}',
        title: _currentEpisode.value!.title,
        type: 'podcast',
        thumbnailUrl: _currentEpisode.value!.thumbnailImage,
        duration: _currentEpisode.value!.duration,
        additionalData: {
          'episodeId': _currentEpisode.value!.id,
          'description': _currentEpisode.value!.description,
          'host': _currentEpisode.value!.host,
          'subtitle': 'Podcast Episode',
        },
      );
      _logger.i('✅ Added to history: ${_currentEpisode.value!.title}');
    } catch (e) {
      _logger.e('Error adding to history: $e');
    }
  }

  // ====================
  // HANDLE RELATED EPISODE TAP (✅ WITH POSITION SAVING!)
  // ====================

  Future<void> playRelatedEpisode(PodcastEpisodeModel episode) async {
    _logger.i('🎧 Playing related episode: ${episode.title}');

    // ✅ Save current position before switching
    await _saveCurrentPosition();

    await _audioPlayer.stop();

    _currentEpisode.value = episode;

    await _checkFavoriteStatus();
    await _loadAudio();
    await _addToRecentlyPlayed();
    await _addToHistory();
  }

  // ====================
  // HELPERS
  // ====================

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  int _parseDuration(String duration) {
    final match = RegExp(r'(\d+)').firstMatch(duration);
    return match != null ? int.parse(match.group(1)!) : 0;
  }
}
