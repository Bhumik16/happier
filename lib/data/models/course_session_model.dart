/// ====================
/// COURSE SESSION MODEL
/// ====================

class CourseSessionModel {
  final String id;
  final String courseId;
  final int sessionNumber;
  final String title;
  final String? description;
  final String instructor;
  final int durationMinutes;
  final String? videoUrl;
  final String? audioUrl;
  final String? thumbnailUrl;
  final bool isCompleted;
  final bool isLocked;

  CourseSessionModel({
    required this.id,
    required this.courseId,
    required this.sessionNumber,
    required this.title,
    this.description,
    required this.instructor,
    required this.durationMinutes,
    this.videoUrl,
    this.audioUrl,
    this.thumbnailUrl,
    this.isCompleted = false,
    this.isLocked = false,
  });

  String get durationText => '$durationMinutes min';
  String get sessionLabel => 'Session $sessionNumber';

  CourseSessionModel copyWith({
    String? id,
    String? courseId,
    int? sessionNumber,
    String? title,
    String? description,
    String? instructor,
    int? durationMinutes,
    String? videoUrl,
    String? audioUrl,
    String? thumbnailUrl,
    bool? isCompleted,
    bool? isLocked,
  }) {
    return CourseSessionModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      sessionNumber: sessionNumber ?? this.sessionNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      instructor: instructor ?? this.instructor,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      videoUrl: videoUrl ?? this.videoUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'sessionNumber': sessionNumber,
      'title': title,
      'description': description,
      'instructor': instructor,
      'durationMinutes': durationMinutes,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'thumbnailUrl': thumbnailUrl,
      'isCompleted': isCompleted,
      'isLocked': isLocked,
    };
  }

  factory CourseSessionModel.fromJson(Map<String, dynamic> json) {
    return CourseSessionModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      sessionNumber: json['sessionNumber'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      instructor: json['instructor'] as String,
      durationMinutes: json['durationMinutes'] as int,
      videoUrl: json['videoUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isLocked: json['isLocked'] as bool? ?? false,
    );
  }
}