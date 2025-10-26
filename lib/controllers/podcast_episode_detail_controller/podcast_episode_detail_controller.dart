import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/podcast_episode_model.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/favorites_service.dart';

/// ====================
/// PODCAST EPISODE DETAIL CONTROLLER
/// ====================
/// 
/// Manages episode detail page with Play/Resume button

class PodcastEpisodeDetailController extends GetxController {
  final Logger _logger = Logger();
  
  // ====================
  // REACTIVE STATE
  // ====================
  
  final Rx<PodcastEpisodeModel?> _episode = Rx<PodcastEpisodeModel?>(null);
  final RxList<PodcastEpisodeModel> _allEpisodes = <PodcastEpisodeModel>[].obs;
  final RxBool _isLoading = true.obs;
  final RxBool _isFavorite = false.obs;
  final RxBool _hasResumePosition = false.obs;
  final RxString _savedPositionText = ''.obs;
  
  // ====================
  // GETTERS
  // ====================
  
  PodcastEpisodeModel? get episode => _episode.value;
  List<PodcastEpisodeModel> get allEpisodes => _allEpisodes;
  bool get isLoading => _isLoading.value;
  bool get isFavorite => _isFavorite.value;
  bool get hasResumePosition => _hasResumePosition.value;
  String get savedPositionText => _savedPositionText.value;
  String get buttonText => _hasResumePosition.value ? 'Resume' : 'Play';
  
  // ====================
  // LIFECYCLE
  // ====================
  
  @override
  void onInit() {
    super.onInit();
    _loadEpisodeData();
  }
  
  // ====================
  // LOAD EPISODE DATA
  // ====================
  
  Future<void> _loadEpisodeData() async {
    try {
      final args = Get.arguments as Map<String, dynamic>?;
      if (args == null || args['episode'] == null) {
        _logger.e('❌ No episode data in arguments');
        Get.back();
        return;
      }
      
      _episode.value = args['episode'] as PodcastEpisodeModel;
      _allEpisodes.value = (args['allEpisodes'] as List<PodcastEpisodeModel>?) ?? [];
      
      _logger.i('📻 Loaded episode: ${_episode.value?.title}');
      
      // Check for saved position
      await _checkSavedPosition();
      
      // Check favorite status
      await _checkFavoriteStatus();
      
      _isLoading.value = false;
      
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
  // CHECK SAVED POSITION
  // ====================
  
  Future<void> _checkSavedPosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'podcast_position_${_episode.value!.id}';
      final savedSeconds = prefs.getInt(key) ?? 0;
      
      if (savedSeconds > 5) {
        final duration = Duration(seconds: savedSeconds);
        _hasResumePosition.value = true;
        _savedPositionText.value = _formatDuration(duration);
        _logger.i('✅ Found saved position: $_savedPositionText');
      }
    } catch (e) {
      _logger.e('❌ Error checking saved position: $e');
    }
  }
  
  // ====================
  // PLAY/RESUME EPISODE
  // ====================
  
  void playEpisode() {
    _logger.i('🎧 ${_hasResumePosition.value ? "Resuming" : "Playing"} episode: ${_episode.value?.title}');
    
    // Navigate to audio player
    Get.toNamed(
      AppRoutes.podcastAudioPlayer,
      arguments: {
        'episode': _episode.value,
        'allEpisodes': _allEpisodes,
      },
    );
  }
  
  // ====================
  // PLAY RELATED EPISODE (✅ ADDED!)
  // ====================
  
  Future<void> playRelatedEpisode(PodcastEpisodeModel episode) async {
    _logger.i('🎧 Playing related episode: ${episode.title}');
    
    // Update current episode
    _episode.value = episode;
    
    // Reset loading
    _isLoading.value = true;
    
    // Check for saved position
    await _checkSavedPosition();
    
    // Check favorite status
    await _checkFavoriteStatus();
    
    _isLoading.value = false;
  }
  
  // ====================
  // FAVORITES
  // ====================
  
  Future<void> _checkFavoriteStatus() async {
    if (_episode.value == null) return;
    
    final episodeId = 'podcast_${_episode.value!.id}';
    _isFavorite.value = await FavoritesService.isFavorite(episodeId);
    _logger.i('❤️ Favorite status: ${_isFavorite.value}');
  }
  
  Future<void> toggleFavorite() async {
    if (_episode.value == null) return;
    
    final episodeId = 'podcast_${_episode.value!.id}';
    final newStatus = await FavoritesService.toggleFavorite(episodeId);
    _isFavorite.value = newStatus;
    
    _logger.i('❤️ Favorite toggled: $newStatus for $episodeId');
    
    Get.snackbar(
      newStatus ? 'Added to Favorites' : 'Removed from Favorites',
      _episode.value!.title,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
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
}