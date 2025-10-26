import '../../core/services/mock_singles_service.dart';
import '../../data/models/single_model.dart';

/// ====================
/// SINGLES REPOSITORY
/// ====================
/// 
/// Data access layer for singles

class SinglesRepository {
  
  /// ====================
  /// GET ALL SINGLES
  /// ====================
  
  Future<List<SingleModel>> getAllSingles() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return MockSinglesService.getSampleSingles();
    } catch (e) {
      throw Exception('Failed to fetch singles: $e');
    }
  }
  
  /// ====================
  /// GET BY CATEGORY
  /// ====================
  
  Future<List<SingleModel>> getSinglesByCategory(String category) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockSinglesService.getSinglesByCategory(category);
    } catch (e) {
      throw Exception('Failed to fetch singles by category: $e');
    }
  }
  
  /// ====================
  /// GET FOR YOU
  /// ====================
  
  Future<List<SingleModel>> getForYouSingles() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockSinglesService.getForYouSingles();
    } catch (e) {
      throw Exception('Failed to fetch for you singles: $e');
    }
  }
  
  /// ====================
  /// GET FEATURED
  /// ====================
  
  Future<List<SingleModel>> getFeaturedSingles() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockSinglesService.getFeaturedSingles();
    } catch (e) {
      throw Exception('Failed to fetch featured singles: $e');
    }
  }
  
  /// ====================
  /// GET BROWSE ALL
  /// ====================
  
  Future<List<SingleModel>> getBrowseAllSingles() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockSinglesService.getBrowseAllSingles();
    } catch (e) {
      throw Exception('Failed to fetch browse all singles: $e');
    }
  }
}