import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../core/services/downloads_service.dart';
import '../../core/routes/app_routes.dart';

class DownloadsController extends GetxController {
  final Logger _logger = Logger();
  final DownloadsService _downloadsService = Get.find<DownloadsService>();

  final RxList<MapEntry<String, dynamic>> downloadedItems =
      <MapEntry<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString totalStorage = '0 MB'.obs;

  @override
  void onInit() {
    super.onInit();
    loadDownloads();
  }

  Future<void> loadDownloads() async {
    isLoading.value = true;

    try {
      final downloads = await _downloadsService.getDownloadedItems();
      downloadedItems.value = downloads.entries.toList();

      // Calculate total storage
      final totalBytes = await _downloadsService.getTotalStorageUsed();
      totalStorage.value = _downloadsService.formatBytes(totalBytes);

      _logger.i(
        '📊 Loaded ${downloadedItems.length} downloads, total: ${totalStorage.value}',
      );
    } catch (e) {
      _logger.e('Error loading downloads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDownload(String id) async {
    final success = await _downloadsService.deleteDownload(id);
    if (success) {
      await loadDownloads();
      Get.snackbar('Deleted', 'Download removed successfully');
    } else {
      Get.snackbar('Error', 'Failed to delete download');
    }
  }

  Future<void> clearAllDownloads() async {
    await _downloadsService.clearAllDownloads();
    await loadDownloads();
    Get.snackbar('Cleared', 'All downloads removed');
  }

  // ✅ Play downloaded item
  void playDownloadedItem(String id, Map<String, dynamic> metadata) {
    final type = metadata['type'] as String?;

    _logger.i('🎵 Playing downloaded item: $id, type: $type');
    _logger.d('📋 Metadata: $metadata');

    switch (type) {
      case 'course_session':
        _playCourseSession(metadata);
        break;
      case 'sleep':
        _playSleepAudio(metadata);
        break;
      case 'podcast':
        _playPodcastEpisode(metadata);
        break;
      default:
        Get.snackbar(
          'Error',
          'Unknown content type',
          snackPosition: SnackPosition.BOTTOM,
        );
    }
  }

  void _playCourseSession(Map<String, dynamic> metadata) {
    // Navigate to unified player with downloaded file
    Get.toNamed(
      AppRoutes.unifiedPlayer,
      arguments: {
        'videoUrl': metadata['videoUrl'] ?? '', // ✅ ADDED
        'audioUrl': metadata['audioUrl'], // ✅ ADDED
        'sessionId': metadata['sessionId'],
        'title': metadata['sessionTitle'] ?? 'Session',
        'courseId': metadata['courseId'] ?? '',
        'instructor': metadata['instructor'] ?? '',
        'durationMinutes': metadata['duration'] ?? 0,
        'isDownloaded': true, // Flag to use local file
      },
    );
  }

  void _playSleepAudio(Map<String, dynamic> metadata) {
    // Navigate to sleep audio player
    Get.toNamed(
      AppRoutes.sleepAudioPlayer,
      arguments: {
        'sleepId': metadata['sleepId'],
        'title': metadata['title'] ?? '',
        'instructor': metadata['instructor'] ?? '',
        'duration': metadata['duration'] ?? 15,
        'isDownloaded': true, // Flag to use local file
      },
    );
  }

  void _playPodcastEpisode(Map<String, dynamic> metadata) {
    // Navigate to podcast audio player
    Get.toNamed(
      AppRoutes.podcastAudioPlayer,
      arguments: {
        'episodeId': metadata['podcastId'],
        'title': metadata['title'] ?? '',
        'description': metadata['description'] ?? '',
        'duration': metadata['duration'] ?? 0,
        'isDownloaded': true, // Flag to use local file
      },
    );
  }
}
