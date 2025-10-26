import '../../data/models/meditation_model.dart';

/// ====================
/// MOCK DATA SERVICE
/// ====================
/// 
/// Provides sample meditation data for demo/development
/// In production, this data would come from Firebase Firestore
class MockDataService {
  
  /// ====================
  /// GET ALL MEDITATIONS
  /// ====================
  
  static List<MeditationModel> getSampleMeditations() {
    return [
      // ====================
      // 1. THE BASICS (Unlocked, with image)
      // ====================
      MeditationModel(
        id: 'med_001',
        title: 'The Basics',
        instructor: 'Joseph Goldstein',
        category: 'COURSE',
        sessionCount: 7,
        durationMinutes: 10,
        isLocked: false,
        hasImage: true,
        imageUrl: 'assets/images/meditation_1.jpg', // You'll add image
        gradientColors: ['0xFF86C65A', '0xFFE8D85C'], // Green to Yellow
        type: 'course',
      ),
      
      // ====================
      // 2. WELCOME TO THE PARTY (Locked)
      // ====================
      MeditationModel(
        id: 'med_002',
        title: 'Welcome To The Party',
        instructor: 'Jeff Warren',
        category: 'GUIDED MEDITATION',
        sessionCount: 1,
        durationMinutes: 20,
        minDuration: 10,
        maxDuration: 30,
        isLocked: true,
        hasImage: false,
        gradientColors: ['0xFFFF9A56', '0xFFB97DD4', '0xFF7BA4E8'], // Orange-Purple-Blue
        type: 'guided',
      ),
      
      // ====================
      // 3. STRONG BODY, STRONG MIND (Locked)
      // ====================
      MeditationModel(
        id: 'med_003',
        title: 'Strong Body, Strong Mind',
        instructor: 'Jeff Warren',
        category: 'PRACTICE IN ACTION',
        sessionCount: 1,
        durationMinutes: 3,
        isLocked: true,
        hasImage: true,
        imageUrl: 'assets/images/meditation_3.jpg', // Exercise image
        gradientColors: [], // Pure image, no gradient overlay
        type: 'practice',
      ),
      
      // ====================
      // 4-20: ADDITIONAL COURSES (Mix of locked/unlocked)
      // ====================
      
      MeditationModel(
        id: 'med_004',
        title: 'Morning Mindfulness',
        instructor: 'Sarah Johnson',
        category: 'GUIDED MEDITATION',
        sessionCount: 5,
        durationMinutes: 15,
        isLocked: false,
        hasImage: false,
        gradientColors: ['0xFFFF6B9D', '0xFFC46DD5'], // Pink to Purple
        type: 'guided',
      ),
      
      MeditationModel(
        id: 'med_005',
        title: 'Sleep Deep Tonight',
        instructor: 'Michael Chen',
        category: 'SLEEP MEDITATION',
        sessionCount: 10,
        durationMinutes: 30,
        isLocked: true,
        hasImage: true,
        imageUrl: 'assets/images/meditation_5.jpg',
        gradientColors: ['0xFF56CCF2', '0xFF2F80ED'], // Blue gradient
        type: 'sleep',
      ),
      
      MeditationModel(
        id: 'med_006',
        title: 'Anxiety Relief',
        instructor: 'Emma Williams',
        category: 'GUIDED MEDITATION',
        sessionCount: 8,
        durationMinutes: 12,
        isLocked: false,
        hasImage: false,
        gradientColors: ['0xFFF093FB', '0xFFF5576C'], // Purple to Pink
        type: 'guided',
      ),
      
      MeditationModel(
        id: 'med_007',
        title: 'Focus & Concentration',
        instructor: 'David Brown',
        category: 'COURSE',
        sessionCount: 12,
        durationMinutes: 20,
        isLocked: true,
        hasImage: false,
        gradientColors: ['0xFF4FACFE', '0xFF00F2FE'], // Cyan gradient
        type: 'course',
      ),
      
      MeditationModel(
        id: 'med_008',
        title: 'Loving Kindness',
        instructor: 'Lisa Anderson',
        category: 'GUIDED MEDITATION',
        sessionCount: 6,
        durationMinutes: 18,
        isLocked: false,
        hasImage: true,
        imageUrl: 'assets/images/meditation_8.jpg',
        gradientColors: ['0xFFFA709A', '0xFFFEE140'], // Pink to Yellow
        type: 'guided',
      ),
      
      MeditationModel(
        id: 'med_009',
        title: 'Breath Awareness',
        instructor: 'Thomas Garcia',
        category: 'PRACTICE IN ACTION',
        sessionCount: 4,
        durationMinutes: 8,
        isLocked: true,
        hasImage: false,
        gradientColors: ['0xFF30CFD0', '0xFF330867'], // Teal to Purple
        type: 'practice',
      ),
      
      MeditationModel(
        id: 'med_010',
        title: 'Stress Release',
        instructor: 'Jennifer Lee',
        category: 'GUIDED MEDITATION',
        sessionCount: 7,
        durationMinutes: 25,
        isLocked: false,
        hasImage: false,
        gradientColors: ['0xFF86C65A', '0xFFE8D85C'], // Green to Yellow
        type: 'guided',
      ),
      
      MeditationModel(
        id: 'med_011',
        title: 'Evening Calm',
        instructor: 'Robert Martinez',
        category: 'SLEEP MEDITATION',
        sessionCount: 9,
        durationMinutes: 35,
        isLocked: true,
        hasImage: true,
        imageUrl: 'assets/images/meditation_11.jpg',
        gradientColors: ['0xFFFF9A56', '0xFFB97DD4'], // Orange to Purple
        type: 'sleep',
      ),
      
      MeditationModel(
        id: 'med_012',
        title: 'Body Scan',
        instructor: 'Amanda White',
        category: 'GUIDED MEDITATION',
        sessionCount: 5,
        durationMinutes: 22,
        isLocked: false,
        hasImage: false,
        gradientColors: ['0xFFFF6B9D', '0xFFC46DD5'], // Pink to Purple
        type: 'guided',
      ),
      
      MeditationModel(
        id: 'med_013',
        title: 'Walking Meditation',
        instructor: 'James Taylor',
        category: 'PRACTICE IN ACTION',
        sessionCount: 3,
        durationMinutes: 10,
        isLocked: true,
        hasImage: false,
        gradientColors: ['0xFF56CCF2', '0xFF2F80ED'], // Blue gradient
        type: 'practice',
      ),
      
      MeditationModel(
        id: 'med_014',
        title: 'Gratitude Practice',
        instructor: 'Sophia Rodriguez',
        category: 'GUIDED MEDITATION',
        sessionCount: 6,
        durationMinutes: 14,
        isLocked: false,
        hasImage: true,
        imageUrl: 'assets/images/meditation_14.jpg',
        gradientColors: ['0xFFF093FB', '0xFFF5576C'], // Purple to Pink
        type: 'guided',
      ),
      
      MeditationModel(
        id: 'med_015',
        title: 'Deep Relaxation',
        instructor: 'William Harris',
        category: 'SLEEP MEDITATION',
        sessionCount: 8,
        durationMinutes: 40,
        isLocked: true,
        hasImage: false,
        gradientColors: ['0xFF4FACFE', '0xFF00F2FE'], // Cyan gradient
        type: 'sleep',
      ),
      
      MeditationModel(
        id: 'med_016',
        title: 'Mindful Eating',
        instructor: 'Olivia Thomas',
        category: 'PRACTICE IN ACTION',
        sessionCount: 4,
        durationMinutes: 5,
        isLocked: false,
        hasImage: false,
        gradientColors: ['0xFFFA709A', '0xFFFEE140'], // Pink to Yellow
        type: 'practice',
      ),
      
      MeditationModel(
        id: 'med_017',
        title: 'Self Compassion',
        instructor: 'Daniel Jackson',
        category: 'COURSE',
        sessionCount: 10,
        durationMinutes: 18,
        isLocked: true,
        hasImage: true,
        imageUrl: 'assets/images/meditation_17.jpg',
        gradientColors: ['0xFF30CFD0', '0xFF330867'], // Teal to Purple
        type: 'course',
      ),
      
      MeditationModel(
        id: 'med_018',
        title: 'Anger Management',
        instructor: 'Emily Moore',
        category: 'GUIDED MEDITATION',
        sessionCount: 7,
        durationMinutes: 16,
        isLocked: false,
        hasImage: false,
        gradientColors: ['0xFF86C65A', '0xFFE8D85C'], // Green to Yellow
        type: 'guided',
      ),
      
      MeditationModel(
        id: 'med_019',
        title: 'Energy Boost',
        instructor: 'Christopher Wilson',
        category: 'PRACTICE IN ACTION',
        sessionCount: 5,
        durationMinutes: 7,
        isLocked: true,
        hasImage: false,
        gradientColors: ['0xFFFF9A56', '0xFFB97DD4'], // Orange to Purple
        type: 'practice',
      ),
      
      MeditationModel(
        id: 'med_020',
        title: 'Inner Peace',
        instructor: 'Isabella Davis',
        category: 'GUIDED MEDITATION',
        sessionCount: 12,
        durationMinutes: 28,
        isLocked: false,
        hasImage: true,
        imageUrl: 'assets/images/meditation_20.jpg',
        gradientColors: ['0xFFFF6B9D', '0xFFC46DD5'], // Pink to Purple
        type: 'guided',
      ),
    ];
  }
}