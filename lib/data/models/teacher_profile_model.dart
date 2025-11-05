/// ====================
/// TEACHER PROFILE MODEL
/// ====================
/// Model representing a teacher's profile information

class TeacherProfile {
  final String name;
  final int age;
  final String email;
  final String bio;
  final String imageUrl;
  final List<String> courses;
  final List<Achievement> achievements;
  final int totalStudents;
  final double rating;

  TeacherProfile({
    required this.name,
    required this.age,
    required this.email,
    required this.bio,
    this.imageUrl = '',
    this.courses = const [],
    this.achievements = const [],
    this.totalStudents = 0,
    this.rating = 0.0,
  });

  factory TeacherProfile.fromJson(Map<String, dynamic> json) {
    return TeacherProfile(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      courses: List<String>.from(json['courses'] ?? []),
      achievements:
          (json['achievements'] as List?)
              ?.map((a) => Achievement.fromJson(a))
              .toList() ??
          [],
      totalStudents: json['totalStudents'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'email': email,
      'bio': bio,
      'imageUrl': imageUrl,
      'courses': courses,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'totalStudents': totalStudents,
      'rating': rating,
    };
  }
}

/// ====================
/// ACHIEVEMENT MODEL
/// ====================
class Achievement {
  final String title;
  final String description;
  final String iconName;
  final DateTime dateAchieved;

  Achievement({
    required this.title,
    required this.description,
    this.iconName = 'trophy',
    required this.dateAchieved,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      iconName: json['iconName'] ?? 'trophy',
      dateAchieved: DateTime.parse(json['dateAchieved']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'iconName': iconName,
      'dateAchieved': dateAchieved.toIso8601String(),
    };
  }
}
