import '../../core/services/mock_shorts_service.dart';
import '../../data/models/short_model.dart';

/// ====================
/// SHORTS REPOSITORY
/// ====================
/// 
/// Data access layer for shorts content

class ShortsRepository {
  
  /// ====================
  /// GET ALL SHORTS
  /// ====================
  
  Future<List<ShortModel>> getAllShorts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return MockShortsService.getSampleShorts();
    } catch (e) {
      throw Exception('Failed to fetch shorts: $e');
    }
  }
  
  /// ====================
  /// GET BY TYPE
  /// ====================
  
  Future<List<ShortModel>> getShortsByType(String type) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockShortsService.getShortsByType(type);
    } catch (e) {
      throw Exception('Failed to fetch shorts by type: $e');
    }
  }
  
  /// ====================
  /// GET PRACTICE SHORTS
  /// ====================
  
  Future<List<ShortModel>> getPracticeShorts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockShortsService.getPracticeShorts();
    } catch (e) {
      throw Exception('Failed to fetch practice shorts: $e');
    }
  }
  
  /// ====================
  /// GET WISDOM SHORTS
  /// ====================
  
  Future<List<ShortModel>> getWisdomShorts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockShortsService.getWisdomShorts();
    } catch (e) {
      throw Exception('Failed to fetch wisdom shorts: $e');
    }
  }
  
  /// ====================
  /// GET PODCAST SHORTS
  /// ====================
  
  Future<List<ShortModel>> getPodcastShorts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockShortsService.getPodcastShorts();
    } catch (e) {
      throw Exception('Failed to fetch podcast shorts: $e');
    }
  }
}