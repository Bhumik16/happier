/// ====================
/// WISDOM COLLECTION MODEL
/// ====================
/// 
/// Represents a collection of wisdom clips (e.g., "Equanimity")

class WisdomCollectionModel {
  final String id;
  final String title;
  final List<String> gradientColors;
  final String? description;

  WisdomCollectionModel({
    required this.id,
    required this.title,
    required this.gradientColors,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'gradientColors': gradientColors,
      'description': description,
    };
  }

  factory WisdomCollectionModel.fromJson(Map<String, dynamic> json) {
    return WisdomCollectionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      gradientColors: (json['gradientColors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      description: json['description'] as String?,
    );
  }
}