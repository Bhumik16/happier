import '../../data/models/single_model.dart';

/// ====================
/// MOCK SINGLES SERVICE
/// ====================
/// 
/// Provides sample singles data based on screenshots

class MockSinglesService {
  
  /// ====================
  /// GET ALL SINGLES
  /// ====================
  
  static List<SingleModel> getSampleSingles() {
    return [
      // FOR YOU SECTION (Horizontal scroll cards)
      SingleModel(
        id: 'foryou_001',
        title: 'Favorites',
        gradientColors: ['0xFF5B7BE8', '0xFF4DB8C4'],  // Blue gradient
        category: 'for_you',
        description: 'Your favorite meditations',
      ),
      
      SingleModel(
        id: 'foryou_002',
        title: 'Recently Played',
        gradientColors: ['0xFF4DB8C4', '0xFFE8A85C'],  // Teal to Orange
        category: 'for_you',
        description: 'Continue where you left off',
      ),
      
      // FEATURED SECTION
      SingleModel(
        id: 'featured_001',
        title: 'Great for\nBeginners',
        gradientColors: ['0xFFE889C2', '0xFF8B6FE8', '0xFF5BA8E8'],  // Pink-Purple-Blue
        category: 'featured',
        durationMinutes: 10,
      ),
      
      SingleModel(
        id: 'featured_002',
        title: 'Meditate with\ndevon',
        gradientColors: ['0xFF4DB8C4', '0xFF7B89E8'],  // Teal-Purple
        category: 'featured',
        durationMinutes: 15,
      ),
      
      SingleModel(
        id: 'featured_003',
        title: 'Neurodivergence',
        gradientColors: ['0xFFE85B8B', '0xFFE8895C'],  // Pink-Orange
        category: 'featured',
        durationMinutes: 20,
      ),
      
      SingleModel(
        id: 'featured_004',
        title: 'Practicing Goodwill',
        gradientColors: ['0xFFE8C85C', '0xFFE8A85C'],  // Yellow gradient
        category: 'featured',
        durationMinutes: 12,
      ),
      
      SingleModel(
        id: 'featured_005',
        title: 'Chronic Pain &\nIllness',
        gradientColors: ['0xFF5B89E8', '0xFF4DB8C4'],  // Blue-Teal
        category: 'featured',
        durationMinutes: 25,
      ),
      
      SingleModel(
        id: 'featured_006',
        title: 'When Meditation is\nHard',
        gradientColors: ['0xFFB8D85C', '0xFFE8D85C'],  // Green-Yellow
        category: 'featured',
        durationMinutes: 15,
      ),
      
      // BROWSE ALL SECTION
      SingleModel(
        id: 'browse_001',
        title: 'New & Noteworthy',
        gradientColors: ['0xFFE8C89C', '0xFFD8A87C'],  // Tan-Beige
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_002',
        title: 'Advanced &\nUnguided',
        gradientColors: ['0xFFE8653C', '0xFFE8A85C'],  // Orange-Red
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_003',
        title: 'Best of Matthew',
        gradientColors: ['0xFF4DB8C4', '0xFF6B7BE8'],  // Teal-Blue
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_004',
        title: 'Best of Sebene',
        gradientColors: ['0xFFD889E8', '0xFFE8B8D8'],  // Pink-Purple
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_005',
        title: 'Celebrate Pride',
        gradientColors: ['0xFFE8B85C', '0xFFE85B8B', '0xFF5B89E8'],  // Rainbow
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_006',
        title: 'Chronic Pain &\nIllness',
        gradientColors: ['0xFF5B89E8', '0xFF4DB8C4'],  // Blue-Teal
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_007',
        title: 'Concentration',
        gradientColors: ['0xFF5B6BE8', '0xFF4B5BC8'],  // Deep Blue
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_008',
        title: 'Deep Relaxation',
        gradientColors: ['0xFFE8B8D8', '0xFFB8D8E8'],  // Pink-Blue pastel
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_009',
        title: 'Difficult Emotions',
        gradientColors: ['0xFFE8A85C', '0xFFB87BE8'],  // Orange-Purple
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_010',
        title: 'Enjoy Everyday\nWalking',
        gradientColors: ['0xFF5BD8C4', '0xFF5BE8A8'],  // Teal-Green
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_011',
        title: 'Fall Dread',
        gradientColors: ['0xFFE8953C', '0xFF984820'],  // Orange-Brown
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_012',
        title: 'Find Your Purpose',
        gradientColors: ['0xFF4DB8C4', '0xFF3B9BA8'],  // Teal gradient
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_013',
        title: 'Focus',
        gradientColors: ['0xFF8B7BE8', '0xFF6B5BC8'],  // Purple gradient
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_014',
        title: 'Great for\nBeginners',
        gradientColors: ['0xFFE889C2', '0xFF8B6FE8', '0xFF5BA8E8'],  // Pink-Purple-Blue
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_015',
        title: 'Happiness',
        gradientColors: ['0xFFE8D85C', '0xFFD8A8E8'],  // Yellow-Pink
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_016',
        title: 'Happiness is a Skill',
        gradientColors: ['0xFFB8D85C', '0xFF5BD8C4'],  // Green-Yellow-Teal
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_017',
        title: 'Health',
        gradientColors: ['0xFFD889E8', '0xFFE8B8D8'],  // Pink-Purple pastel
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_018',
        title: 'Hope is a Skill',
        gradientColors: ['0xFFE8A87C', '0xFFE8C8A8'],  // Peach gradient
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_019',
        title: 'Keep Taming\nAnxiety',
        gradientColors: ['0xFF4DB8C4', '0xFFE8A8D8'],  // Teal-Pink
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_020',
        title: 'Lightly Guided',
        gradientColors: ['0xFFE8A87C', '0xFFD8987C'],  // Tan-Orange
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_021',
        title: 'Made for These\nHard Times',
        gradientColors: ['0xFFE8854C', '0xFFD8753C'],  // Orange gradient
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_022',
        title: 'Make Kindness a\nHabit',
        gradientColors: ['0xFFE85B8B', '0xFFE8A8C8'],  // Pink gradient
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_023',
        title: 'Meditate with\ndevon',
        gradientColors: ['0xFF4DB8C4', '0xFF7B89E8'],  // Teal-Purple
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_024',
        title: 'Meditate with\nSharon Salzberg',
        gradientColors: ['0xFF9B7BE8', '0xFFD889E8'],  // Purple gradient
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_025',
        title: 'Mental Mischief',
        gradientColors: ['0xFF4DB8C4', '0xFF5B6BE8'],  // Teal-Blue
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_026',
        title: 'Neurodivergence',
        gradientColors: ['0xFFE85B8B', '0xFFE8895C'],  // Pink-Orange
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_027',
        title: 'On The Go',
        gradientColors: ['0xFF5B89E8', '0xFF8BA8E8'],  // Blue gradient
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_028',
        title: 'One-Minute\nStressbusters',
        gradientColors: ['0xFF8B5BE8', '0xFFE85BB8'],  // Purple-Pink
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_029',
        title: 'Relating to Race',
        gradientColors: ['0xFFE8C8B8', '0xFF98C8D8'],  // Beige-Blue pastel
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_030',
        title: 'Relationships',
        gradientColors: ['0xFFE8754C', '0xFFE8A89C'],  // Orange-Peach
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_031',
        title: 'Reflect and\nRefresh',
        gradientColors: ['0xFF5B89E8', '0xFF8BC8E8'],  // Blue gradient
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_032',
        title: 'Self-Compassion',
        gradientColors: ['0xFF7B89E8', '0xFFB8A8D8'],  // Purple-Blue pastel
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_033',
        title: 'Stress',
        gradientColors: ['0xFFE8A8C8', '0xFF98B8E8'],  // Pink-Blue pastel
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_034',
        title: 'Things Change',
        gradientColors: ['0xFF9B7BE8', '0xFFE85BD8'],  // Purple-Pink
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_035',
        title: 'Wake Up & Reset',
        gradientColors: ['0xFF8B2BA8', '0xFFE85B8B'],  // Purple-Pink bold
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_036',
        title: 'Waking Up',
        gradientColors: ['0xFFE8A8C8', '0xFFE8C8D8'],  // Pink pastel
        category: 'browse_all',
      ),
      
      SingleModel(
        id: 'browse_037',
        title: 'Work Stress SOS',
        gradientColors: ['0xFF4DB8C4', '0xFFD8C89C'],  // Teal-Tan
        category: 'browse_all',
      ),
    ];
  }
  
  /// ====================
  /// GET BY CATEGORY
  /// ====================
  
  static List<SingleModel> getSinglesByCategory(String category) {
    return getSampleSingles()
        .where((single) => single.category == category)
        .toList();
  }
  
  /// ====================
  /// GET FOR YOU SINGLES
  /// ====================
  
  static List<SingleModel> getForYouSingles() {
    return getSinglesByCategory('for_you');
  }
  
  /// ====================
  /// GET FEATURED SINGLES
  /// ====================
  
  static List<SingleModel> getFeaturedSingles() {
    return getSinglesByCategory('featured');
  }
  
  /// ====================
  /// GET BROWSE ALL SINGLES
  /// ====================
  
  static List<SingleModel> getBrowseAllSingles() {
    return getSinglesByCategory('browse_all');
  }
}