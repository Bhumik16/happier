import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

/// ====================
/// CLOUDINARY CONFIGURATION
/// ====================

class CloudinaryConfig {
  static final Logger _logger = Logger();

  static String get cloudName => dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static String get apiKey => dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  static String get apiSecret => dotenv.env['CLOUDINARY_API_SECRET'] ?? '';

  static bool get isConfigured {
    return cloudName.isNotEmpty && apiKey.isNotEmpty && apiSecret.isNotEmpty;
  }

  static String get configStatus {
    if (!isConfigured) {
      return '⚠️ Cloudinary credentials not found in .env file';
    }
    return '✅ Cloudinary configured successfully';
  }

  static void printConfig() {
    _logger.i('==================== CLOUDINARY CONFIG ====================');
    _logger.i(
      'Cloud Name: ${cloudName.isNotEmpty ? "✅ $cloudName" : "❌ Missing"}',
    );
    _logger.i(
      'API Key: ${apiKey.isNotEmpty ? "✅ ${apiKey.substring(0, 5)}..." : "❌ Missing"}',
    );
    _logger.i(
      'API Secret: ${apiSecret.isNotEmpty ? "✅ ${apiSecret.substring(0, 5)}..." : "❌ Missing"}',
    );
    _logger.i('Status: $configStatus');
    _logger.i('===========================================================');
  }
}
