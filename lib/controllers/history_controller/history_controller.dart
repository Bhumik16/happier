import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/services/history_service.dart';
import '../../core/services/favorites_service.dart';
import '../../core/routes/app_routes.dart';

class HistoryController extends GetxController {
  final HistoryService _historyService = Get.find<HistoryService>();
  
  final RxList<Map<String, dynamic>> historyItems = <Map<String, dynamic>>[].obs;
  final RxMap<String, List<Map<String, dynamic>>> groupedHistory = <String, List<Map<String, dynamic>>>{}.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, bool> favoriteStatus = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    
    try {
      historyItems.value = await _historyService.getHistory();
      _groupHistoryByMonth();
      await _loadFavoriteStatus();
    } catch (e) {
      print('Error loading history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _groupHistoryByMonth() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    
    for (final item in historyItems) {
      try {
        final completedAt = DateTime.parse(item['completedAt'] as String);
        final monthYear = DateFormat('MMMM yyyy').format(completedAt);
        
        if (!grouped.containsKey(monthYear)) {
          grouped[monthYear] = [];
        }
        grouped[monthYear]!.add(item);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
    
    groupedHistory.value = grouped;
  }

  Future<void> _loadFavoriteStatus() async {
    for (final item in historyItems) {
      final itemId = item['id'] as String;
      final isFav = await FavoritesService.isFavorite(itemId);
      favoriteStatus[itemId] = isFav;
    }
    favoriteStatus.refresh();
  }

  Future<void> toggleFavorite(String itemId) async {
    final newStatus = await FavoritesService.toggleFavorite(itemId);
    favoriteStatus[itemId] = newStatus;
    favoriteStatus.refresh();
  }

  Future<void> clearHistory() async {
    await _historyService.clearHistory();
    historyItems.clear();
    groupedHistory.clear();
    Get.snackbar('Cleared', 'History cleared successfully');
  }
  
  Future<void> removeItem(String itemId) async {
    await _historyService.removeFromHistory(itemId);
    await loadHistory();
  }

  void playHistoryItem(Map<String, dynamic> item) {
    final type = item['type'] as String?;
    final itemId = item['id'] as String;
    
    print('🎵 Playing history item: $itemId, type: $type');
    
    switch (type) {
      case 'course':
      case 'session':
        _playCourseSession(item);
        break;
      case 'sleep':
        _playSleepAudio(item);
        break;
      case 'podcast':
        _playPodcastEpisode(item);
        break;
      case 'single':
      case 'short':
        _playSingle(item);
        break;
      default:
        Get.snackbar('Error', 'Cannot play this item type', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _playCourseSession(Map<String, dynamic> item) {
    // Navigate to unified player
    Get.toNamed(
      AppRoutes.unifiedPlayer,
      arguments: {
        'sessionId': item['sessionId'] ?? item['id'],
        'title': item['title'],
        'courseId': item['courseId'] ?? 'unknown',
      },
    );
  }

  void _playSleepAudio(Map<String, dynamic> item) {
    Get.toNamed(
      AppRoutes.sleepAudioPlayer,
      arguments: {
        'sleepId': item['sleepId'] ?? item['id'],
        'title': item['title'],
      },
    );
  }

  void _playPodcastEpisode(Map<String, dynamic> item) {
    Get.toNamed(
      AppRoutes.podcastAudioPlayer,
      arguments: {
        'episodeId': item['episodeId'] ?? item['id'],
        'title': item['title'],
      },
    );
  }

  void _playSingle(Map<String, dynamic> item) {
    Get.snackbar('Play Single', 'Playing ${item['title']}...', snackPosition: SnackPosition.BOTTOM);
  }
}