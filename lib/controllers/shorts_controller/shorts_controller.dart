// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart'; // ✅ ADDED - GetIt import
import 'package:logger/logger.dart';
import '../../data/models/short_model.dart';
import '../../repository/shorts_repository/shorts_repository.dart';
import '../../core/routes/app_routes.dart';

/// ====================
/// SHORTS CONTROLLER
/// ====================
///
/// Manages state and business logic for Shorts screen

class ShortsController extends GetxController {
  final ShortsRepository _repository =
      GetIt.I<ShortsRepository>(); // ✅ CHANGED - Using GetIt
  final Logger _logger = Logger();

  // ====================
  // REACTIVE STATE
  // ====================

  final RxList<ShortModel> _practiceShorts = <ShortModel>[].obs;
  final RxList<ShortModel> _wisdomShorts = <ShortModel>[].obs;
  final RxList<ShortModel> _podcastShorts = <ShortModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // ====================
  // GETTERS
  // ====================

  List<ShortModel> get practiceShorts => _practiceShorts;
  List<ShortModel> get wisdomShorts => _wisdomShorts;
  List<ShortModel> get podcastShorts => _podcastShorts;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  // ====================
  // LIFECYCLE
  // ====================

  @override
  void onInit() {
    super.onInit();
    loadAllShorts();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // ====================
  // LOAD ALL SHORTS
  // ====================

  Future<void> loadAllShorts() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Load all types in parallel
      final results = await Future.wait([
        _repository.getPracticeShorts(),
        _repository.getWisdomShorts(),
        _repository.getPodcastShorts(),
      ]);

      _practiceShorts.value = results[0];
      _wisdomShorts.value = results[1];
      _podcastShorts.value = results[2];
    } catch (e) {
      _errorMessage.value = 'Failed to load shorts. Please try again.';
      Get.snackbar(
        'Error',
        _errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // ====================
  // REFRESH SHORTS
  // ====================

  Future<void> refreshShorts() async {
    await loadAllShorts();
  }

  // ====================
  // HANDLE SHORT TAP (✅ UPDATED!)
  // ====================

  void onShortTap(ShortModel short) {
    _logger.i('🎬 Tapped on ${short.type}: ${short.title}');

    if (short.isPractice) {
      // ✅ Practice In Action → Direct to video player
      _logger.i('→ Navigating to video player');
      Get.toNamed(AppRoutes.shortsVideoPlayer, arguments: {'short': short});
    } else if (short.isWisdom) {
      // ✅ Wisdom Clips → Go to wisdom detail page
      _logger.i('→ Navigating to wisdom detail page');
      Get.toNamed(
        AppRoutes.wisdomDetail,
        arguments: {
          'title': short.title,
          'gradientColors': short.gradientColors,
        },
      );
    } else if (short.isPodcast) {
      // ✅ Podcasts → Go to podcast detail page
      _logger.i('→ Navigating to podcast detail page');
      Get.toNamed(AppRoutes.podcastDetail, arguments: {'podcast': short});
    } else {
      _logger.w('⚠️ Unknown short type: ${short.type}');
      Get.snackbar(
        'Error',
        'Unknown content type',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
