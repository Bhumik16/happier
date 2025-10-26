// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart'; // ✅ ADDED - GetIt import
import 'package:logger/logger.dart'; // ✅ ADDED
import '../../data/models/sleep_model.dart';
import '../../repository/sleeps_repository/sleeps_repository.dart';
import '../../core/routes/app_routes.dart'; // ✅ ADDED

/// ====================
/// SLEEPS CONTROLLER
/// ====================
///
/// Manages state and business logic for Sleep screen

class SleepsController extends GetxController {
  final SleepsRepository _repository =
      GetIt.I<SleepsRepository>(); // ✅ CHANGED - Using GetIt
  final Logger _logger = Logger(); // ✅ ADDED

  // ====================
  // REACTIVE STATE
  // ====================

  final RxList<SleepModel> _featuredSleeps = <SleepModel>[].obs;
  final RxList<SleepModel> _meditationSleeps = <SleepModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // ====================
  // GETTERS
  // ====================

  List<SleepModel> get featuredSleeps => _featuredSleeps;
  List<SleepModel> get meditationSleeps => _meditationSleeps;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  // ====================
  // LIFECYCLE
  // ====================

  @override
  void onInit() {
    super.onInit();
    loadAllSleeps();
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
  // LOAD ALL SLEEPS
  // ====================

  Future<void> loadAllSleeps() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Load both categories in parallel
      final results = await Future.wait([
        _repository.getFeaturedSleeps(),
        _repository.getMeditationSleeps(),
      ]);

      _featuredSleeps.value = results[0];
      _meditationSleeps.value = results[1];

      _logger.i(
        '✅ Loaded ${_featuredSleeps.length} featured sleeps and ${_meditationSleeps.length} meditation sleeps',
      ); // ✅ ADDED
    } catch (e) {
      _errorMessage.value =
          'Failed to load sleep meditations. Please try again.';
      _logger.e('Error loading sleeps: $e'); // ✅ ADDED
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
  // REFRESH SLEEPS
  // ====================

  Future<void> refreshSleeps() async {
    await loadAllSleeps();
  }

  // ====================
  // HANDLE SLEEP TAP (✅ UPDATED!)
  // ====================

  void onSleepTap(SleepModel sleep) {
    _logger.i('💤 Sleep tapped: ${sleep.title}');

    // Navigate to sleep detail screen
    try {
      Get.toNamed(AppRoutes.sleepDetail, arguments: {'sleep': sleep});
      _logger.i('✅ Navigation to sleep detail completed');
    } catch (e) {
      _logger.e('❌ Navigation error: $e');
      Get.snackbar(
        'Error',
        'Failed to open sleep details: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
