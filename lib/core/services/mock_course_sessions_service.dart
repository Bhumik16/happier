import '../../data/models/course_session_model.dart';
import 'cloudinary_service.dart';

/// ====================
/// MOCK COURSE SESSIONS SERVICE
/// ====================
/// 
/// Uses Cloudinary videos and audio
/// Returns same 5 sessions for ALL courses

class MockCourseSessionsService {
  
  static List<CourseSessionModel> getSessionsForCourse(String courseId) {
    // ✅ Return sessions for ANY course ID
    return _getStandardSessions(courseId);
  }
  
  static List<CourseSessionModel> _getStandardSessions(String courseId) {
    return [
      // ==================== SESSION 1 ====================
      CourseSessionModel(
        id: '${courseId}_session_001',
        courseId: courseId,
        sessionNumber: 1,
        title: 'Introduction to Meditation',
        description: 'Learn the basics of mindfulness meditation',
        instructor: 'Matthew Hepburn',
        durationMinutes: 10,
        videoUrl: CloudinaryService.getCourseVideoUrl('getting_started', 1),
        audioUrl: CloudinaryService.getCourseAudioUrl('getting_started', 'session_1_intro_meditation'),
        thumbnailUrl: 'assets/images/meditation_1.jpg',
        isCompleted: false,
        isLocked: false,
      ),
      
      // ==================== SESSION 2 ====================
      CourseSessionModel(
        id: '${courseId}_session_002',
        courseId: courseId,
        sessionNumber: 2,
        title: 'Breath Awareness',
        description: 'Focus on your natural breathing rhythm',
        instructor: 'Sharon Salzberg',
        durationMinutes: 12,
        videoUrl: CloudinaryService.getCourseVideoUrl('getting_started', 2),
        audioUrl: CloudinaryService.getCourseAudioUrl('getting_started', 'session_2_breath_awareness'),
        thumbnailUrl: 'assets/images/meditation_1.jpg',
        isCompleted: false,
        isLocked: false,
      ),
      
      // ==================== SESSION 3 ====================
      CourseSessionModel(
        id: '${courseId}_session_003',
        courseId: courseId,
        sessionNumber: 3,
        title: 'Body Scan Meditation',
        description: 'A gentle journey through your body',
        instructor: 'Joseph Goldstein',
        durationMinutes: 15,
        videoUrl: CloudinaryService.getCourseVideoUrl('getting_started', 3),
        audioUrl: CloudinaryService.getCourseAudioUrl('getting_started', 'session_3_body_scan'),
        thumbnailUrl: 'assets/images/meditation_3.jpg',
        isCompleted: false,
        isLocked: false,
      ),
      
      // ==================== SESSION 4 ====================
      CourseSessionModel(
        id: '${courseId}_session_004',
        courseId: courseId,
        sessionNumber: 4,
        title: 'Working with Thoughts',
        description: 'Understanding and observing your thoughts',
        instructor: 'Diana Winston',
        durationMinutes: 10,
        videoUrl: CloudinaryService.getCourseVideoUrl('getting_started', 4),
        audioUrl: CloudinaryService.getCourseAudioUrl('getting_started', 'session_4_working_thoughts'),
        thumbnailUrl: 'assets/images/meditation_1.jpg',
        isCompleted: false,
        isLocked: false,
      ),
      
      // ==================== SESSION 5 ====================
      CourseSessionModel(
        id: '${courseId}_session_005',
        courseId: courseId,
        sessionNumber: 5,
        title: 'Cultivating Loving-Kindness',
        description: 'Develop compassion for yourself and others',
        instructor: 'Sharon Salzberg',
        durationMinutes: 14,
        videoUrl: CloudinaryService.getCourseVideoUrl('getting_started', 5),
        audioUrl: CloudinaryService.getCourseAudioUrl('getting_started', 'session_5_loving_kindness'),
        thumbnailUrl: 'assets/images/meditation_3.jpg',
        isCompleted: false,
        isLocked: false,
      ),
    ];
  }
}