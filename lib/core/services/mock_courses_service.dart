import '../../data/models/course_model.dart';

/// ====================
/// MOCK COURSES SERVICE
/// ====================
/// 
/// Provides sample course data with local asset images

class MockCoursesService {
  
  static List<CourseModel> getSampleCourses() {
    return [
      // ====================
      // 1. GETTING STARTED
      // ====================
      CourseModel(
        id: 'getting_started',
        title: 'Getting Started',
        instructor: 'Happier Meditation',
        totalSessions: 7,
        durationMinutes: 10,
        isFree: true,
        hasImage: true,
        imageUrl: 'assets/images/course_getting_started.jpg',  // 📸 Image 1
        gradientColors: [],
        category: 'Beginner',
        description: 'Start your meditation journey with this introductory course',
      ),
      
      // ====================
      // 2. EVEN NOW, LOVE
      // ====================
      CourseModel(
        id: 'even_now_love',
        title: 'Even Now, Love',
        subtitle: 'A Prescription for Connection',
        instructor: 'Happier Meditation',
        totalSessions: 12,
        durationMinutes: 15,
        isFree: true,
        hasImage: true,
        imageUrl: 'assets/images/course_even_now_love.jpg',  // 📸 Image 2
        gradientColors: [],
        category: 'Relationships',
        description: 'Cultivate deeper connections through mindful practices',
      ),
      
      // ====================
      // 3. THE DALAI LAMA
      // ====================
      CourseModel(
        id: 'dalai_lama',
        title: "THE DALAI LAMA'S\nGuide To Happiness",
        instructor: 'Roshi Joan Halifax',
        totalSessions: 10,
        durationMinutes: 20,
        isFree: true,
        hasImage: true,
        imageUrl: 'assets/images/course_dalai_lama.jpg',  // 📸 Image 3
        gradientColors: [],
        category: 'Happiness',
        description: 'Ancient wisdom for modern happiness',
      ),
      
      // ====================
      // 4. WORK LIFE (✅ CYCLES BACK TO IMAGE 1)
      // ====================
      CourseModel(
        id: 'work_life',
        title: 'Work\nLife',
        instructor: 'Sharon Salzberg',
        totalSessions: 8,
        durationMinutes: 12,
        isFree: true,
        hasImage: true,
        imageUrl: 'assets/images/course_getting_started.jpg',  // ✅ Reusing Image 1
        gradientColors: ['0xFF4DB8C4', '0xFF5B7BE8'],
        category: 'Productivity',
        description: 'Balance and mindfulness in your professional life',
      ),
      
      // ====================
      // 5. ON THE GO (✅ USES IMAGE 2)
      // ====================
      CourseModel(
        id: 'on_the_go',
        title: 'On\nThe\nGoooo',
        instructor: 'Alexis Santos',
        totalSessions: 6,
        durationMinutes: 8,
        isFree: true,
        hasImage: true,
        imageUrl: 'assets/images/course_even_now_love.jpg',  // ✅ Reusing Image 2
        gradientColors: ['0xFFE8A85C', '0xFF5B7BE8'],
        category: 'Quick Practice',
        description: 'Meditations for busy lives',
      ),
      
      // ====================
      // 6. MINDFUL MENOPAUSE (✅ USES IMAGE 3)
      // ====================
      CourseModel(
        id: 'mindful_menopause',
        title: 'Mindful\nMenopause',
        instructor: 'Diana Winston',
        totalSessions: 10,
        durationMinutes: 15,
        isFree: true,
        hasImage: true,
        imageUrl: 'assets/images/course_dalai_lama.jpg',  // ✅ Reusing Image 3
        gradientColors: ['0xFFE85B8B', '0xFF5B7BE8'],
        category: 'Wellness',
        description: 'Navigate this life transition with grace and awareness',
      ),
    ];
  }
  
  static CourseModel? getCourseById(String id) {
    try {
      return getSampleCourses().firstWhere((course) => course.id == id);
    } catch (e) {
      return null;
    }
  }
  
  static List<CourseModel> getFreeCourses() {
    return getSampleCourses().where((course) => course.isFree).toList();
  }
  
  static List<CourseModel> getLockedCourses() {
    return getSampleCourses().where((course) => !course.isFree).toList();
  }
}