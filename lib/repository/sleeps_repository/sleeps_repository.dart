import '../../core/services/mock_sleeps_service.dart';
import '../../data/models/sleep_model.dart';

/// ====================
/// SLEEPS REPOSITORY
/// ====================
/// 
/// Data access layer for sleep meditations

class SleepsRepository {
  
  /// ====================
  /// GET ALL SLEEPS
  /// ====================
  
  Future<List<SleepModel>> getAllSleeps() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return MockSleepsService.getSampleSleeps();
    } catch (e) {
      throw Exception('Failed to fetch sleeps: $e');
    }
  }
  
  /// ====================
  /// GET BY CATEGORY
  /// ====================
  
  Future<List<SleepModel>> getSleepsByCategory(String category) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockSleepsService.getSleepsByCategory(category);
    } catch (e) {
      throw Exception('Failed to fetch sleeps by category: $e');
    }
  }
  
  /// ====================
  /// GET FEATURED
  /// ====================
  
  Future<List<SleepModel>> getFeaturedSleeps() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockSleepsService.getFeaturedSleeps();
    } catch (e) {
      throw Exception('Failed to fetch featured sleeps: $e');
    }
  }
  
  /// ====================
  /// GET MEDITATIONS
  /// ====================
  
  Future<List<SleepModel>> getMeditationSleeps() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockSleepsService.getMeditationSleeps();
    } catch (e) {
      throw Exception('Failed to fetch meditation sleeps: $e');
    }
  }
}