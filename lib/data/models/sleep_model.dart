/// ====================
/// SLEEP MODEL
/// ====================
/// 
/// Data model for sleep meditation sessions

class SleepModel {
  final String id;
  final String title;
  final String instructor;
  final String instructorImage;
  final String durationRange;
  final String category;
  final String? description;
  final String? audioUrl;   // ✅ ADD (will be null for local assets)
  final String? imageUrl;   // ✅ ADD (will be null for local assets)

  SleepModel({
    required this.id,
    required this.title,
    required this.instructor,
    required this.instructorImage,
    required this.durationRange,
    this.category = 'meditations',
    this.description,
    this.audioUrl,
    this.imageUrl,
  });

  SleepModel copyWith({
    String? id,
    String? title,
    String? instructor,
    String? instructorImage,
    String? durationRange,
    String? category,
    String? description,
    String? audioUrl,
    String? imageUrl,
  }) {
    return SleepModel(
      id: id ?? this.id,
      title: title ?? this.title,
      instructor: instructor ?? this.instructor,
      instructorImage: instructorImage ?? this.instructorImage,
      durationRange: durationRange ?? this.durationRange,
      category: category ?? this.category,
      description: description ?? this.description,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructor': instructor,
      'instructorImage': instructorImage,
      'durationRange': durationRange,
      'category': category,
      'description': description,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
    };
  }

  factory SleepModel.fromJson(Map<String, dynamic> json) {
    return SleepModel(
      id: json['id'] as String,
      title: json['title'] as String,
      instructor: json['instructor'] as String,
      instructorImage: json['instructorImage'] as String,
      durationRange: json['durationRange'] as String,
      category: json['category'] as String? ?? 'meditations',
      description: json['description'] as String?,
      audioUrl: json['audioUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}