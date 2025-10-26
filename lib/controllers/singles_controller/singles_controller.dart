// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart'; // ✅ ADDED - GetIt import
import 'package:logger/logger.dart';
import '../../data/models/single_model.dart';
import '../../repository/singles_repository/singles_repository.dart';
import '../../core/services/favorites_service.dart';
import '../../core/routes/app_routes.dart';

/// ====================
/// SINGLES CONTROLLER
/// ====================
///
/// Manages state and business logic for Singles screen

class SinglesController extends GetxController {
  final SinglesRepository _repository =
      GetIt.I<SinglesRepository>(); // ✅ CHANGED - Using GetIt
  final Logger _logger = Logger();

  // ====================
  // REACTIVE STATE
  // ====================

  final RxList<SingleModel> _forYouSingles = <SingleModel>[].obs;
  final RxList<SingleModel> _featuredSingles = <SingleModel>[].obs;
  final RxList<SingleModel> _browseAllSingles = <SingleModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // ====================
  // GETTERS
  // ====================

  List<SingleModel> get forYouSingles => _forYouSingles;
  List<SingleModel> get featuredSingles => _featuredSingles;
  List<SingleModel> get browseAllSingles => _browseAllSingles;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  // ====================
  // LIFECYCLE
  // ====================

  @override
  void onInit() {
    super.onInit();
    loadAllSingles();
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
  // LOAD ALL SINGLES
  // ====================

  Future<void> loadAllSingles() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Load favorites and recently played
      await _loadFavoritesAndRecentlyPlayed();

      // Load other categories
      final results = await Future.wait([
        _repository.getFeaturedSingles(),
        _repository.getBrowseAllSingles(),
      ]);

      _featuredSingles.value = results[0];
      _browseAllSingles.value = results[1];
    } catch (e) {
      _errorMessage.value = 'Failed to load singles. Please try again.';
      _logger.e('Error loading singles: $e');
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
  // LOAD FAVORITES & RECENTLY PLAYED
  // ====================

  Future<void> _loadFavoritesAndRecentlyPlayed() async {
    try {
      final favorites = await FavoritesService.getFavorites();
      final recentlyPlayed = await FavoritesService.getRecentlyPlayed();

      // Create singles for favorites (first card)
      final favoriteSingle = SingleModel(
        id: 'favorites',
        title: 'Favorites',
        subtitle: '${favorites.length} items',
        gradientColors: ['0xFFE91E63', '0xFFFF6F00'],
        category: 'for_you',
        isFavorite: true,
      );

      // Create singles for recently played (second card)
      final recentSingle = SingleModel(
        id: 'recently_played',
        title: 'Recently Played',
        subtitle: '${recentlyPlayed.length} items',
        gradientColors: ['0xFF673AB7', '0xFF3F51B5'],
        category: 'for_you',
        isRecentlyPlayed: true,
      );

      _forYouSingles.value = [favoriteSingle, recentSingle];
      _logger.i(
        '✅ Loaded favorites (${favorites.length}) and recently played (${recentlyPlayed.length})',
      );
    } catch (e) {
      _logger.e('Error loading favorites/recently played: $e');
    }
  }

  // ====================
  // REFRESH SINGLES
  // ====================

  Future<void> refreshSingles() async {
    await loadAllSingles();
  }

  // ====================
  // HANDLE SINGLE TAP (✅ UPDATED!)
  // ====================

  void onSingleTap(SingleModel single) {
    _logger.i('📱 Single tapped - ID: ${single.id}, Title: ${single.title}');

    // Check if it's favorites or recently played
    if (single.id == 'favorites') {
      _logger.i('🔄 Navigating to Favorites');
      _navigateToFavorites();
      return;
    }

    if (single.id == 'recently_played') {
      _logger.i('🔄 Navigating to Recently Played');
      _navigateToRecentlyPlayed();
      return;
    }

    // ✅ NEW: Navigate to Collection Detail Page for Featured/Browse All cards
    _logger.i('🔄 Navigating to Collection Detail for: ${single.title}');
    try {
      Get.toNamed(
        AppRoutes.collectionDetail,
        arguments: {'collection': single},
      );
      _logger.i('✅ Navigation completed');
    } catch (e) {
      _logger.e('❌ Navigation error: $e');
      Get.snackbar(
        'Error',
        'Failed to open collection: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ====================
  // NAVIGATE TO FAVORITES
  // ====================

  void _navigateToFavorites() {
    _logger.i('➡️ Executing Get.toNamed(${AppRoutes.favoritesList})');

    try {
      Get.toNamed(AppRoutes.favoritesList, arguments: {'type': 'favorites'});
      _logger.i('✅ Navigation completed');
    } catch (e) {
      _logger.e('❌ Navigation error: $e');
      Get.snackbar(
        'Error',
        'Failed to open favorites: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ====================
  // NAVIGATE TO RECENTLY PLAYED
  // ====================

  void _navigateToRecentlyPlayed() {
    _logger.i('➡️ Executing Get.toNamed(${AppRoutes.favoritesList})');

    try {
      Get.toNamed(
        AppRoutes.favoritesList,
        arguments: {'type': 'recently_played'},
      );
      _logger.i('✅ Navigation completed');
    } catch (e) {
      _logger.e('❌ Navigation error: $e');
      Get.snackbar(
        'Error',
        'Failed to open recently played: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
