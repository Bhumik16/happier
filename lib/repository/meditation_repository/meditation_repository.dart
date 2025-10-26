import 'package:logger/logger.dart';
import '../../core/services/mock_data_service.dart';
import '../../data/models/meditation_model.dart';

/// ====================
/// MEDITATION REPOSITORY
/// ====================
/// 
/// Handles data access for meditations
/// Currently uses mock data, will integrate Firebase + Hive later
class MeditationRepository {
  final Logger _logger = Logger();
  
  // ====================
  // GET ALL MEDITATIONS
  // ====================
  
  Future<List<MeditationModel>> getAllMeditations() async {
    try {
      _logger.i('📚 Loading meditations...');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final meditations = MockDataService.getSampleMeditations();
      
      _logger.i('✅ Loaded ${meditations.length} meditations');
      
      return meditations;
      
    } catch (e) {
      _logger.e('❌ Error loading meditations: $e');
      return [];
    }
  }
  
  // ====================
  // GET MEDITATION BY ID
  // ====================
  
  Future<MeditationModel?> getMeditationById(String id) async {
    try {
      final meditations = await getAllMeditations();
      return meditations.firstWhere((m) => m.id == id);
    } catch (e) {
      _logger.e('Error getting meditation by ID: $e');
      return null;
    }
  }
}