import '../../data/models/sleep_model.dart';

/// ====================
/// MOCK SLEEPS SERVICE
/// ====================
/// 
/// Provides sample sleep meditation data from screenshots

class MockSleepsService {
  
  /// ====================
  /// GET ALL SLEEPS
  /// ====================
  
  static List<SleepModel> getSampleSleeps() {
    return [
      // FEATURED SECTION
      SleepModel(
        id: 'sleep_001',
        title: 'Relax Into Sleep',
        instructor: 'Sebene Selassie',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '15 - 30 min',
        category: 'featured',
      ),
      
      SleepModel(
        id: 'sleep_002',
        title: 'Soothe Anxiety to Sleep',
        instructor: 'Matthew Hepburn',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'featured',
      ),
      
      SleepModel(
        id: 'sleep_003',
        title: 'Deeply Relaxing the Body & Mind',
        instructor: 'Alexis Santos',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'featured',
      ),
      
      SleepModel(
        id: 'sleep_004',
        title: 'Sleep Story: The Wise Elder',
        instructor: 'Pascal Auclair',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'featured',
      ),
      
      SleepModel(
        id: 'sleep_005',
        title: 'The Sleep Trip',
        instructor: 'Jeff Warren',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'featured',
      ),
      
      SleepModel(
        id: 'sleep_006',
        title: 'Nightly Gratitude',
        instructor: 'Jeff Warren',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '5 - 15 min',
        category: 'featured',
      ),
      
      SleepModel(
        id: 'sleep_007',
        title: 'Drift Off Into Sleep',
        instructor: 'Oren Jay Sofer',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '15 - 30 min',
        category: 'featured',
      ),
      
      SleepModel(
        id: 'sleep_008',
        title: 'Relax, Release & Appreciate',
        instructor: 'Oren Jay Sofer',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 - 45 min',
        category: 'featured',
      ),
      
      SleepModel(
        id: 'sleep_009',
        title: 'Settling In, Drifting Off',
        instructor: 'Oren Jay Sofer',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '10 - 20 min',
        category: 'featured',
      ),
      
      SleepModel(
        id: 'sleep_010',
        title: 'Wind Down for Sleep',
        instructor: 'Sebene Selassie',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '15 - 30 min',
        category: 'featured',
      ),
      
      SleepModel(
        id: 'sleep_011',
        title: 'Preparing For Sleep',
        instructor: 'Matthew Hepburn',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '15 - 40 min',
        category: 'featured',
      ),
      
      SleepModel(
        id: 'sleep_012',
        title: 'A Journey to Sleep',
        instructor: 'Oren Jay Sofer',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '25 min',
        category: 'featured',
      ),
      
      SleepModel(
        id: 'sleep_013',
        title: 'Late Night Accompaniment',
        instructor: 'devon hase',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'featured',
      ),
      
      SleepModel(
        id: 'sleep_014',
        title: 'Go to Bed Angry',
        instructor: 'Cara Lai',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'featured',
      ),
      
      // MEDITATIONS SECTION
      SleepModel(
        id: 'sleep_015',
        title: 'Deep Down Relaxation',
        instructor: 'Oren Jay Sofer',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '15 - 30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_016',
        title: 'Falling Asleep',
        instructor: 'Alexis Santos',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '10 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_017',
        title: 'Melt Into Sleep',
        instructor: 'Jay Michaelson',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '10 - 30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_018',
        title: 'Sleep Story: Unwind After a Long Day',
        instructor: 'Matthew Hepburn',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_019',
        title: 'Getting Back to Sleep',
        instructor: 'Oren Jay Sofer',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_020',
        title: 'Love Your Body into Sleep',
        instructor: 'Jess Morey',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_021',
        title: 'Power Down',
        instructor: 'Jeff Warren',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '12 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_022',
        title: 'The Big Sink',
        instructor: 'Jeff Warren',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '5 - 10 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_023',
        title: 'Bedtime Body Scan',
        instructor: 'Anushka Fernandopulle',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '5 - 15 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_024',
        title: 'Drift to Sleep',
        instructor: 'Cory Muscara',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '5 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_025',
        title: 'Enjoy Your Power Nap',
        instructor: 'Jay Michaelson',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '5 - 10 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_026',
        title: 'The Rhythm of Rest',
        instructor: 'Oren Jay Sofer',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '20 - 30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_027',
        title: "When You Can't Sleep",
        instructor: 'Sharon Salzberg',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '10 - 20 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_028',
        title: 'Dissolving Discomfort',
        instructor: 'JoAnna Hardy',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '15 - 20 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_029',
        title: 'Indulge Sleepiness',
        instructor: 'Jeff Warren',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '10 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_030',
        title: 'How to Fall Asleep',
        instructor: 'Jeff Warren',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '5 - 10 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_031',
        title: 'Resting Mindfully',
        instructor: 'Alexis Santos',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_032',
        title: 'Be Still and Fall Asleep',
        instructor: 'Jay Michaelson',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_033',
        title: 'Sink into Sleep',
        instructor: 'Dawn Mauricio',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_034',
        title: 'Sleep Story: The Three Questions',
        instructor: 'Yael Shy',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '22 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_035',
        title: 'A Nudge Toward Sleep',
        instructor: 'Anushka Fernandopulle',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '3 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_036',
        title: 'Gratitude Body Scan',
        instructor: 'Sebene Selassie',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_037',
        title: 'Unruffle Your Mind',
        instructor: 'La Sarmiento',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_038',
        title: 'Unwind into Sleep',
        instructor: 'Oren Jay Sofer',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_039',
        title: 'Wishing Well At Bedtime',
        instructor: 'Anushka Fernandopulle',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '5 - 15 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_040',
        title: 'The Sleep Game',
        instructor: 'JoAnna Hardy',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '10 - 20 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_041',
        title: 'Putting the Day to Rest',
        instructor: 'Oren Jay Sofer',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_042',
        title: 'Indulge in Relaxation',
        instructor: 'Cara Lai',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_043',
        title: 'Rest & Release',
        instructor: 'Sebene Selassie',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_044',
        title: 'Gentle Tools for Sleep',
        instructor: 'Diana Winston',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_045',
        title: 'Downshifting into Sleep',
        instructor: 'Emily Horn',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_046',
        title: 'Soothing Your Nerves',
        instructor: 'Emily Horn',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_047',
        title: 'Rest with Gratitude',
        instructor: 'devon hase',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_048',
        title: 'Deep Rest during Pregnancy',
        instructor: 'Yael Shy',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_049',
        title: 'Nap for New Parents',
        instructor: 'Cara Lai',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '20 - 30 min',
        category: 'meditations',
      ),
      
      SleepModel(
        id: 'sleep_050',
        title: 'Unwind Your Mind',
        instructor: 'Oren Jay Sofer',
        instructorImage: 'assets/images/instructor_placeholder.jpg',
        durationRange: '30 min',
        category: 'meditations',
      ),
    ];
  }
  
  /// ====================
  /// GET BY CATEGORY
  /// ====================
  
  static List<SleepModel> getSleepsByCategory(String category) {
    return getSampleSleeps()
        .where((sleep) => sleep.category == category)
        .toList();
  }
  
  /// ====================
  /// GET FEATURED
  /// ====================
  
  static List<SleepModel> getFeaturedSleeps() {
    return getSleepsByCategory('featured');
  }
  
  /// ====================
  /// GET MEDITATIONS
  /// ====================
  
  static List<SleepModel> getMeditationSleeps() {
    return getSleepsByCategory('meditations');
  }
}