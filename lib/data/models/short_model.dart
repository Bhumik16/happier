/// ====================
/// SHORT MODEL
/// ====================
/// 
/// Data model for shorts content (videos, wisdom clips, podcasts)

class ShortModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? instructor;
  final String? duration;
  final String? thumbnailImage;  // For videos/podcasts
  final List<String> gradientColors;  // For wisdom clips
  final String type;  // 'practice', 'wisdom', 'podcast'
  final String? description;

  ShortModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.instructor,
    this.duration,
    this.thumbnailImage,
    this.gradientColors = const [],
    required this.type,
    this.description,
  });

  // ====================
  // COMPUTED PROPERTIES
  // ====================
  
  bool get isPractice => type == 'practice';
  bool get isWisdom => type == 'wisdom';
  bool get isPodcast => type == 'podcast';

  // ====================
  // COPY WITH
  // ====================
  
  ShortModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? instructor,
    String? duration,
    String? thumbnailImage,
    List<String>? gradientColors,
    String? type,
    String? description,
  }) {
    return ShortModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      instructor: instructor ?? this.instructor,
      duration: duration ?? this.duration,
      thumbnailImage: thumbnailImage ?? this.thumbnailImage,
      gradientColors: gradientColors ?? this.gradientColors,
      type: type ?? this.type,
      description: description ?? this.description,
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
      'duration': duration,
      'thumbnailImage': thumbnailImage,
      'gradientColors': gradientColors,
      'type': type,
      'description': description,
    };
  }

  factory ShortModel.fromJson(Map<String, dynamic> json) {
    return ShortModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      instructor: json['instructor'] as String?,
      duration: json['duration'] as String?,
      thumbnailImage: json['thumbnailImage'] as String?,
      gradientColors: (json['gradientColors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      type: json['type'] as String,
      description: json['description'] as String?,
    );
  }
}