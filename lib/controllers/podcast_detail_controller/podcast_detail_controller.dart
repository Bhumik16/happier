// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../data/models/short_model.dart';
import '../../data/models/podcast_episode_model.dart';
import '../../core/services/mock_shorts_service.dart';
import '../../core/routes/app_routes.dart';

/// ====================
/// PODCAST DETAIL CONTROLLER
/// ====================
/// 
/// Manages podcast detail page logic

class PodcastDetailController extends GetxController {
  final Logger _logger = Logger();
  
  // ====================
  // REACTIVE STATE
  // ====================
  
  final Rx<ShortModel?> _podcast = Rx<ShortModel?>(null);
  final RxList<PodcastEpisodeModel> _episodes = <PodcastEpisodeModel>[].obs;
  final RxBool _isLoading = false.obs;
  
  // ====================
  // GETTERS
  // ====================
  
  ShortModel? get podcast => _podcast.value;
  List<PodcastEpisodeModel> get episodes => _episodes;
  bool get isLoading => _isLoading.value;
  
  // ====================
  // LIFECYCLE
  // ====================
  
  @override
  void onInit() {
    super.onInit();
    _loadPodcastData();
  }
  
  @override
  void onClose() {
    super.onClose();
  }
  
  // ====================
  // LOAD PODCAST DATA
  // ====================
  
  void _loadPodcastData() {
    try {
      _isLoading.value = true;
      
      // Get podcast from arguments
      final args = Get.arguments as Map<String, dynamic>?;
      if (args == null || args['podcast'] == null) {
        _logger.e('❌ No podcast data in arguments');
        Get.back();
        return;
      }
      
      _podcast.value = args['podcast'] as ShortModel;
      _logger.i('📻 Loaded podcast: ${_podcast.value?.title}');
      
      // Load episodes for this podcast
      _loadEpisodesForPodcast(_podcast.value!.id);
      
    } catch (e) {
      _logger.e('❌ Error loading podcast: $e');
      Get.snackbar(
        'Error',
        'Failed to load podcast',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
  
  // ====================
  // LOAD EPISODES
  // ====================
  
  void _loadEpisodesForPodcast(String podcastId) {
    _episodes.value = MockShortsService.getEpisodesForPodcast(podcastId);
    _logger.i('📋 Loaded ${_episodes.length} episodes');
  }
  
  // ====================
  // HANDLE EPISODE TAP (✅ UPDATED - Navigate to Episode Detail!)
  // ====================
  
  void onEpisodeTap(PodcastEpisodeModel episode) {
    _logger.i('🎧 Tapped episode: ${episode.title}');
    
    // Navigate to episode detail page (not directly to audio player)
    Get.toNamed(
      AppRoutes.podcastEpisodeDetail,
      arguments: {
        'episode': episode,
        'allEpisodes': _episodes,
      },
    );
  }
}