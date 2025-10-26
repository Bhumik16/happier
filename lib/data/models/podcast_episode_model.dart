/// ====================
/// PODCAST EPISODE MODEL
/// ====================
/// 
/// Model for individual podcast episodes

class PodcastEpisodeModel {
  final String id;
  final String title;
  final String podcastName;
  final String host;
  final String duration;
  final String date;  // e.g., "JANUARY 19"
  final String thumbnailImage;
  final String audioFile;  // Path to audio asset
  final String? description;

  PodcastEpisodeModel({
    required this.id,
    required this.title,
    required this.podcastName,
    required this.host,
    required this.duration,
    required this.date,
    required this.thumbnailImage,
    required this.audioFile,
    this.description,
  });

  // ====================
  // COPY WITH
  // ====================
  
  PodcastEpisodeModel copyWith({
    String? id,
    String? title,
    String? podcastName,
    String? host,
    String? duration,
    String? date,
    String? thumbnailImage,
    String? audioFile,
    String? description,
  }) {
    return PodcastEpisodeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      podcastName: podcastName ?? this.podcastName,
      host: host ?? this.host,
      duration: duration ?? this.duration,
      date: date ?? this.date,
      thumbnailImage: thumbnailImage ?? this.thumbnailImage,
      audioFile: audioFile ?? this.audioFile,
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
      'podcastName': podcastName,
      'host': host,
      'duration': duration,
      'date': date,
      'thumbnailImage': thumbnailImage,
      'audioFile': audioFile,
      'description': description,
    };
  }

  factory PodcastEpisodeModel.fromJson(Map<String, dynamic> json) {
    return PodcastEpisodeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      podcastName: json['podcastName'] as String,
      host: json['host'] as String,
      duration: json['duration'] as String,
      date: json['date'] as String,
      thumbnailImage: json['thumbnailImage'] as String,
      audioFile: json['audioFile'] as String,
      description: json['description'] as String?,
    );
  }
}