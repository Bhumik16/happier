import 'package:logger/logger.dart';
import '../config/cloudinary_config.dart';

/// ====================
/// CLOUDINARY SERVICE
/// ====================
/// 
/// Service for generating Cloudinary URLs for images, videos, and audio files

class CloudinaryService {
  static final Logger _logger = Logger();
  static bool _isInitialized = false;
  
  static const String _baseFolder = 'happier_meditation';
  
  // ====================
  // INITIALIZE
  // ====================
  
  static void initialize() {
    if (_isInitialized) {
      _logger.w('Cloudinary already initialized');
      return;
    }
    
    if (!CloudinaryConfig.isConfigured) {
      _logger.e(CloudinaryConfig.configStatus);
      throw Exception('Cloudinary credentials not configured');
    }
    
    _isInitialized = true;
    _logger.i('✅ Cloudinary initialized: ${CloudinaryConfig.cloudName}');
  }
  
  // ====================
  // GET IMAGE URL
  // ====================
  
  static String getImageUrl(
    String publicId, {
    int? width,
    int? height,
    String format = 'jpg',
    String quality = 'auto',
  }) {
    if (!_isInitialized) {
      _logger.w('Cloudinary not initialized');
      return '';
    }
    
    try {
      // Build transformation parameters manually for reliability
      final transformations = <String>[];
      
      // Add quality
      transformations.add('q_$quality');
      
      // Add format
      transformations.add('f_$format');
      
      // Add dimensions if provided
      if (width != null || height != null) {
        transformations.add('w_${width ?? 800}');
        transformations.add('h_${height ?? 600}');
        transformations.add('c_fill');
        transformations.add('g_auto');
      }
      
      final transformString = transformations.join(',');
      
      // Construct URL manually
      final url = 'https://res.cloudinary.com/${CloudinaryConfig.cloudName}/image/upload/$transformString/$publicId.$format';
      
      return url;
    } catch (e) {
      _logger.e('Error generating image URL: $e');
      return '';
    }
  }
  
  // ====================
  // GET VIDEO URL
  // ====================
  
  static String getVideoUrl(String publicId) {
    if (!_isInitialized) {
      _logger.w('Cloudinary not initialized');
      return '';
    }
    
    try {
      // Build video URL manually
      final transformations = 'q_auto,f_mp4';
      final url = 'https://res.cloudinary.com/${CloudinaryConfig.cloudName}/video/upload/$transformations/$publicId.mp4';
      
      return url;
    } catch (e) {
      _logger.e('Error generating video URL: $e');
      return '';
    }
  }
  
  // ====================
  // GET AUDIO URL
  // ====================
  
  static String getAudioUrl(String publicId) {
    if (!_isInitialized) {
      _logger.w('Cloudinary not initialized');
      return '';
    }
    
    try {
      // ✅ FIXED: Audio files uploaded to 'video' resource type
      // Cloudinary treats MP3 as video format when uploaded via standard upload
      final url = 'https://res.cloudinary.com/${CloudinaryConfig.cloudName}/video/upload/$publicId.mp3';
      
      return url;
    } catch (e) {
      _logger.e('Error generating audio URL: $e');
      return '';
    }
  }
  
  // ====================
  // HELPER METHODS - COURSE IMAGES
  // ====================
  
  /// Get course thumbnail/cover image URL
  static String getCourseImageUrl(String courseId) {
    final publicId = '$_baseFolder/images/courses/course_$courseId';
    return getImageUrl(publicId, width: 800, height: 600);
  }
  
  // ====================
  // HELPER METHODS - COURSE VIDEOS
  // ====================
  
  /// Get course session video URL
  static String getCourseVideoUrl(String courseId, int sessionNumber) {
    final publicId = '$_baseFolder/courses/$courseId/videos/session_$sessionNumber';
    return getVideoUrl(publicId);
  }
  
