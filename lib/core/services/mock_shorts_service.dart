import '../../data/models/short_model.dart';
import '../../data/models/podcast_episode_model.dart';

/// ====================
/// MOCK SHORTS SERVICE
/// ====================
/// 
/// Provides sample shorts data for all 3 sections

class MockShortsService {
  
  /// ====================
  /// GET ALL SHORTS
  /// ====================
  
  static List<ShortModel> getSampleShorts() {
    return [
      // PRACTICE IN ACTION (Video thumbnails)
      ShortModel(
        id: 'practice_001',
        title: 'Face Difficulties with Clear Intentions',
        instructor: 'Diana Winston',
        duration: '2 min',
        thumbnailImage: 'assets/images/video_placeholder.jpg',
        type: 'practice',
      ),
      
      ShortModel(
        id: 'practice_002',
        title: 'From Comparing to Celebrating',
        instructor: 'Sharon Salzberg',
        duration: '2 min',
        thumbnailImage: 'assets/images/video_placeholder2.jpg',
        type: 'practice',
      ),
      
      ShortModel(
        id: 'practice_003',
        title: 'Welcoming Boredom and Interest',
        instructor: 'Joseph Goldstein',
        duration: '3 min',
        thumbnailImage: 'assets/images/video_placeholder.jpg',
        type: 'practice',
      ),
      
      ShortModel(
        id: 'practice_004',
        title: 'When It Gets Late',
        instructor: 'Jeff Warren',
        duration: '2 min',
        thumbnailImage: 'assets/images/video_placeholder.jpg',
        type: 'practice',
      ),
      
      // WISDOM CLIPS (Gradient cards)
      ShortModel(
        id: 'wisdom_001',
        title: 'Equanimity',
        gradientColors: ['0xFF4DB8C4', '0xFF5B7BE8'],  // Teal to Blue
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_002',
        title: 'Feeling Present',
        gradientColors: ['0xFF8B5BE8', '0xFFD85BD8'],  // Purple to Pink
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_003',
        title: 'Health & Body',
        gradientColors: ['0xFFE8753C', '0xFFE8C85C'],  // Orange to Yellow
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_004',
        title: 'Mindful Eating',
        gradientColors: ['0xFF4DB8C4', '0xFF5B7BE8'],  // Teal to Blue
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_005',
        title: 'Open Awareness',
        gradientColors: ['0xFFD85BD8', '0xFFE8A8C8'],  // Pink gradient
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_006',
        title: 'Anxiety',
        gradientColors: ['0xFFE8853C', '0xFFD8A87C'],  // Orange gradient
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_007',
        title: 'Healthy Habits',
        gradientColors: ['0xFF4DB8C4', '0xFFD8C89C'],  // Teal to Tan
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_008',
        title: 'In Daily Life',
        gradientColors: ['0xFFE8A8C8', '0xFF98C8D8'],  // Pink to Blue pastel
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_009',
        title: 'Worrying',
        gradientColors: ['0xFFE8A87C', '0xFFD8987C'],  // Tan gradient
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_010',
        title: 'Stress',
        gradientColors: ['0xFF5B89E8', '0xFF8BA8E8'],  // Blue gradient
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_011',
        title: 'Inner Critic',
        gradientColors: ['0xFFD85BD8', '0xFFE8A8E8'],  // Pink-Purple
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_012',
        title: 'Relationships',
        gradientColors: ['0xFFE8754C', '0xFFE8A89C'],  // Pink-Orange
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_013',
        title: 'Loving-Kindness',
        gradientColors: ['0xFF5BD8C4', '0xFF5B7BE8'],  // Teal to Blue
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_014',
        title: 'Self Worth',
        gradientColors: ['0xFF4DB8C4', '0xFFE8A8D8'],  // Teal to Pink
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_015',
        title: 'Communication',
        gradientColors: ['0xFF5B89E8', '0xFF98C8D8'],  // Blue-Teal pastel
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_016',
        title: 'Self-Compassion',
        gradientColors: ['0xFF4DB8C4', '0xFF5B7BE8'],  // Teal-Blue
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_017',
        title: 'Focus',
        gradientColors: ['0xFF5B6BE8', '0xFF8B89E8'],  // Blue-Purple
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_018',
        title: 'Difficult Emotions',
        gradientColors: ['0xFFE8A85C', '0xFFD8987C'],  // Orange pastel
        type: 'wisdom',
      ),
      
      ShortModel(
        id: 'wisdom_019',
        title: 'Happiness',
        gradientColors: ['0xFFE8653C', '0xFFE8A85C'],  // Red-Orange
        type: 'wisdom',
      ),
      
      // PODCASTS
      ShortModel(
        id: 'podcast_001',
        title: 'Teacher Talks',
        subtitle: 'with Jay Michaelson',
        thumbnailImage: 'assets/images/podcast_placeholder1.jpg',
        type: 'podcast',
        description: 'Hosted by Jay Michaelson, Teacher Talks are five-minute micro-talks by meditation teachers and other experts who share mindfulness-based tools for real life.',
      ),
      
      ShortModel(
        id: 'podcast_002',
        title: 'MORE THAN A FEELING',
        subtitle: 'with Saleem Reshamwala',
        thumbnailImage: 'assets/images/podcast_placeholder2.jpg',
        type: 'podcast',
        description: 'Exploring emotions and mindfulness',
      ),
      
      ShortModel(
        id: 'podcast_003',
        title: 'Childproof',
        subtitle: 'with Yasmeen Khan',
        thumbnailImage: 'assets/images/podcast_placeholder.jpg',
        type: 'podcast',
        description: 'Mindful parenting practices',
      ),
      
      ShortModel(
        id: 'podcast_004',
        title: 'Twenty Percent Happier',
        subtitle: 'with Matthew Hepburn',
        thumbnailImage: 'assets/images/podcast_placeholder.jpg',
        type: 'podcast',
        description: 'Practical wisdom for everyday life',
      ),
    ];
  }
  
