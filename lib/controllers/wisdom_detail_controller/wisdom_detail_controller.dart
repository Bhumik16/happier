import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../data/models/short_model.dart';
import '../../core/routes/app_routes.dart';

/// ====================
/// WISDOM DETAIL CONTROLLER
/// ====================
/// 
/// Manages wisdom clips collection detail page

class WisdomDetailController extends GetxController {
  final Logger _logger = Logger();

  // ====================
  // REACTIVE STATE
  // ====================

  final RxString _collectionTitle = ''.obs;
  final RxList<String> _gradientColors = <String>[].obs;
  final RxList<ShortModel> _sessions = <ShortModel>[].obs;
  final RxBool _isLoading = false.obs;

  // ====================
  // GETTERS
  // ====================

  String get collectionTitle => _collectionTitle.value;
  List<String> get gradientColors => _gradientColors;
  List<ShortModel> get sessions => _sessions;
  bool get isLoading => _isLoading.value;

  // ====================
  // LIFECYCLE
  // ====================

  @override
  void onInit() {
    super.onInit();
    _loadCollectionData();
  }

  // ====================
  // LOAD COLLECTION DATA
  // ====================

  void _loadCollectionData() {
    try {
      _isLoading.value = true;

      // Get collection data from arguments
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null) {
        _collectionTitle.value = args['title'] ?? 'Wisdom Clips';
        _gradientColors.value = (args['gradientColors'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ?? ['#4DD0E1', '#5C6BC0'];
      }

      _logger.i('📚 Loading wisdom collection: $_collectionTitle');

      // Load sessions (using mock data for now)
      _loadSessions();

    } catch (e) {
      _logger.e('Error loading collection: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // ====================
  // LOAD SESSIONS (✅ 15 sessions with different videos!)
  // ====================

  void _loadSessions() {
    // 15 wisdom clip sessions about meditation, stress, anxiety, etc.
    _sessions.value = [
      ShortModel(
        id: 'wisdom_session_1',
        title: 'The Self: How It Can Be Helpful',
        instructor: 'Joseph Goldstein',
        duration: '30 sec',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_2',
        title: 'Emotions: Learning to Laugh at Them',
        instructor: 'Jeff Warren',
        duration: '45 sec',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_3',
        title: 'Meeting Challenges with Openness',
        instructor: 'Sharon Salzberg',
        duration: '1 min',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_4',
        title: 'The Ups and Downs of Progress',
        instructor: 'Joseph Goldstein',
        duration: '2 min',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_5',
        title: 'Nature of the Mind',
        instructor: 'Tara Brach',
        duration: '30 sec',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_6',
        title: 'Dealing with Stress Mindfully',
        instructor: 'Dan Harris',
        duration: '1 min',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_7',
        title: 'Understanding Anxiety',
        instructor: 'Tara Brach',
        duration: '45 sec',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_8',
        title: 'Finding Peace in Chaos',
        instructor: 'Jeff Warren',
        duration: '30 sec',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_9',
        title: 'Compassion for Yourself',
        instructor: 'Sharon Salzberg',
        duration: '1 min',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_10',
        title: 'Working with Difficult Emotions',
        instructor: 'Joseph Goldstein',
        duration: '2 min',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_11',
        title: 'The Power of Presence',
        instructor: 'Dan Harris',
        duration: '30 sec',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_12',
        title: 'Letting Go of Control',
        instructor: 'Tara Brach',
        duration: '45 sec',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_13',
        title: 'Breathing Through Stress',
        instructor: 'Jeff Warren',
        duration: '1 min',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_14',
        title: 'The Art of Not Knowing',
        instructor: 'Sharon Salzberg',
        duration: '30 sec',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
      ShortModel(
        id: 'wisdom_session_15',
        title: 'Mindfulness in Daily Life',
        instructor: 'Joseph Goldstein',
        duration: '2 min',
        type: 'wisdom',
        gradientColors: _gradientColors,
      ),
    ];

    _logger.i('✅ Loaded ${_sessions.length} wisdom sessions');
  }

  // ====================
  // HANDLE SESSION TAP
  // ====================

  void onSessionTap(ShortModel session) {
    _logger.i('▶️ Playing wisdom session: ${session.title}');

    // Navigate to shorts video player
    Get.toNamed(
      AppRoutes.shortsVideoPlayer,
      arguments: {'short': session},
    );
  }
}