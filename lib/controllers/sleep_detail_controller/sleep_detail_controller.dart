import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../data/models/sleep_model.dart';
import '../../core/services/favorites_service.dart';
import '../../core/routes/app_routes.dart';

/// ====================
/// SLEEP DETAIL CONTROLLER
/// ====================
/// 
/// Manages sleep detail page state and duration selection

class SleepDetailController extends GetxController {
  final Logger _logger = Logger();
  
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
  
  final RxInt _selectedDuration = 15.obs;
  final RxBool _isFavorite = false.obs;
  
  // ====================
  // GETTERS
  // ====================
  
  SleepModel get sleep => _sleep.value;
  int get selectedDuration => _selectedDuration.value;
  bool get isFavorite => _isFavorite.value;
  
  // Check if sleep has duration options (e.g., "5-20 min")
  bool get hasDurationOptions => sleep.durationRange.contains('-');
  
  List<int> get durationOptions {
    if (!hasDurationOptions) return [];
    
    // Parse duration range like "5-20 min" or "15 - 30 min"
    final parts = sleep.durationRange.split('-');
    if (parts.length != 2) return [5, 10, 15, 20];
    
    try {
      final min = int.parse(parts[0].trim());
      final max = int.parse(parts[1].replaceAll('min', '').trim());
      
      // Generate options: 5, 10, 15, 20, 25, 30 within range
      List<int> options = [];
      for (int i = 5; i <= 30; i += 5) {
        if (i >= min && i <= max) {
          options.add(i);
        }
      }
      return options.isEmpty ? [5, 10, 15, 20] : options;
    } catch (e) {
      return [5, 10, 15, 20];
    }
  }
  
  // ====================
  // LIFECYCLE
  // ====================
  
  @override
  void onInit() {
    super.onInit();
    _loadSleepData();
  }
  
  // ====================
  // LOAD SLEEP DATA
  // ====================
  
  void _loadSleepData() {
    try {
      // Get sleep from arguments
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null && args['sleep'] != null) {
        _sleep.value = args['sleep'] as SleepModel;
      }
      
      _logger.i('💤 Loading sleep: ${_sleep.value.title}');
      
      // Set default duration to first available option
      if (hasDurationOptions && durationOptions.isNotEmpty) {
        _selectedDuration.value = durationOptions.first;
      } else {
        // Parse single duration like "30 min"
        try {
          final duration = int.parse(sleep.durationRange.replaceAll('min', '').trim());
          _selectedDuration.value = duration;
        } catch (e) {
          _selectedDuration.value = 15;
        }
      }
      
      // Check favorite status
      _checkFavoriteStatus();
      
    } catch (e) {
      _logger.e('Error loading sleep data: $e');
      Get.snackbar('Error', 'Failed to load sleep details');
    }
  }
  
  // ====================
  // CHECK FAVORITE STATUS
  // ====================
  
  Future<void> _checkFavoriteStatus() async {
    final sleepId = 'sleep_${sleep.id}';
    _isFavorite.value = await FavoritesService.isFavorite(sleepId);
  }
  
  // ====================
  // TOGGLE FAVORITE
  // ====================
  
  Future<void> toggleFavorite() async {
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
  }
  
  // ====================
  // DOWNLOAD SLEEP (Already Available Offline)
  // ====================
  
  void downloadSleep() {
    // Since sleep audios are local assets, they're already available offline
    _logger.i('📥 Sleep audio already available: ${sleep.title}');
    
    Get.snackbar(
      'Already Available',
      'This audio is already downloaded and available offline.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
  
  // ====================
  // SHOW DURATION PICKER
  // ====================
  
  void showDurationPicker() {
    if (!hasDurationOptions) return;
    
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            ...durationOptions.map((duration) {
              final isSelected = duration == _selectedDuration.value;
              return InkWell(
                onTap: () {
                  _selectedDuration.value = duration;
                  Get.back();
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : const Color(0xFF404040),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$duration min',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
  
  // ====================
  // PLAY SLEEP AUDIO
  // ====================
  
  void onPlayTap() {
    _logger.i('🎵 Playing sleep audio: ${sleep.title} for ${_selectedDuration.value} min');
    
    // Navigate to sleep audio player
    Get.toNamed(
      AppRoutes.sleepAudioPlayer,
      arguments: {
        'sleep': sleep,
        'duration': _selectedDuration.value,
      },
    );
  }
}