  /// ====================
  /// GET BY TYPE
  /// ====================
  
  static List<ShortModel> getShortsByType(String type) {
    return getSampleShorts()
        .where((short) => short.type == type)
        .toList();
  }
  
  static List<ShortModel> getPracticeShorts() => getShortsByType('practice');
  static List<ShortModel> getWisdomShorts() => getShortsByType('wisdom');
  static List<ShortModel> getPodcastShorts() => getShortsByType('podcast');
  
  /// ====================
  /// GET PODCAST EPISODES (✅ FIXED AUDIO PATHS!)
  /// ====================
  
  static List<PodcastEpisodeModel> getEpisodesForPodcast(String podcastId) {
    // ✅ Get the podcast to use its thumbnail for episodes
    final podcasts = getSampleShorts().where((s) => s.type == 'podcast').toList();
    final podcast = podcasts.firstWhere(
      (p) => p.id == podcastId,
      orElse: () => podcasts.first,
    );
    
    final podcastImage = podcast.thumbnailImage ?? 'assets/images/podcast_placeholder1.jpg';
    
    // ✅ Return episodes specific to each podcast
    if (podcastId == 'podcast_001') {
      // Teacher Talks episodes
      return [
        PodcastEpisodeModel(
          id: 'episode_001',
          title: 'Quieting the Mind... Politely | Jay Michaelson',
          podcastName: 'Teacher Talks',
          host: 'Jay Michaelson',
          duration: '6 min',
          date: 'JANUARY 19',
          thumbnailImage: podcastImage,
          audioFile: 'assets/audios/session_1_intro_meditation.mp3',  // ✅ FIXED PATH
          description: 'It\'s a misconception that meditation automatically quiets down your mind. Actually, you have to ask nicely.',
        ),
        
        PodcastEpisodeModel(
          id: 'episode_002',
          title: 'Defining Mindfulness | Diana Winston',
          podcastName: 'Teacher Talks',
          host: 'Diana Winston',
          duration: '5 min',
          date: 'JANUARY 10',
          thumbnailImage: podcastImage,
          audioFile: 'assets/audios/session_2_breath_awareness.mp3',  // ✅ FIXED PATH
          description: 'What exactly is mindfulness? Diana Winston breaks it down.',
        ),
        
        PodcastEpisodeModel(
          id: 'episode_003',
          title: 'Are you a Zoë or a Zelda? | Jay Michaelson',
          podcastName: 'Teacher Talks',
          host: 'Jay Michaelson',
          duration: '7 min',
          date: 'JANUARY 5',
          thumbnailImage: podcastImage,
          audioFile: 'assets/audios/session_3_body_scan.mp3',  // ✅ FIXED PATH
          description: 'Understanding different meditation personalities and approaches.',
        ),
        
        PodcastEpisodeModel(
          id: 'episode_004',
          title: 'What to Do When Your Mind Wanders | Cory Muscara',
          podcastName: 'Teacher Talks',
          host: 'Cory Muscara',
          duration: '6 min',
          date: 'DECEMBER 28',
          thumbnailImage: podcastImage,
          audioFile: 'assets/audios/session_4_working_thoughts.mp3',  // ✅ FIXED PATH
          description: 'Practical tips for dealing with a wandering mind during meditation.',
        ),
        
        PodcastEpisodeModel(
          id: 'episode_005',
          title: 'Chilling Out Is Not The Point | Jay Michaelson',
          podcastName: 'Teacher Talks',
          host: 'Jay Michaelson',
          duration: '5 min',
          date: 'DECEMBER 20',
          thumbnailImage: podcastImage,
          audioFile: 'assets/audios/session_5_loving_kindness.mp3',  // ✅ FIXED PATH
          description: 'Meditation isn\'t just about relaxation - it\'s about awareness.',
        ),
      ];
    } else if (podcastId == 'podcast_002') {
      // ✅ MORE THAN A FEELING episodes
      return [
        PodcastEpisodeModel(
          id: 'episode_006',
          title: 'Understanding Emotions | Saleem Reshamwala',
          podcastName: 'MORE THAN A FEELING',
          host: 'Saleem Reshamwala',
          duration: '8 min',
          date: 'FEBRUARY 15',
          thumbnailImage: podcastImage,
          audioFile: 'assets/audios/session_1_intro_meditation.mp3',  // ✅ FIXED PATH
          description: 'Exploring the depth of human emotions.',
        ),
        
        PodcastEpisodeModel(
          id: 'episode_007',
          title: 'The Science of Feelings | Saleem Reshamwala',
          podcastName: 'MORE THAN A FEELING',
          host: 'Saleem Reshamwala',
          duration: '7 min',
          date: 'FEBRUARY 8',
          thumbnailImage: podcastImage,
          audioFile: 'assets/audios/session_2_breath_awareness.mp3',  // ✅ FIXED PATH
          description: 'What science tells us about our emotional world.',
        ),
        
        PodcastEpisodeModel(
          id: 'episode_008',
          title: 'Mindful Awareness of Emotions | Saleem Reshamwala',
          podcastName: 'MORE THAN A FEELING',
          host: 'Saleem Reshamwala',
          duration: '6 min',
          date: 'FEBRUARY 1',
          thumbnailImage: podcastImage,
          audioFile: 'assets/audios/session_3_body_scan.mp3',  // ✅ FIXED PATH
          description: 'Bringing mindfulness to our emotional experiences.',
        ),
      ];
    } else if (podcastId == 'podcast_003') {
      // ✅ Childproof episodes
      return [
        PodcastEpisodeModel(
          id: 'episode_009',
          title: 'Mindful Parenting Basics | Yasmeen Khan',
          podcastName: 'Childproof',
          host: 'Yasmeen Khan',
          duration: '9 min',
          date: 'MARCH 10',
          thumbnailImage: podcastImage,
          audioFile: 'assets/audios/session_4_working_thoughts.mp3',  // ✅ FIXED PATH
          description: 'Introduction to mindful parenting practices.',
        ),
        
        PodcastEpisodeModel(
          id: 'episode_010',
          title: 'Dealing with Tantrums | Yasmeen Khan',
          podcastName: 'Childproof',
          host: 'Yasmeen Khan',
          duration: '7 min',
          date: 'MARCH 3',
          thumbnailImage: podcastImage,
          audioFile: 'assets/audios/session_5_loving_kindness.mp3',  // ✅ FIXED PATH
          description: 'Mindful approaches to challenging moments.',
        ),
      ];
    } else {
      // ✅ Twenty Percent Happier or default
      return [
        PodcastEpisodeModel(
          id: 'episode_011',
          title: 'Practical Wisdom | Matthew Hepburn',
          podcastName: 'Twenty Percent Happier',
          host: 'Matthew Hepburn',
          duration: '10 min',
          date: 'APRIL 1',
          thumbnailImage: podcastImage,
          audioFile: 'assets/audios/intro_audio.mp3',  // ✅ FIXED PATH
          description: 'Simple wisdom for everyday happiness.',
        ),
      ];
    }
  }
}