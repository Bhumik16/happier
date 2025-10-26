import 'package:get/get.dart';
import 'package:get_it/get_it.dart'; // ✅ ADDED - GetIt import
import 'package:logger/logger.dart';
import '../../data/models/meditation_model.dart';
import '../../repository/meditation_repository/meditation_repository.dart';
import '../../core/services/cloudinary_service.dart';

/// ====================
/// HOME CONTROLLER
/// ====================

class HomeController extends GetxController {
  final Logger _logger = Logger();
  final MeditationRepository _repository =
      GetIt.I<MeditationRepository>(); // ✅ CHANGED - Using GetIt

  // ====================
  // REACTIVE STATE
  // ====================

  final RxList<MeditationModel> _meditations = <MeditationModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _greeting = ''.obs;

  // ====================
  // GETTERS
  // ====================

  List<MeditationModel> get meditations => _meditations;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get greeting => _greeting.value;

  // ====================
  // LIFECYCLE
  // ====================

  @override
  void onInit() {
    super.onInit();
    _logger.i('HomeController initialized');
    _updateGreeting();
  }

  @override
  void onReady() {
    super.onReady();
    loadMeditations();
  }

  @override
  void onClose() {
    _logger.i('HomeController disposed');
    super.onClose();
  }

  // ====================
  // UPDATE GREETING
  // ====================

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      _greeting.value = 'Good morning';
    } else if (hour < 17) {
      _greeting.value = 'Good afternoon';
    } else {
      _greeting.value = 'Good evening';
    }
    _logger.i('Greeting updated: ${_greeting.value}');
  }

  // ====================
  // LOAD MEDITATIONS
  // ====================

  Future<void> loadMeditations() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      _logger.i('Loading meditations...');

      final meditations = await _repository.getAllMeditations();
      _meditations.value = meditations;

      _logger.i('Loaded ${meditations.length} meditations');
    } catch (e) {
      _logger.e('Error loading meditations: $e');
      _errorMessage.value = 'Failed to load meditations';
      Get.snackbar(
        'Error',
        'Failed to load meditations',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // ====================
  // REFRESH MEDITATIONS
  // ====================

  Future<void> refreshMeditations() async {
    _logger.i('Refreshing meditations...');
    await loadMeditations();
  }

  // ====================
  // HANDLE "START COURSE" BUTTON → GOES TO UNIFIED PLAYER
  // ====================

  void onStartCourseTap(MeditationModel meditation) {
    _logger.i('Start Course tapped: ${meditation.title}');

    // ✅ MAP meditation ID to course ID
    final courseId = _mapMeditationIdToCourseId(meditation.id);

    // ✅ Navigate to UNIFIED PLAYER with both video and audio URLs
    Get.toNamed(
      '/unified-player', // Changed from '/video-player'
      arguments: {
        'videoUrl': CloudinaryService.getIntroVideoUrl(courseId),
        'audioUrl': CloudinaryService.getCourseAudioUrl(
          courseId,
          'intro_audio',
        ), // ✅ Added audio URL
        'title': meditation.title,
        'courseId': courseId,
      },
    );
  }

  // ====================
  // HANDLE "MORE" BUTTON → GOES TO COURSE DETAIL
  // ====================

  void onMoreTap(MeditationModel meditation) {
    _logger.i('More tapped: ${meditation.title}');

    // ✅ MAP meditation ID to course ID
    final courseId = _mapMeditationIdToCourseId(meditation.id);

    // Navigate to course detail page
    Get.toNamed(
      '/course-detail',
      arguments: courseId, // ✅ Pass COURSE ID, not meditation ID
    );
  }

  // ====================
  // HANDLE CARD TAP (General) → ALSO GOES TO COURSE DETAIL
  // ====================

  void onMeditationTap(MeditationModel meditation) {
    _logger.i('Meditation card tapped: ${meditation.title}');

    // ✅ MAP meditation ID to course ID
    final courseId = _mapMeditationIdToCourseId(meditation.id);

    // Navigate to course detail page
    Get.toNamed(
      '/course-detail',
      arguments: courseId, // ✅ Pass COURSE ID, not meditation ID
    );
  }

  // ====================
  // MAP MEDITATION ID TO COURSE ID
  // ====================

  String _mapMeditationIdToCourseId(String meditationId) {
    // ✅ Map home screen meditation IDs to actual course IDs
    switch (meditationId) {
      case 'med_001':
        return 'getting_started'; // "The Basics" course
      case 'med_002':
        return 'getting_started'; // Default to getting started
      case 'med_003':
        return 'getting_started';
      case 'med_004':
        return 'getting_started';
      case 'med_005':
        return 'getting_started';
      case 'med_006':
        return 'getting_started';
      case 'med_007':
        return 'getting_started';
      case 'med_008':
        return 'getting_started';
      case 'med_009':
        return 'getting_started';
      case 'med_010':
        return 'getting_started';
      default:
        return 'getting_started'; // Default fallback
    }
  }

  // ====================
  // SHOW MORE OPTIONS
  // ====================

  void showMoreOptions(MeditationModel meditation) {
    _logger.i('More options for: ${meditation.title}');
    Get.snackbar(
      'More Options',
      'More options for ${meditation.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ====================
  // SHOW SUBSCRIPTION DIALOG
  // ====================

  void showSubscriptionDialog(MeditationModel meditation) {
    _logger.i('Subscription dialog for: ${meditation.title}');
    Get.snackbar(
      'Premium Content',
      'This content requires a premium subscription',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
