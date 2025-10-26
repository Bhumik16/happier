import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import '../../data/models/course_session_model.dart';
import '../../data/models/course_model.dart';

/// ====================
/// AUDIO PLAYER CONTROLLER
/// ====================

class AudioPlayerController extends GetxController {
  final Logger _logger = Logger();
  late AudioPlayer _audioPlayer;
  
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
      _isLoading.value = state.processingState == ProcessingState.loading ||
                         state.processingState == ProcessingState.buffering;
    });
    
    // Listen to duration
    _audioPlayer.durationStream.listen((d) {
      if (d != null) {
        _duration.value = d;
      }
    });
    
    // Listen to position
    _audioPlayer.positionStream.listen((p) {
      _position.value = p;
    });
    
    // Listen to completion
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _onAudioCompleted();
      }
    });
  }
  
  // ====================
  // LOAD AUDIO
  // ====================
  
  Future<void> loadAudio(String audioUrl) async {
    try {
      _isLoading.value = true;
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
      arguments: {
        'session': session,
        'course': course,
      },
    );
  }
  
  // ====================
  // COMPLETION HANDLER
  // ====================
  
  void _onAudioCompleted() {
    _logger.i('Audio completed');
    _position.value = Duration.zero;
    Get.snackbar(
      'Session Complete',
      'Great job! You completed this meditation.',
      snackPosition: SnackPosition.BOTTOM,
    );
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