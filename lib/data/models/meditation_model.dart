import 'package:hive/hive.dart';

part 'meditation_model.g.dart'; // Generated file

/// ====================
/// MEDITATION MODEL
/// ====================
/// 
/// Represents a single meditation/course
/// Uses Hive for local storage with code generation
@HiveType(typeId: 0)
class MeditationModel extends HiveObject {
  
  // ====================
  // FIELDS
  // ====================
  
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String instructor;
  
  @HiveField(3)
  final String category; // COURSE, GUIDED MEDITATION, etc.
  
  @HiveField(4)
  final int sessionCount;
  
  @HiveField(5)
  final int durationMinutes;
  
  @HiveField(6)
  final bool isLocked;
  
  @HiveField(7)
  final bool hasImage;
  
  @HiveField(8)
  final String? imageUrl;
  
  @HiveField(9)
  final List<String> gradientColors; // Hex color strings
  
  @HiveField(10)
  final String type; // course, guided, practice, sleep
  
  @HiveField(11)
  final int? minDuration; // For range (10-30 min)
  
  @HiveField(12)
  final int? maxDuration;
  
  // ====================
  // CONSTRUCTOR
  // ====================
  
  MeditationModel({
    required this.id,
    required this.title,
    required this.instructor,
    required this.category,
    required this.sessionCount,
    required this.durationMinutes,
    required this.isLocked,
    required this.hasImage,
    this.imageUrl,
    required this.gradientColors,
    required this.type,
    this.minDuration,
    this.maxDuration,
  });
  
  // ====================
  // COMPUTED PROPERTIES
  // ====================
  
  /// Get duration text (e.g., "10 - 30 min" or "10 min")
  String get durationText {
    if (minDuration != null && maxDuration != null) {
      return '$minDuration - $maxDuration min';
    }
    return '$durationMinutes min';
  }
  
  /// Get session count text (e.g., "7 SESSIONS")
  String get sessionText {
    return '$sessionCount SESSION${sessionCount > 1 ? 'S' : ''}';
  }
  
  // ====================
  // COPYSWITH (Immutability)
  // ====================
  
  MeditationModel copyWith({
    String? id,
    String? title,
    String? instructor,
    String? category,
    int? sessionCount,
    int? durationMinutes,
    bool? isLocked,
    bool? hasImage,
    String? imageUrl,
    List<String>? gradientColors,
    String? type,
    int? minDuration,
    int? maxDuration,
  }) {
    return MeditationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      category: category ?? this.category,
      sessionCount: sessionCount ?? this.sessionCount,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isLocked: isLocked ?? this.isLocked,
      hasImage: hasImage ?? this.hasImage,
      imageUrl: imageUrl ?? this.imageUrl,
      gradientColors: gradientColors ?? this.gradientColors,
      type: type ?? this.type,
      minDuration: minDuration ?? this.minDuration,
      maxDuration: maxDuration ?? this.maxDuration,
    );
  }
  
  // ====================
  // JSON SERIALIZATION (for Firebase/API)
  // ====================
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructor': instructor,
      'category': category,
      'sessionCount': sessionCount,
      'durationMinutes': durationMinutes,
      'isLocked': isLocked,
      'hasImage': hasImage,
      'imageUrl': imageUrl,
      'gradientColors': gradientColors,
      'type': type,
      'minDuration': minDuration,
      'maxDuration': maxDuration,
    };
  }
  
  factory MeditationModel.fromJson(Map<String, dynamic> json) {
    return MeditationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      instructor: json['instructor'] as String,
      category: json['category'] as String,
      sessionCount: json['sessionCount'] as int,
      durationMinutes: json['durationMinutes'] as int,
      isLocked: json['isLocked'] as bool,
      hasImage: json['hasImage'] as bool,
      imageUrl: json['imageUrl'] as String?,
      gradientColors: List<String>.from(json['gradientColors'] as List),
      type: json['type'] as String,
      minDuration: json['minDuration'] as int?,
      maxDuration: json['maxDuration'] as int?,
    );
  }
  
  @override
  String toString() {
    return 'MeditationModel(id: $id, title: $title, instructor: $instructor)';
  }
}