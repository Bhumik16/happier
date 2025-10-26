/// ====================
/// COURSE MODEL
/// ====================
/// 
/// Data model for meditation courses
/// Similar to MeditationModel but specific for course series

class CourseModel {
  final String id;
  final String title;
  final String? subtitle;  // e.g., "A Prescription for Connection"
  final String instructor;
  final int totalSessions;  // Total number of sessions in course
  final int durationMinutes;  // Average duration per session
  final bool isFree;  // true = available without subscription
  final bool hasImage;
  final String? imageUrl;
  final List<String> gradientColors;
  final String? description;
  final int completedSessions;  // Progress tracking
  final String category;  // e.g., "Beginner", "Advanced", "Wellness"

  CourseModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.instructor,
    required this.totalSessions,
    required this.durationMinutes,
    this.isFree = false,
    this.hasImage = false,
    this.imageUrl,
    this.gradientColors = const [],
    this.description,
    this.completedSessions = 0,
    this.category = 'Course',
  });

  // ====================
  // COMPUTED PROPERTIES
  // ====================
  
  bool get isLocked => !isFree;
  
  String get sessionText => '$totalSessions SESSION${totalSessions > 1 ? 'S' : ''}';
  
  double get progress => totalSessions > 0 ? completedSessions / totalSessions : 0.0;
  
  bool get isCompleted => completedSessions >= totalSessions;
  
  bool get isInProgress => completedSessions > 0 && !isCompleted;

  // ====================
  // COPY WITH (Immutability)
  // ====================
  
  CourseModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? instructor,
    int? totalSessions,
    int? durationMinutes,
    bool? isFree,
    bool? hasImage,
    String? imageUrl,
    List<String>? gradientColors,
    String? description,
    int? completedSessions,
    String? category,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      instructor: instructor ?? this.instructor,
      totalSessions: totalSessions ?? this.totalSessions,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isFree: isFree ?? this.isFree,
      hasImage: hasImage ?? this.hasImage,
      imageUrl: imageUrl ?? this.imageUrl,
      gradientColors: gradientColors ?? this.gradientColors,
      description: description ?? this.description,
      completedSessions: completedSessions ?? this.completedSessions,
      category: category ?? this.category,
    );
  }

  // ====================
  // JSON SERIALIZATION
  // ====================
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'instructor': instructor,
      'totalSessions': totalSessions,
      'durationMinutes': durationMinutes,
      'isFree': isFree,
      'hasImage': hasImage,
      'imageUrl': imageUrl,
      'gradientColors': gradientColors,
      'description': description,
      'completedSessions': completedSessions,
      'category': category,
    };
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      instructor: json['instructor'] as String,
      totalSessions: json['totalSessions'] as int,
      durationMinutes: json['durationMinutes'] as int,
      isFree: json['isFree'] as bool? ?? false,
      hasImage: json['hasImage'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      gradientColors: (json['gradientColors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      description: json['description'] as String?,
      completedSessions: json['completedSessions'] as int? ?? 0,
      category: json['category'] as String? ?? 'Course',
    );
  }
}