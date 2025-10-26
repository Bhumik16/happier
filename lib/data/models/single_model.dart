/// ====================
/// SINGLE MODEL
/// ====================
/// 
/// Data model for individual meditation singles and categories

class SingleModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? instructor;
  final int? durationMinutes;
  final List<String> gradientColors;
  final String category;  // 'for_you', 'featured', 'browse_all'
  final String? description;
  final bool isFavorite;
  final bool isRecentlyPlayed;

  SingleModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.instructor,
    this.durationMinutes,
    required this.gradientColors,
    this.category = 'browse_all',
    this.description,
    this.isFavorite = false,
    this.isRecentlyPlayed = false,
  });

  // ====================
  // COMPUTED PROPERTIES
  // ====================
  
  String get durationText {
    if (durationMinutes == null) return '';
    return '$durationMinutes min';
  }

  // ====================
  // COPY WITH (Immutability)
  // ====================
  
  SingleModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? instructor,
    int? durationMinutes,
    List<String>? gradientColors,
    String? category,
    String? description,
    bool? isFavorite,
    bool? isRecentlyPlayed,
  }) {
    return SingleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      instructor: instructor ?? this.instructor,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      gradientColors: gradientColors ?? this.gradientColors,
      category: category ?? this.category,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      isRecentlyPlayed: isRecentlyPlayed ?? this.isRecentlyPlayed,
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
      'durationMinutes': durationMinutes,
      'gradientColors': gradientColors,
      'category': category,
      'description': description,
      'isFavorite': isFavorite,
      'isRecentlyPlayed': isRecentlyPlayed,
    };
  }

  factory SingleModel.fromJson(Map<String, dynamic> json) {
    return SingleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      instructor: json['instructor'] as String?,
      durationMinutes: json['durationMinutes'] as int?,
      gradientColors: (json['gradientColors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      category: json['category'] as String? ?? 'browse_all',
      description: json['description'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isRecentlyPlayed: json['isRecentlyPlayed'] as bool? ?? false,
    );
  }
}