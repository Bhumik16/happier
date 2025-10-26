import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../data/models/single_model.dart';
import '../../data/models/course_session_model.dart';  // ✅ ADDED: Import model
import '../../core/services/mock_course_sessions_service.dart';
import '../../core/routes/app_routes.dart';

/// ====================
/// COLLECTION DETAIL CONTROLLER
/// ====================
/// 
/// Manages collection details and sessions

class CollectionDetailController extends GetxController {
  final Logger _logger = Logger();
  
  // ====================
  // REACTIVE STATE
  // ====================
  
  final Rx<SingleModel> _collection = SingleModel(
    id: '',
    title: '',
    gradientColors: [],
  ).obs;
  
  final RxList<CourseSessionModel> _sessions = <CourseSessionModel>[].obs;  // ✅ FIXED: Proper type
  final RxBool _isLoading = false.obs;
  
  // ====================
  // GETTERS
  // ====================
  
  SingleModel get collection => _collection.value;
  List<CourseSessionModel> get sessions => _sessions;  // ✅ FIXED: Proper type
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
      
      // Get collection from arguments
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null && args['collection'] != null) {
        _collection.value = args['collection'] as SingleModel;
      }
      
      _logger.i('📚 Loading collection: ${_collection.value.title}');
      
      // Load the 5 sessions (reusing the same sessions for all collections)
      _sessions.value = MockCourseSessionsService.getSessionsForCourse('getting_started');  // ✅ FIXED: Correct method name
      
      _logger.i('✅ Loaded ${_sessions.length} sessions');
      
    } catch (e) {
      _logger.e('Error loading collection data: $e');
      Get.snackbar('Error', 'Failed to load collection details');
    } finally {
      _isLoading.value = false;
    }
  }
  
  // ====================
  // HANDLE SESSION TAP
  // ====================
  
  void onSessionTap(CourseSessionModel session) {  // ✅ FIXED: Proper parameter type
    _logger.i('🎵 Playing session: ${session.title}');
    
    // Navigate to unified player
    Get.toNamed(
      AppRoutes.unifiedPlayer,
      arguments: {
        'session': session,
        'courseId': 'getting_started',
      },
    );
  }
}