  /// Get intro video URL for a course
  /// ✅ FIXED - Removed /videos/ folder from path
  static String getIntroVideoUrl(String courseId) {
    final publicId = '$_baseFolder/courses/$courseId/intro_video';
    return getVideoUrl(publicId);
  }
  
  // ====================
  // HELPER METHODS - COURSE AUDIO
  // ====================
  
  /// Get course session audio URL
  /// @param audioFileName - The descriptive filename without extension
  /// Example: "session_1_intro_meditation"
  static String getCourseAudioUrl(String courseId, String audioFileName) {
    final publicId = '$_baseFolder/courses/$courseId/audios/$audioFileName';
    return getAudioUrl(publicId);
  }
  
  // ====================
  // HELPER METHODS - PLACEHOLDERS
  // ====================
  
  /// Get placeholder image URL
  /// @param type - The type of placeholder (e.g., "instructor", "course", "user")
  static String getPlaceholderUrl(String type) {
    final publicId = '$_baseFolder/images/placeholders/${type}_placeholder';
    return getImageUrl(publicId, width: 400, height: 400);
  }
  
  // ====================
  // HELPER METHODS - SINGLES
  // ====================
  
  /// Get singles meditation image URL
  static String getSingleImageUrl(String singleId) {
    final publicId = '$_baseFolder/images/singles/single_$singleId';
    return getImageUrl(publicId, width: 800, height: 600);
  }
  
  /// Get singles meditation audio URL
  static String getSingleAudioUrl(String singleId, String audioFileName) {
    final publicId = '$_baseFolder/singles/$singleId/audios/$audioFileName';
    return getAudioUrl(publicId);
  }
  
  // ====================
  // HELPER METHODS - SLEEP
  // ====================
  
  /// Get sleep session image URL
  static String getSleepImageUrl(String sleepId) {
    final publicId = '$_baseFolder/images/sleep/sleep_$sleepId';
    return getImageUrl(publicId, width: 800, height: 600);
  }
  
  /// Get sleep session video URL
  static String getSleepVideoUrl(String sleepId, String videoFileName) {
    final publicId = '$_baseFolder/sleep/$sleepId/videos/$videoFileName';
    return getVideoUrl(publicId);
  }
  
  /// Get instructor profile image URL
  static String getInstructorImageUrl(String instructorId) {
    final publicId = '$_baseFolder/images/instructors/instructor_$instructorId';
    return getImageUrl(publicId, width: 400, height: 400);
  }
  
  // ====================
  // HELPER METHODS - SHORTS
  // ====================
  
  /// Get shorts video URL
  static String getShortsVideoUrl(String shortId) {
    final publicId = '$_baseFolder/shorts/videos/short_$shortId';
    return getVideoUrl(publicId);
  }
  
  /// Get shorts thumbnail URL
  static String getShortsThumbnailUrl(String shortId) {
    final publicId = '$_baseFolder/images/shorts/short_${shortId}_thumb';
    return getImageUrl(publicId, width: 600, height: 800);
  }
  
  /// Get podcast cover image URL
  static String getPodcastCoverUrl(String podcastId) {
    final publicId = '$_baseFolder/images/podcasts/podcast_$podcastId';
    return getImageUrl(publicId, width: 600, height: 600);
  }
  
  // ====================
  // UTILITY METHODS
  // ====================
  
  /// Check if service is initialized
  static bool get isInitialized => _isInitialized;
  
  /// Get base folder path
  static String get baseFolder => _baseFolder;
  
  /// Test if a URL is valid
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('https://res.cloudinary.com/');
  }
  
  /// Get thumbnail from video URL
  static String getVideoThumbnail(String videoPublicId) {
    if (!_isInitialized) return '';
    
    try {
      // Cloudinary can generate video thumbnails
      final url = 'https://res.cloudinary.com/${CloudinaryConfig.cloudName}/video/upload/so_0,q_auto,f_jpg/$videoPublicId.jpg';
      return url;
    } catch (e) {
      _logger.e('Error generating video thumbnail: $e');
      return '';
    }
  }
}