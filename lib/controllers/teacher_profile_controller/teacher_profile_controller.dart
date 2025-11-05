import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../data/models/teacher_profile_model.dart';

class TeacherProfileController extends GetxController {
  final Logger _logger = Logger();

  late Rx<TeacherProfile> teacherProfile;

  @override
  void onInit() {
    super.onInit();

    // Get the teacher name from navigation arguments
    final String teacherName = Get.arguments ?? '';
    _logger.i('👨‍🏫 Loading profile for: $teacherName');

    // Load teacher profile (for now using mock data, later connect to API/Firebase)
    teacherProfile = _getMockTeacherProfile(teacherName).obs;
  }

  /// Get mock teacher profile data
  /// TODO: Replace with real API/Firebase call
  TeacherProfile _getMockTeacherProfile(String name) {
    // Mock data for different teachers
    final Map<String, TeacherProfile> teacherProfiles = {
      'Joseph Goldstein': TeacherProfile(
        name: 'Joseph Goldstein',
        age: 70,
        email: 'joseph.goldstein@happier.com',
        bio:
            'Joseph Goldstein is one of the first American vipassana teachers, co-founder of the Insight Meditation Society with Jack Kornfield and Sharon Salzberg.',
        imageUrl: '',
        courses: [
          'Mindfulness Meditation',
          'Vipassana Practice',
          'Buddhist Philosophy',
          'Loving-Kindness Meditation',
          'Advanced Insight Meditation',
        ],
        achievements: [
          Achievement(
            title: 'Co-founder of IMS',
            description: 'Co-founded the Insight Meditation Society in 1975',
            iconName: 'school',
            dateAchieved: DateTime(1975, 1, 1),
          ),
          Achievement(
            title: 'Author',
            description: 'Published 10+ books on meditation',
            iconName: 'book',
            dateAchieved: DateTime(2020, 1, 1),
          ),
          Achievement(
            title: '50 Years Teaching',
            description: 'Over 50 years of meditation teaching experience',
            iconName: 'star',
            dateAchieved: DateTime(2023, 1, 1),
          ),
        ],
        totalStudents: 10000,
        rating: 4.9,
      ),
      'Sharon Salzberg': TeacherProfile(
        name: 'Sharon Salzberg',
        age: 68,
        email: 'sharon.salzberg@happier.com',
        bio:
            'Sharon Salzberg is a New York Times bestselling author and teacher of Buddhist meditation practices in the West.',
        imageUrl: '',
        courses: [
          'Loving-Kindness Meditation',
          'Mindfulness Practice',
          'Compassion Meditation',
          'Real Love Meditation',
          'Buddhism for Beginners',
        ],
        achievements: [
          Achievement(
            title: 'NYT Bestselling Author',
            description: 'New York Times bestselling author',
            iconName: 'trophy',
            dateAchieved: DateTime(2011, 1, 1),
          ),
          Achievement(
            title: 'IMS Co-founder',
            description: 'Co-founded the Insight Meditation Society',
            iconName: 'school',
            dateAchieved: DateTime(1975, 1, 1),
          ),
          Achievement(
            title: 'Podcast Host',
            description: 'Host of Metta Hour podcast',
            iconName: 'mic',
            dateAchieved: DateTime(2015, 1, 1),
          ),
        ],
        totalStudents: 8500,
        rating: 4.8,
      ),
      'Sebene Selassie': TeacherProfile(
        name: 'Sebene Selassie',
        age: 55,
        email: 'sebene.selassie@happier.com',
        bio:
            'Sebene Selassie is an author and teacher integrating mindfulness with social justice and healing.',
        imageUrl: '',
        courses: [
          'Mindfulness & Social Justice',
          'Healing Through Meditation',
          'Belonging Meditation',
          'Diversity in Practice',
        ],
        achievements: [
          Achievement(
            title: 'Author',
            description: 'Author of "You Belong"',
            iconName: 'book',
            dateAchieved: DateTime(2020, 1, 1),
          ),
          Achievement(
            title: 'Community Leader',
            description: 'Leading meditation for underserved communities',
            iconName: 'people',
            dateAchieved: DateTime(2018, 1, 1),
          ),
        ],
        totalStudents: 5000,
        rating: 4.9,
      ),
      'Jeff Warren': TeacherProfile(
        name: 'Jeff Warren',
        age: 48,
        email: 'jeff.warren@happier.com',
        bio:
            'Jeff Warren is a meditation teacher, author, and founder of The Consciousness Explorers Club.',
        imageUrl: '',
        courses: [
          'Consciousness Exploration',
          'Creative Meditation',
          'Sleep Meditation',
          'Morning Practice',
        ],
        achievements: [
          Achievement(
            title: 'Founder',
            description: 'Founded The Consciousness Explorers Club',
            iconName: 'explore',
            dateAchieved: DateTime(2011, 1, 1),
          ),
          Achievement(
            title: 'Author',
            description: 'Author of "The Head Trip"',
            iconName: 'book',
            dateAchieved: DateTime(2007, 1, 1),
          ),
        ],
        totalStudents: 6200,
        rating: 4.7,
      ),
      'Alexis Santos': TeacherProfile(
        name: 'Alexis Santos',
        age: 45,
        email: 'alexis.santos@happier.com',
        bio:
            'Alexis Santos has practiced meditation since 1999 and teaches vipassana meditation internationally.',
        imageUrl: '',
        courses: [
          'Vipassana Meditation',
          'Insight Practice',
          'Silent Retreats',
          'Mindful Living',
        ],
        achievements: [
          Achievement(
            title: 'Retreat Leader',
            description: 'Led 100+ meditation retreats worldwide',
            iconName: 'flight',
            dateAchieved: DateTime(2022, 1, 1),
          ),
          Achievement(
            title: 'Teacher Training',
            description: 'Trained over 50 meditation teachers',
            iconName: 'school',
            dateAchieved: DateTime(2021, 1, 1),
          ),
        ],
        totalStudents: 4800,
        rating: 4.8,
      ),
      'Diana Winston': TeacherProfile(
        name: 'Diana Winston',
        age: 56,
        email: 'diana.winston@happier.com',
        bio:
            'Diana Winston is the Director of Mindfulness Education at UCLA and author of several mindfulness books.',
        imageUrl: '',
        courses: [
          'UCLA Mindfulness',
          'Natural Awareness',
          'Workplace Mindfulness',
          'Scientific Meditation',
        ],
        achievements: [
          Achievement(
            title: 'UCLA Director',
            description: 'Director of Mindfulness Education at UCLA',
            iconName: 'school',
            dateAchieved: DateTime(2014, 1, 1),
          ),
          Achievement(
            title: 'Author',
            description: 'Published "The Little Book of Being"',
            iconName: 'book',
            dateAchieved: DateTime(2019, 1, 1),
          ),
          Achievement(
            title: 'Researcher',
            description: 'Leading research in mindfulness science',
            iconName: 'science',
            dateAchieved: DateTime(2020, 1, 1),
          ),
        ],
        totalStudents: 7500,
        rating: 4.9,
      ),
    };

    // Return the teacher profile or a default one if not found
    return teacherProfiles[name] ??
        TeacherProfile(
          name: name,
          age: 50,
          email: '${name.toLowerCase().replaceAll(' ', '.')}@happier.com',
          bio:
              'An experienced meditation teacher dedicated to helping others find peace and mindfulness.',
          courses: [
            'Mindfulness Meditation',
            'Stress Reduction',
            'Better Sleep',
          ],
          achievements: [],
          totalStudents: 1000,
          rating: 4.5,
        );
  }
}
